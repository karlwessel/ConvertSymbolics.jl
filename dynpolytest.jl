### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ a087e6c0-a538-4e6e-a35c-f5432c495dce
using Pkg

# ╔═╡ 3686adb7-3172-44ee-952b-50c97d53ea4a
begin
	Pkg.activate(temp=true)
	Pkg.develop(path=".")
	Pkg.add(["TermInterface", "DynamicPolynomials", "MultivariatePolynomials", "PlutoTest"])
end

# ╔═╡ e63b89b6-1311-11f0-0916-ed6bb418894e
using TermInterface

# ╔═╡ d28c26ce-767f-414e-b8bb-6119427d2bd5
using DynamicPolynomials

# ╔═╡ 6d13598e-ebb0-4923-aaf3-12be25fc1add
using MultivariatePolynomials

# ╔═╡ 99b99677-4aed-42fe-92de-41f793aba2ee
using PlutoTest

# ╔═╡ 8c38a697-d5f5-4e0e-96a0-bda00388ad93
using ConvertSymbolics

# ╔═╡ 059fd47b-3637-4875-b1bd-72fba127e3e6
const SU = SymbolicUtils.Symbolic{Number}

# ╔═╡ b2be6f20-cea7-4eb5-889e-cfaa25340934
const DP = DynamicPolynomials.PolyType

# ╔═╡ e0264e9d-db1c-49f2-8821-99b8b0c33ca9
typeof(Dict{Symbol, DP}())

# ╔═╡ 7ac9e2ea-410a-47e3-aa20-7be87c4e33fe


# ╔═╡ 4a8538a6-0e50-49e5-868b-3686146ebde3
ConvertSymbolics.convertsymbol(::Dict{Symbol, DP}, t::BaseNumbertypes) = t

# ╔═╡ be4d8436-2af9-438f-86f3-c5b27f7c330b
ConvertSymbolics.convertterm(::Type{DP}, x) = convertterm(Dict{Symbol, DP}(), x)

# ╔═╡ b7afb068-ca5c-4686-b267-cc8cd39ac502
convertterm(DP, :((x+1)*(y-2)*x))

# ╔═╡ 0784f6d4-4a48-42a4-b4cb-4bfd8adaec6a


# ╔═╡ f5f67377-f3ab-4833-aca0-1a7d9e7c959b
ex = (x + 1)*(y -2)*x

# ╔═╡ 5d59b4f7-83ec-4a35-a3fd-b8b7017fdfde
t = convertterm(Expr, ex)

# ╔═╡ 573672a6-b87f-4cc6-ac52-d484f420d7ed
convertterm(DP, t)

# ╔═╡ eabcb775-396d-41dd-b760-19d854d3db58
@which arguments(mono)

# ╔═╡ b3671fd4-ea94-4242-88d8-9e9259e9e3d5


# ╔═╡ ad56b9f5-8220-4573-bf22-d8eb3cbea159
x isa DynamicPolynomials.PolyType

# ╔═╡ 188f2613-8d00-4085-b6f4-53914d5e8a4c
function var(x)
	V = DynamicPolynomials.Commutative{DynamicPolynomials.CreationOrder}
	M = Graded{LexOrder}
	return Variable(string(x), V, M, DynamicPolynomials.REAL)
end

# ╔═╡ 2d22eae7-cdda-4825-ad26-16fe1069b4d9
ConvertSymbolics.convertsymbol(d::Dict{Symbol, DP}, x::Symbol) = get!(d, x, var(x))

# ╔═╡ b8c05cf5-9119-47c1-be70-03e056a225f5
typeof(x)

# ╔═╡ 6b261c60-9489-4555-bae6-f7d128881d70
typeof(x/y) 

# ╔═╡ 1f075497-5aeb-4532-8691-5638a85d7c78
@test iscall(x/y)

# ╔═╡ 008e202f-aca4-4221-bdf8-d57b17ed253a
@test operation(x/y) == /

# ╔═╡ 631449f9-c955-4d9c-b2e5-737d31dc1966
@test arguments(x/y) == [x, y]

# ╔═╡ cd1d97f7-f2d3-4b51-a6d6-feb19ef037a3
TermInterface.iscall(t::RationalPoly) = true

# ╔═╡ 9ad55ad8-0944-4364-9a04-0f7a934c558f
TermInterface.operation(t::RationalPoly) = /

