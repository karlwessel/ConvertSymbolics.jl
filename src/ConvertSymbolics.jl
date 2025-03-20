module ConvertSymbolics
export BaseNumbertypes, convertterm
using TermInterface

function convertterm(T, a)
    if iscall(a)
        op = convertcallable(T, operation(a))
        convertop(T, op, map(x -> convertterm(T, x), arguments(a)))
    else
        _convertsymbol(T, a)
    end
end

# shortcut
convertterm(::Type{T}, a::T) where T = a

# this intermediate function is just so that constants from Base
# can be evaluated, this is necessary when converting from Expr
_convertsymbol(T, a) = convertsymbol(T, a)
_convertsymbol(T, a::Symbol) = isdefined(Base, a) ? convertsymbol(T, eval(a)) : convertsymbol(T, a)
convertcallable(T, op) = op
function convertcallable(T, op::Symbol)
    if isdefined(Base, op)
        return eval(op)
    else
        return op
    end
end

convertsymbol(T, a) = convertsymbol(T, repr(a))

convertsymbol(T, a::String) = throw("Define how symbolic variables of type $T are created from a string by implementing `convertsymbol(a::Type{$T}, symbol::String)`")

BaseNumbertypes = Union{Int64, Float64, Rational{Int64}, Irrational, Complex{Int64}, Complex{Float64}, Complex{Bool}}
convertsymbol(T, a::BaseNumbertypes) = throw("Decide how concrete numbers are represented as $T by implementing `convertop(a::Type{$T}, n::BaseNumbertypes)`. Most time numbers can be passed as is, so `convertop(a::Type{$T}, n::BaseNumbertypes) = n` will suffice.")

convertop(T, op, args) = op(args...)

convertcallable(T, fn, args) = throw("Implement how symbolic functions are represented as $T by implementing `convertcallable(a::Type{$T}, fn, args)`.")

# implementation for TermInterfaces Expr representation
convertsymbol(::Type{Expr}, a::BaseNumbertypes) = a
convertsymbol(::Type{Expr}, a::String) = Symbol(a)
convertsymbol(::Type{Expr}, a::Symbol) = a

convertop(::Type{Expr}, op, args) = maketerm(Expr, :call, [convertsymbol(Expr, op), args...], metadata(first(args)))

convertop(::Type{Expr}, op::Symbol, args) = maketerm(Expr, :call, [op, args...], metadata(first(args)))
end
