module DynamicPolynomialsExt
using DynamicPolynomials
using TermInterface

# TermInterface implementation
TermInterface.iscall(t::RationalPoly) = true
TermInterface.operation(t::RationalPoly) = /
TermInterface.arguments(t::RationalPoly) = [numerator(t), denominator(t)]

TermInterface.isexpr(t::AbstractPolynomialLike) = iscall(t)
TermInterface.iscall(t::AbstractPolynomialLike) = !iszero(t) && (nterms(t) > 1 || iscall(only(terms(t))))
TermInterface.operation(t::AbstractPolynomial) = nterms(t) > 1 ? (+) : (*)
function TermInterface.arguments(t::AbstractPolynomial)
	ts = terms(t)
	length(ts) == 1 ? arguments(only(ts)) : ts
end

TermInterface.iscall(t::AbstractTerm) = !iszero(t) && (maxdegree(t) > 1 || maxdegree(t) == 1 && !isone(coefficient(t)))
TermInterface.operation(t::AbstractTerm) = *
TermInterface.arguments(t::AbstractTerm) = Any[coefficient(t), monomial(t)]

TermInterface.iscall(t::AbstractMonomial) = maxdegree(t) > 1
TermInterface.operation(t::AbstractMonomial) = length(effective_variables(t)) > 1 ? (*) : (^)
function TermInterface.arguments(t::AbstractMonomial)
	ps = collect(Iterators.filter(x -> x[2] > 0, zip(variables(t), exponents(t))))
	length(ps) == 1 ? collect(only(ps)) : [v^e for (v,e) in ps]
end

TermInterface.iscall(t::AbstractVariable) = false
end