# ╔═╡ d35671c9-6c5a-4f15-b9f0-a63d7705ebf4
TermInterface.arguments(t::RationalPoly) = [numerator(t), denominator(t)]

# ╔═╡ fbc51661-46f4-4e45-b655-46afc2fbe6d1
@polyvar x y

# ╔═╡ 439e635c-a8e4-4d08-acc5-08976ce9d348
TermInterface.operation(t::AbstractPolynomial) = nterms(t) > 1 ? (+) : (*)

# ╔═╡ 58dc90a6-0dc1-4c6a-9c19-fec35bf4cf15
TermInterface.operation(t::AbstractMonomial) = length(effective_variables(t)) > 1 ? (*) : (^)

# ╔═╡ 2e040f43-ab8e-4205-a7eb-0445ec5b6980
@test !iscall(x)

# ╔═╡ 7859b9d0-2673-4206-93d6-8debd270b289
@test iscall(x + 1)

# ╔═╡ 415efdd8-e87f-4000-9216-5430091da756
function TermInterface.arguments(t::AbstractPolynomial)
	ts = terms(t)
	length(ts) == 1 ? arguments(only(ts)) : ts
end

# ╔═╡ f82e36e6-b09f-42dd-b4ca-81a14e08f4a4
@test arguments(x+1) == [1, x]

# ╔═╡ a5065e28-7ac4-4181-ab7e-4414bee6cfee
@test operation(x + 1) == +

# ╔═╡ be4f8b5f-0533-44e3-9b69-f647020a7970
@test !iscall(x + 1 - 1)

# ╔═╡ 6541f509-04da-407a-bb6c-7cf84800fd97
@test iscall(x^2)

# ╔═╡ 73505d78-1bcf-45de-90f7-08e64cd87533
function TermInterface.arguments(t::AbstractMonomial)
	ps = collect(Iterators.filter(x -> x[2] > 0, zip(variables(t), exponents(t))))
	length(ps) == 1 ? collect(only(ps)) : [v^e for (v,e) in ps]
end

# ╔═╡ cef9c046-3c32-4640-a82d-508bc9c24606
@test arguments(x^2) == [x, 2]

# ╔═╡ f22fb090-79bf-48c7-b324-8ccc92120654
@test operation(x^2) == ^

# ╔═╡ b1465845-9c3d-4c84-b056-8505081d569f
@test iscall(x*y)

# ╔═╡ b170a4fa-8a7d-438b-8fb5-5a8d1f2bc81e
@test arguments(x*y^2) == [x, y^2]

# ╔═╡ df13387e-113f-466e-85e6-726f955611ee
@test operation(x*y^2) == *

# ╔═╡ 1bde06e4-e277-4158-87dc-3f45471b246f
@test iscall(2x)

# ╔═╡ 769b2973-d4d3-4906-9a0b-a39d00d0bf3f
@test arguments(2x^2) == [2, x^2]

# ╔═╡ d56c701f-e2fb-48b7-a92b-5385fa6cd159
TermInterface.arguments(t::AbstractTerm) = Any[coefficient(t), monomial(t)]

# ╔═╡ e2e4be3e-665d-49a8-8359-647df9b7a158
term = arguments(ex)[4]

# ╔═╡ b3192e8c-845c-40ba-b844-bb2e7c2585d3
mono = arguments(term)[2]

# ╔═╡ 22977d00-a346-4708-be5c-ef29787821f1
typeof(monomial(mono))

# ╔═╡ 8a5e32ad-1fa4-4211-a8e5-2a689f0c4276
arguments(mono)

# ╔═╡ 1d0a82bc-f10f-4df7-8b4c-d43e710ed7c9
@test arguments(1x*y)[2] isa AbstractMonomial

# ╔═╡ 2439d608-fc20-437e-af58-a6ea04c74815
TermInterface.operation(t::AbstractTerm) = *

# ╔═╡ e6ccdfe0-b341-4cba-8226-b9dc509115e2
@test operation(2x) == *

# ╔═╡ 766de721-90df-479c-993b-ecc7c0b11e35
@test !iscall(0*x)

# ╔═╡ e944cfc4-1d5e-459d-b4a0-e0071da3c200
@test !iscall(2x/2)

