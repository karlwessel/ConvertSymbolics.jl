module SymbolicUtilsExt # Should be same name as the file (just like a normal package)

using SymbolicUtils: Symbolic, Sym, FnType, symtype
using ConvertSymbolics
import ConvertSymbolics: common2leaf, call2common, common2call

common2leaf(::Type{T}, a::BaseNumbertypes) where T <: Symbolic  = a
common2leaf(::Type{T}, a::Symbol) where T <: Symbolic{S} where S = Sym{S}(a)

call2common(op::Symbolic{FnType{NTuple{N, S}, T}}) where {N, S, T} = nameof(op)
function common2call(t::Type{S}, fn::Symbol, args) where {S <: Symbolic}
    T = symtype(t)
    Sym{FnType{NTuple{length(args), T}, T}}(fn)(args...)
end
end # module
