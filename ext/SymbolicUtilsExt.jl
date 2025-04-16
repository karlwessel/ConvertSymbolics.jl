module SymbolicUtilsExt # Should be same name as the file (just like a normal package)

using SymbolicUtils: Symbolic, Sym, FnType
using ConvertSymbolics
import ConvertSymbolics: common2leaf, call2common, common2call

common2leaf(::Type{Symbolic{T}}, a::BaseNumbertypes) where T = a
common2leaf(::Type{Symbolic{T}}, a::Symbol) where T = Sym{T}(a)

call2common(op::Symbolic{FnType{NTuple{N, T}, T, Nothing}}) where {N, T} = nameof(op)
common2call(::Type{Symbolic{T}}, fn::Symbol, args) where T = Sym{FnType{NTuple{length(args), T}, T, Nothing}}(fn)(args...)
end # module
