module SymbolicUtilsExt # Should be same name as the file (just like a normal package)

using SymbolicUtils: Symbolic, Sym, FnType
using ConvertSymbolics
import ConvertSymbolics: convertsymbol, convertcallable, convertop

convertsymbol(::Type{Symbolic{T}}, a::BaseNumbertypes) where T = a
convertsymbol(S::Type{Symbolic{T}}, a::String) where T = convertsymbol(S, Symbol(a))
convertsymbol(::Type{Symbolic{T}}, a::Symbol) where T = Sym{T}(a)

convertop(::Type{Symbolic{T}}, fn::Symbol, args) where T = Sym{FnType{NTuple{length(args), T}, T, Nothing}}(fn)(args...)

convertcallable(S, op::Symbolic{FnType{NTuple{N, T}, T, Nothing}}) where {N, T} = nameof(op)
end # module
