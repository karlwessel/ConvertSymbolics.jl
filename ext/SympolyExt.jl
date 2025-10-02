module SympolyExt
using Sympoly
using ConvertSymbolics

ConvertSymbolics.leaf2common(a::Polyform) = ConvertSymbolics.leaf2common(a.p)
ConvertSymbolics.common2leaf(::Type{Polyform}, s::BaseNumbertypes) = s
ConvertSymbolics.common2leaf(::Type{Polyform}, s::Symbol) = Polyform(s)
ConvertSymbolics.common2call(::Type{Polyform}, s::Symbol, args) = Functional(s)(args...)

end
