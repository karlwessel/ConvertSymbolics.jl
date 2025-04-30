module AbstractAlgebraExt
using AbstractAlgebra
using TermInterface

function nonzerocoeffswithexp(x)
	[(i-1, c) for (i, c) in enumerate(coefficients(x)) if !iszero(c)]
end

function isconst(p::RingElem)
    cs = nonzerocoeffswithexp(p)
    length(cs) == 0 && return true
    length(cs) > 1 && return false
    e, c = only(cs)
    e == 0
end

TermInterface.isexpr(x::RingElem) = iscall(x)

# univariate polys
const UnivariatePolylike = Union{PolyRingElem, LaurentPolyRingElem, SeriesElem}

TermInterface.iscall(x::UnivariatePolylike) = !(is_gen(x) || isconst(x))

function TermInterface.operation(x::UnivariatePolylike)
	c = nonzerocoeffswithexp(x)
	length(c) > 1 && return (+)

	e, c = only(c)
	isone(c) && return ^
	return *
end

function TermInterface.arguments(x::UnivariatePolylike)
	cs = nonzerocoeffswithexp(x)
	v = gen(parent(x))
	if length(cs) > 1		
		return [c*v^e for (e, c) in cs]
	end

	e, c = only(cs)
	isone(c) && return [v, e]
	return [c, v^e]
end

# poly
isconst(p::PolyRingElem) = degree(p) <= 0

# Laurent poly
function nonzerocoeffswithexp(x::LaurentPolyRingElem)
	[(i, coeff(x, i)) for i in Generic.terms_degrees(x) if !iszero(coeff(x, i))]
end


# multivariate polys
const Polylike = Union{UniversalPolyRingElem, LaurentMPolyRingElem, AbstractAlgebra.MSeriesElem,
MPolyRingElem}

iscoeffonly(p::Polylike) = length(p) == 0 || length(p) == 1 && isone(only(monomials(p)))
iscoeffonly(p) = false

nonzerocoeffs(x) = coefficients(x)

numnonzerocoeffs(x) = length(nonzerocoeffs(x))

tonumber(x::Polylike) = coefficient(x)
tonumber(x) = Rational(QQ(real(x))) + im*Rational(QQ(imag(x)))

function coefficient(p::RingElem)
	numnonzerocoeffs(p) == 0 && return 0
	c = only(nonzerocoeffs(p))
	iscall(c) || !iscoeffonly(c) ? c : tonumber(c)
end

TermInterface.iscall(x::Polylike) = !(is_gen(x) || iscoeffonly(x) && !iscall(coefficient(x)))

powers(m) = [(v, e) for (v, e) in zip(gens(parent(m)), only(exponent_vectors(m))) if !iszero(e)]

function TermInterface.operation(x::Polylike)
    if numnonzerocoeffs(x) == 1 #e.g. 2xy^2
		c = coefficient(x)
		iscoeffonly(x) && return operation(c)

        if length(powers(x)) == 1 && isone(c) #e.g. y^2 or sin(y)^2
            return (^)
        else
            return (*)
        end
    else # e.g. x+y
        return (+)
    end
end

function TermInterface.arguments(x::Polylike)
    if numnonzerocoeffs(x) == 1
        c = coefficient(x)
		iscoeffonly(x) && return arguments(c)
		
        m = only(monomials(x))

        if !isone(c)
            [c, m]
        else
			pows = powers(m)
            if length(pows) == 1
                v, e = only(pows)
                return [v, e]
            else
                return [v^pow for (v, pow) in pows]
            end
        end
    else
        ts = terms(x)
        return [iscoeffonly(t) ? coefficient(t) : t for t in ts]
    end
end

powers(m::MPolyRingElem) = zip(vars(m), filter(x -> !iszero(x), exponent_vector(m, 1)))

AbstractAlgebra.monomials(x::AbstractAlgebra.MSeriesElem) = [prod(gens(parent(x)) .^ e) for e in exponent_vectors(x)]
AbstractAlgebra.terms(x::AbstractAlgebra.MSeriesElem) = monomials(x) .* nonzerocoeffs(x)

end