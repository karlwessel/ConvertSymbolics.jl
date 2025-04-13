module AbstractAlgebraExt
using AbstractAlgebra
using TermInterface

TermInterface.iscall(x::PolyRingElem) = !(is_gen(x) || degree(x) <= 0)
TermInterface.isexpr(x::RingElem) = iscall(x)

function nonzerocoeffswithexp(x)
	[(i-1, c) for (i, c) in enumerate(coefficients(x)) if !iszero(c)]
end

function TermInterface.operation(x::PolyRingElem)
	c = nonzerocoeffswithexp(x)
	length(c) > 1 && return (+)

	e, c = only(c)
	isone(c) && e > 1 && return ^
	return *
end

function TermInterface.arguments(x::PolyRingElem)
	cs = nonzerocoeffswithexp(x)
	v = gen(parent(x))
	if length(cs) > 1		
		return [c*v^e for (e, c) in cs]
	end

	e, c = only(cs)
	isone(c) && e > 1 && return [v, e]
	return [c, v^e]
end
end