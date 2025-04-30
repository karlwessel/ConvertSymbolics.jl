module AbstractAlgebraExt
using AbstractAlgebra
using TermInterface

function isconst(p::RingElem)
    cs = nonzerocoeffswithexp(p)
    length(cs) == 0 && return true
    length(cs) > 1 && return false
    e, c = only(cs)
    e == 0
end

TermInterface.isexpr(x::RingElem) = iscall(x)

# poly
isconst(p::PolyRingElem) = degree(p) <= 0
TermInterface.iscall(x::PolyRingElem) = !(is_gen(x) || isconst(x))

function nonzerocoeffswithexp(x)
	[(i-1, c) for (i, c) in enumerate(coefficients(x)) if !iszero(c)]
end

function TermInterface.operation(x::PolyRingElem)
	c = nonzerocoeffswithexp(x)
	length(c) > 1 && return (+)

	e, c = only(c)
	isone(c) && return ^
	return *
end

function TermInterface.arguments(x::PolyRingElem)
	cs = nonzerocoeffswithexp(x)
	v = gen(parent(x))
	if length(cs) > 1		
		return [c*v^e for (e, c) in cs]
	end

	e, c = only(cs)
	isone(c) && return [v, e]
	return [c, v^e]
end

# Laurtent poly
TermInterface.iscall(x::LaurentPolyRingElem) = !(is_gen(x) || isconst(x))

function nonzerocoeffswithexp(x::LaurentPolyRingElem)
	[(i, coeff(x, i)) for i in Generic.terms_degrees(x) if !iszero(coeff(x, i))]
end

function TermInterface.operation(x::LaurentPolyRingElem)
	c = nonzerocoeffswithexp(x)
	length(c) > 1 && return (+)

	e, c = only(c)
	isone(c) && return ^
	return *
end

function TermInterface.arguments(x::LaurentPolyRingElem)
	cs = nonzerocoeffswithexp(x)
	v = gen(parent(x))
	if length(cs) > 1		
		return [c*v^e for (e, c) in cs]
	end

	e, c = only(cs)
	isone(c) && return [v, e]
	return [c, v^e]
end

# multivariatepoly
isconst(p::MPolyRingElem) = length(p) == 0 || length(p) == 1 && isone(monomial(p, 1))
TermInterface.iscall(x::MPolyRingElem) = !(is_gen(x) || isconst(x))
function TermInterface.operation(x::MPolyRingElem)
    if length(x) == 1 #e.g. 2xy^2
        if length(vars(x)) == 1 && isone(coeff(x, 1)) #e.g. y^2 or sin(y)^2
            return (^)
        else
            return (*)
        end
    else # e.g. x+y
        return (+)
    end
end


powers(m::MPolyRingElem) = zip(vars(m), filter(x -> !iszero(x), exponent_vector(m, 1)))
function TermInterface.arguments(x::MPolyRingElem)
    if length(x) == 1
        c = coeff(x, 1)
        m = monomial(x, 1)

        if !isone(c)
            [c, m]
        else
            if length(vars(m)) == 1
                v, e = only(powers(m))
                return [v, e]
            else
                return [v^pow for (v, pow) in powers(m)]
            end
        end
    else
        ts = [term(x, i) for i in 1:length(x)]
        return [isconst(t) ? coeff(t, 1) : t for t in ts]
    end
end

const Polylike = Union{UniversalPolyRingElem, LaurentMPolyRingElem, AbstractAlgebra.MSeriesElem, SeriesElem}

iscoeffonly(p::Polylike) = length(p) == 0 || length(p) == 1 && isone(only(monomials(p)))
iscoeffonly(p) = false

nonzerocoeffs(x) = coefficients(x)
nonzerocoeffs(s::AbsPowerSeriesRingElem) = filter(x -> !iszero(x), coefficients(s))

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
powers(m::AbsPowerSeriesRingElem) = [(gen(parent(m)), (e-1)) for (e, c) in enumerate(coefficients(m)) if !iszero(c)]

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

AbstractAlgebra.monomials(x::AbsPowerSeriesRingElem) = [gen(parent(x)) ^ (e-1) for (e, c) in enumerate(coefficients(x)) if !iszero(c)]
AbstractAlgebra.monomials(x::AbstractAlgebra.MSeriesElem) = [prod(gens(parent(x)) .^ e) for e in exponent_vectors(x)]

AbstractAlgebra.terms(x::AbsPowerSeriesRingElem) = monomials(x) .* nonzerocoeffs(x)
AbstractAlgebra.terms(x::AbstractAlgebra.MSeriesElem) = monomials(x) .* nonzerocoeffs(x)

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
end