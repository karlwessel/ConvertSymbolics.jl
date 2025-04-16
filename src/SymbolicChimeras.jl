
using TermInterface
using SymbolicUtils

struct SymbolicChimera{T, F, P, C}
    term::T
    substs::Dict{T, Union{C, F, P, SymbolicChimera}}
end
Base.show(io::IO, c::SymbolicChimera) = iscall(c) ? SymbolicUtils.show_term(io, c) : show(io, term(c))
SymbolicChimera(x::T) where {T} = SymbolicChimera{T, T, T, Union{}}(x, Dict())
Fallback(x::T, F) where {T} = SymbolicChimera{T, F, T, Union{}}(x, Dict())
term(n::SymbolicChimera) = n.term

forwardop(c::SymbolicChimera, op) = haskey(c.substs, term(c)) ? op(c.substs[term(c)]) : op(term(c))
TermInterface.isexpr(c::SymbolicChimera) = iscall(c)
TermInterface.iscall(c::SymbolicChimera) = forwardop(c, iscall)
TermInterface.operation(c::SymbolicChimera) = forwardop(c, operation)
TermInterface.arguments(c::SymbolicChimera{T, F, P, C}) where {T, F, P, C} = [SymbolicChimera{T, F, P, C}(x, c.substs) for x in forwardop(c, arguments)]

function makeop(op, arg::SymbolicChimera{T, F, P, C}) where {T, F, P, C}
    try
        r = op(term(arg))
        return SymbolicChimera{T, F, P, C}(r, arg.substs)
    catch e
        if e isa MethodError && T != F
            name = common2leaf(F, Symbol(repr(arg)))
            Farg = SymbolicChimera{F, F, P, C}(name, Dict([name => arg]))
            return op(Farg)
        else
            rethrow(e)
        end
    end
end

SymbolicUtils.@number_methods(SymbolicChimera, makeop(f, a), makeop(f, a, b), skipbasics)