# ╔═╡ 1ea56859-f98f-4ff3-b97f-6c7c97f8a58e
@test iscall(x^2 + 1 -1)

# ╔═╡ 858afcbc-39ad-490f-9a44-ccac98cde136
@test arguments(x^2 + 1 -1) == [1, x^2]

# ╔═╡ 8a5e9e72-b412-4947-aa7f-c75adbdfbca8
@test operation(x^2 + 1 -1) in [*, ^]

# ╔═╡ 48e9b2c2-60aa-4b76-ada3-30fcc0ea0c36
@test iscall(2x^2 + 1 -1)

# ╔═╡ 760814bf-55c9-4bb9-99d6-96c28bb18f6f
@test arguments(2x^2 + 1 -1) == [2, x^2]

# ╔═╡ 7461d3fa-89db-4b0a-aacc-f29253539147
@test operation(2x^2 + 1 -1) == *

# ╔═╡ aabd9264-061c-4cc3-93fa-6aaa38732462
@test !iscall(0*(x + 1))

# ╔═╡ 4e6cceff-32f2-4ac9-98fb-f5b2da70e146
@test !iscall(0*(2x))

# ╔═╡ 88d1ed54-3454-4df9-85d7-5b31d7c8d18d
@test !iscall(0*(x^2))

# ╔═╡ 57ffccbf-4d33-4c04-915e-c89e3581946b
@test !iscall(monomial(2x))

# ╔═╡ 42f40bc5-e05c-4e27-97ad-4d7dc42c54bc
@test !iscall(x-x)

# ╔═╡ a14346ff-42bf-42c0-b748-fe43673fb5c3
TermInterface.iscall(t::AbstractVariable) = false

# ╔═╡ ce70c5b0-d57f-4493-b05d-6749d0e5af29
TermInterface.iscall(t::AbstractMonomial) = maxdegree(t) > 1

# ╔═╡ 3c0b0dea-b044-4dd6-af68-09bc686f39a3
TermInterface.iscall(t::AbstractTerm) = !iszero(t) && (maxdegree(t) > 1 || maxdegree(t) == 1 && !isone(coefficient(t)))

# ╔═╡ ad2ad2b3-2438-40e5-8915-38e328772b28
TermInterface.iscall(t::AbstractPolynomialLike) = !iszero(t) && (nterms(t) > 1 || iscall(only(terms(t))))

# ╔═╡ 748c19ad-d1aa-4361-8696-9927a15d16a4
TermInterface.isexpr(t::AbstractPolynomialLike) = iscall(t)

