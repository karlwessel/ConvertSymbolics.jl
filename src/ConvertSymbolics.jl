module ConvertSymbolics
export BaseNumbertypes, convertterm
using TermInterface

struct Differential
    ivs
    Differential(x::Array) = new(sort(x))
end

Base.show(io::IO, D::Differential) = length(D.ivs) == 1 ? print(io, "∂_$(join(D.ivs))") : print(io, "∂_[$(join(D.ivs))]")

BaseNumbertypes = Union{Int64, Float64, Rational{Int64}, Irrational, Complex{Int64}, Complex{Float64}, Complex{Bool}}
const CommonCallable = Union{Symbol, Function, Differential}
const CommonLeaf = Union{Symbol, BaseNumbertypes}

convertleaf(T, a) = common2leaf(T, leaf2common(a)::CommonLeaf)
function convertcall(T, op, args)
    cop = call2common(op)::CommonCallable
    common2call(T, cop, map(x -> convertterm(T, x), args))
end
function convertterm(T, a)
    if iscall(a)
        convertcall(T, operation(a), arguments(a))
    else
        convertleaf(T, a)
    end
end

# shortcut
convertterm(::Type{T}, a::T) where T = a

# this intermediate function is just so that constants from Base
# can be evaluated, this is necessary when converting from Expr
leaf2common(a) = Symbol(repr(a))
leaf2common(a::BaseNumbertypes) = a

call2common(f::Function) = f
call2common(f) = throw("Define how symbolic callables of type $(typeof(f)) are transformed to a $CommonCallable by implementing`call2common(op::$(typeof(f)))::CommonCallable`")

common2leaf(T, ::Symbol) = throw("Define how symbolic variables of type $(typeof(T)) are created from a symbol by implementing `common2leaf(a::$(typeof(T)), symbol::Symbol)`")
common2leaf(T, ::BaseNumbertypes) = throw("Decide how concrete numbers are represented as $(typeof(T)) by implementing `common2leaf(a::$(typeof(T)), n::BaseNumbertypes)`. Most time numbers can be passed as is, so `convertop(a::$(typeof(T)), n::BaseNumbertypes) = n` will suffice.")

common2leaf(T::Type, ::Symbol) = throw("Define how symbolic variables of type $T are created from a symbol by implementing `common2leaf(a::Type{$T}, symbol::Symbol)`")
common2leaf(T::Type, ::BaseNumbertypes) = throw("Decide how concrete numbers are represented as $T by implementing `common2leaf(a::Type{$T}, n::BaseNumbertypes)`. Most time numbers can be passed as is, so `convertop(a::Type{$T}, n::BaseNumbertypes) = n` will suffice.")

common2call(T, op::Function, args) = op(args...)
common2call(T, ::Symbol, args) = throw("Define how symbolic callables of type $T are created from a symbol by implementing `common2call(a::Type{$T}, symbol::Symbol, args)`")

# implementation for TermInterfaces Expr representation
common2leaf(::Type{Expr}, a::BaseNumbertypes) = a
common2leaf(::Type{Expr}, a::Symbol) = a

call2common(op::Symbol) = isdefined(Base, op) ? eval(op) : op
leaf2common(a::Symbol) = isdefined(Base, a) ? eval(a) : a
common2call(::Type{Expr}, op::Function, args) = common2call(Expr, Symbol(op), args)
common2call(::Type{Expr}, op::Symbol, args) = maketerm(Expr, :call, [op, args...], metadata(first(args)))
common2call(::Type{Expr}, op::Differential, args) = maketerm(Expr, :call, [op, args...], metadata(first(args)))

#include("SymbolicChimeras.jl")
end
