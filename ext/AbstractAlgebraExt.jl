module AbstractAlgebraExt
using AbstractAlgebra
using TermInterface
using ConvertSymbolics
using TermInterfaceImpls
TIIAbstractAlgebraExt = Base.get_extension(TermInterfaceImpls, :AbstractAlgebraExt)
@assert !isnothing(TIIAbstractAlgebraExt)


# conversion
ConvertSymbolics.leaf2common(a::Rational{BigInt}) = Rational{Int64}(a)
function ConvertSymbolics.leaf2common(a::UniversalPolyRingElem)
    is_gen(a) && return Symbol(repr(a))
    iszero(a) && return 0
    c = only(TIIAbstractAlgebraExt.nonzerocoeffs(a))
    TIIAbstractAlgebraExt.tonumber(c)
end
ConvertSymbolics.common2leaf(R::UniversalPolyRing, s::Symbol) = gen(R, s)
ConvertSymbolics.common2leaf(t::AbstractAlgebra.Generic.UnivPoly{T}, s) where T = ConvertSymbolics.common2leaf(parent(t), s)
ConvertSymbolics.common2leaf(R::UniversalPolyRing, s::BaseNumbertypes) = s

ConvertSymbolics.common2call(t::AbstractAlgebra.Generic.UnivPoly{T}, op, args) where T = ConvertSymbolics.common2call(parent(t), op, args)
function ConvertSymbolics.common2call(R::UniversalPolyRing, D::ConvertSymbolics.Differential, args)
    arg = only(args)
    for iv in D.ivs
        arg = derivative(arg, convertterm(R, iv))
    end
    arg
end
end
