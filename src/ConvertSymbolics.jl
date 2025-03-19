module ConvertSymbolics
export BaseNumbertypes, convertterm
using TermInterface

function convertterm(T, a)
    if iscall(a)
        convertop(T, operation(a), map(x -> convertterm(T, x), arguments(a)))
    else
        _convertsymbol(T, a)
    end
end

# this intermediate function is just so that constants from Base
# can be evaluated, this is necessary when converting from Expr
_convertsymbol(T, a) = convertsymbol(T, a)
_convertsymbol(T, a::Symbol) = isdefined(Base, a) ? convertsymbol(T, eval(a)) : convertsymbol(T, a)

convertsymbol(T, a) = convertsymbol(T, repr(a))

convertsymbol(T, a::String) = throw("Define how symbolic variables of type $T are created from a string by implementing `convertop(a::$T, symbol::String)`")

BaseNumbertypes = Union{Int64, Float64, Rational{Int64}, Irrational, Complex{Int64}, Complex{Float64}, Complex{Bool}}
convertsymbol(T, a::BaseNumbertypes) = throw("Decide how concrete numbers are represented as $T by implementing `convertop(a::$T, n::BaseNumbertypes)`. Most time numbers can be passed as is, so `convertop(a::$T, n::BaseNumbertypes) = n` will suffice.")

convertop(T, op, args) = op(args...)

convertcallable(T, fn, args) = throw("Implement how symbolic functions are represented as $T by implementing `convertcallable(a::$T, fn, args)`.")

# implementation for TermInterfaces Expr representation
convertsymbol(::Type{Expr}, a::BaseNumbertypes) = a
convertsymbol(::Type{Expr}, a::String) = Symbol(a)
convertsymbol(::Type{Expr}, a::Symbol) = a

convertop(::Type{Expr}, op, args) = maketerm(Expr, :call, [convertsymbol(Expr, op), args...], metadata(first(args)))
function convertop(T, op::Symbol, args)
    if isdefined(Base, op)
        return convertop(T, eval(op), args)
    else
        fn = convertcallable(T, op, args)
        return convertop(T, fn, args)
    end
end
end