# ╔═╡ Cell order:
# ╠═a087e6c0-a538-4e6e-a35c-f5432c495dce
# ╠═3686adb7-3172-44ee-952b-50c97d53ea4a
# ╠═e63b89b6-1311-11f0-0916-ed6bb418894e
# ╠═d28c26ce-767f-414e-b8bb-6119427d2bd5
# ╠═6d13598e-ebb0-4923-aaf3-12be25fc1add
# ╠═99b99677-4aed-42fe-92de-41f793aba2ee
# ╠═8c38a697-d5f5-4e0e-96a0-bda00388ad93
# ╠═059fd47b-3637-4875-b1bd-72fba127e3e6
# ╠═b2be6f20-cea7-4eb5-889e-cfaa25340934
# ╠═5d59b4f7-83ec-4a35-a3fd-b8b7017fdfde
# ╠═e0264e9d-db1c-49f2-8821-99b8b0c33ca9
# ╠═7ac9e2ea-410a-47e3-aa20-7be87c4e33fe
# ╠═2d22eae7-cdda-4825-ad26-16fe1069b4d9
# ╠═4a8538a6-0e50-49e5-868b-3686146ebde3
# ╠═be4d8436-2af9-438f-86f3-c5b27f7c330b
# ╠═573672a6-b87f-4cc6-ac52-d484f420d7ed
# ╠═b7afb068-ca5c-4686-b267-cc8cd39ac502
# ╠═0784f6d4-4a48-42a4-b4cb-4bfd8adaec6a
# ╠═f5f67377-f3ab-4833-aca0-1a7d9e7c959b
# ╠═e2e4be3e-665d-49a8-8359-647df9b7a158
# ╠═b3192e8c-845c-40ba-b844-bb2e7c2585d3
# ╠═eabcb775-396d-41dd-b760-19d854d3db58
# ╠═22977d00-a346-4708-be5c-ef29787821f1
# ╠═8a5e32ad-1fa4-4211-a8e5-2a689f0c4276
# ╠═b3671fd4-ea94-4242-88d8-9e9259e9e3d5
# ╠═ad56b9f5-8220-4573-bf22-d8eb3cbea159
# ╠═188f2613-8d00-4085-b6f4-53914d5e8a4c
# ╠═b8c05cf5-9119-47c1-be70-03e056a225f5
# ╠═6b261c60-9489-4555-bae6-f7d128881d70
# ╠═1f075497-5aeb-4532-8691-5638a85d7c78
# ╠═008e202f-aca4-4221-bdf8-d57b17ed253a
# ╠═631449f9-c955-4d9c-b2e5-737d31dc1966
# ╠═cd1d97f7-f2d3-4b51-a6d6-feb19ef037a3
# ╠═9ad55ad8-0944-4364-9a04-0f7a934c558f
# ╠═d35671c9-6c5a-4f15-b9f0-a63d7705ebf4
# ╠═fbc51661-46f4-4e45-b655-46afc2fbe6d1
# ╠═439e635c-a8e4-4d08-acc5-08976ce9d348
# ╠═58dc90a6-0dc1-4c6a-9c19-fec35bf4cf15
# ╠═2e040f43-ab8e-4205-a7eb-0445ec5b6980
# ╠═7859b9d0-2673-4206-93d6-8debd270b289
# ╠═415efdd8-e87f-4000-9216-5430091da756
# ╠═f82e36e6-b09f-42dd-b4ca-81a14e08f4a4
# ╠═a5065e28-7ac4-4181-ab7e-4414bee6cfee
# ╠═be4f8b5f-0533-44e3-9b69-f647020a7970
# ╠═6541f509-04da-407a-bb6c-7cf84800fd97
# ╠═73505d78-1bcf-45de-90f7-08e64cd87533
# ╠═cef9c046-3c32-4640-a82d-508bc9c24606
# ╠═f22fb090-79bf-48c7-b324-8ccc92120654
# ╠═b1465845-9c3d-4c84-b056-8505081d569f
# ╠═b170a4fa-8a7d-438b-8fb5-5a8d1f2bc81e
# ╠═df13387e-113f-466e-85e6-726f955611ee
# ╠═1bde06e4-e277-4158-87dc-3f45471b246f
# ╠═769b2973-d4d3-4906-9a0b-a39d00d0bf3f
# ╠═d56c701f-e2fb-48b7-a92b-5385fa6cd159
# ╠═1d0a82bc-f10f-4df7-8b4c-d43e710ed7c9
# ╠═2439d608-fc20-437e-af58-a6ea04c74815
# ╠═e6ccdfe0-b341-4cba-8226-b9dc509115e2
# ╠═766de721-90df-479c-993b-ecc7c0b11e35
# ╠═e944cfc4-1d5e-459d-b4a0-e0071da3c200
# ╠═1ea56859-f98f-4ff3-b97f-6c7c97f8a58e
# ╠═858afcbc-39ad-490f-9a44-ccac98cde136
# ╠═8a5e9e72-b412-4947-aa7f-c75adbdfbca8
# ╠═48e9b2c2-60aa-4b76-ada3-30fcc0ea0c36
# ╠═760814bf-55c9-4bb9-99d6-96c28bb18f6f
# ╠═7461d3fa-89db-4b0a-aacc-f29253539147
# ╠═aabd9264-061c-4cc3-93fa-6aaa38732462
# ╠═4e6cceff-32f2-4ac9-98fb-f5b2da70e146
# ╠═88d1ed54-3454-4df9-85d7-5b31d7c8d18d
# ╠═57ffccbf-4d33-4c04-915e-c89e3581946b
# ╠═42f40bc5-e05c-4e27-97ad-4d7dc42c54bc
# ╠═748c19ad-d1aa-4361-8696-9927a15d16a4
# ╠═a14346ff-42bf-42c0-b748-fe43673fb5c3
# ╠═ce70c5b0-d57f-4493-b05d-6749d0e5af29
# ╠═3c0b0dea-b044-4dd6-af68-09bc686f39a3
# ╠═ad2ad2b3-2438-40e5-8915-38e328772b28
