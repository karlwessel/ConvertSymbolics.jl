module SymbolicUtilsExt # Should be same name as the file (just like a normal package)

using SymbolicUtils: Symbolic, Sym, FnType
using ConvertSymbolics
import ConvertSymbolics: convertsymbol, convertcallable

convertsymbol(::Type{Symbolic}, a::BaseNumbertypes) = a
convertsymbol(T::Type{Symbolic}, a::String) = convertsymbol(T, Symbol(a))
convertsymbol(T::Type{Symbolic}, a::Symbol) = Sym{Number}(a)

convertcallable(T::Type{Symbolic}, fn::Symbol, args) = Sym{FnType{NTuple{length(args), Number}, Number, Nothing}}(fn)

end # module
