module SymbolicsExt # Should be same name as the file (just like a normal package)

using SymbolicUtils: Symbolic
using Symbolics: Num, wrap, unwrap
import ConvertSymbolics: convertterm, common2leaf, BaseNumbertypes

convertterm(T, a::Num) = convertterm(T, unwrap(a))
convertterm(::Type{Num}, b) = wrap(convertterm(Symbolic{Real}, b))
convertterm(::Type{Num}, a::Num) = a
convertterm(::Type{Num}, a::BaseNumbertypes) = a

# probably not really necessary, normally the definitions above should
# capture all, but for testint purposes...
common2leaf(::Type{Num}, a::Symbol) = wrap(common2leaf(Symbolic{Real}, a))


end # module
