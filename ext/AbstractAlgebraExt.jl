module AbstractAlgebraExt
using AbstractAlgebra
using TermInterface
using ConvertSymbolics
using TermInterfaceImpls
TIIAbstractAlgebraExt = Base.get_extension(TermInterfaceImpls, :AbstractAlgebraExt)
@assert !isnothing(TIIAbstractAlgebraExt)

getgen(R::UniversalPolyRing, s::Symbol) = gen(R, s)
function getgen(R, s::Symbol)
    i = only(indexin([s], symbols(R)))
    if isnothing(i)
        @info s, symbols(R)
        @assert !isnothing(i)
    end
    gens(R)[i]
end

PolyLikeRing = Union{UniversalPolyRing, LaurentMPolyRing, MPolyRing}
PolyLike = Union{UniversalPolyRingElem, LaurentMPolyRingElem, MPolyRingElem}

# conversion
ConvertSymbolics.leaf2common(a::Rational{BigInt}) = Rational{Int64}(a)
function ConvertSymbolics.leaf2common(a::PolyLike)
    iszero(a) && return 0
    R = parent(a)
    idx = only(indexin([a], gens(R)))
    isnothing(idx) || return symbols(R)[idx]
    c = only(TIIAbstractAlgebraExt.nonzerocoeffs(a))
    TIIAbstractAlgebraExt.tonumber(c)
end
ConvertSymbolics.common2leaf(R::PolyLikeRing, s::Symbol) = getgen(R, s)
ConvertSymbolics.common2leaf(t::AbstractAlgebra.Generic.UnivPoly{T}, s) where T = ConvertSymbolics.common2leaf(parent(t), s)
ConvertSymbolics.common2leaf(R::PolyLikeRing, s::BaseNumbertypes) = s
ConvertSymbolics.common2leaf(R::PolyLikeRing, s::Complex{Int64}) = coefficient_ring(R)(s)
ConvertSymbolics.common2leaf(R::PolyLikeRing, s::Complex{Bool}) = isreal(s) ? s : ConvertSymbolics.common2leaf(R, 1*s)

ConvertSymbolics.common2call(t::AbstractAlgebra.Generic.UnivPoly{T}, op, args) where T = ConvertSymbolics.common2call(parent(t), op, args)
function ConvertSymbolics.common2call(R::UniversalPolyRing, D::ConvertSymbolics.Differential, args)
    arg = only(args)
    for iv in D.ivs
        arg = derivative(arg, convertterm(R, iv))
    end
    arg
end
end
