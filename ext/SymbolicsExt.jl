module SymbolicsExt # Should be same name as the file (just like a normal package)

using SymbolicUtils: Symbolic, Sym, FnType
using Symbolics: Num, wrap, unwrap, Equation
import Symbolics
import ConvertSymbolics: call2common, convertterm, common2call, common2leaf, BaseNumbertypes
import ConvertSymbolics
common2leaf(::Type{Num}, a::BaseNumbertypes) = a
common2leaf(::Type{Num}, a::Symbol) = wrap(common2leaf(Symbolic{Real}, a))

common2call(::Type{Num}, fn::Symbol, args) = wrap(Sym{FnType{NTuple{length(args), Any}, Real}}(fn))(args...)

convertterm(T, a::Num) = convertterm(T, unwrap(a))
convertterm(T, a::Equation) = throw(ErrorException("Don't know how to convert an Equation!"))

call2common(op::Symbolics.Differential) = ConvertSymbolics.Differential([convertterm(Expr, op.x)])
#=
convertterm(::Type{Num}, b) = wrap(convertterm(Symbolic{Real}, b))
convertterm(::Type{Num}, a::BaseNumbertypes) = a

# probably not really necessary, normally the definitions above should
# capture all, but for testint purposes...
common2leaf(::Type{Num}, a::Symbol) = wrap(common2leaf(Symbolic{Real}, a))
=#

end # module
