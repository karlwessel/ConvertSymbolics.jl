### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ 951cdd34-1825-11f0-2c7c-892d4c112cdf
using AbstractAlgebra

# ╔═╡ 551a1771-ecc3-4dc1-b40e-ac18588e7aa7
using TermInterface

# ╔═╡ dce2955f-bfe3-4715-bcfa-57ee322cc805
using PlutoTest

# ╔═╡ d9b3d542-f2da-47a7-b843-bfe6d6f50ddf
using SymbolicUtils

# ╔═╡ ff6998c0-1c60-4f67-baf4-94cee920fec7
R, x = polynomial_ring(QQ, :x)

# ╔═╡ b3c71b20-2fa3-4fb0-aca5-525b007b2d80
typeof(x) |> supertype

# ╔═╡ 2b25c48a-2754-460c-9350-92eb0a39029f


# ╔═╡ 1a025300-1f5d-4b5f-8db4-5ec830f59c0e
TermInterface.iscall(x::PolyRingElem) = !(is_gen(x) || degree(x) <= 0)

# ╔═╡ ee41e0a4-4539-47e3-916a-bca2369915d3
TermInterface.isexpr(x::RingElem) = iscall(x)

# ╔═╡ b0f2a948-acc4-4b99-93e0-3072d76ca10d
function nonzerocoeffswithexp(x)
	[(i-1, c) for (i, c) in enumerate(coefficients(x)) if !iszero(c)]
end

# ╔═╡ 734b8495-806c-41f8-98a4-37d9a0cdcb3f
nonzerocoeffswithexp(x+2x^3)

# ╔═╡ 170f7f58-6d4c-481d-9dca-ed59a864a8ee
function TermInterface.operation(x::PolyRingElem)
	c = nonzerocoeffswithexp(x)
	length(c) > 1 && return (+)

	e, c = only(c)
	isone(c) && e > 1 && return ^
	return *
end

# ╔═╡ 457d7b08-7365-4154-910a-eeb696d3e9c7
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

# ╔═╡ f134ab3f-edf1-444d-8e4f-c6e4f40dde5d
arguments(2x^2 + 1 -1)

# ╔═╡ c950ef6f-0208-4d50-8dd5-a89563eedd64
degree(x-x)

# ╔═╡ dc43f430-e848-44d8-8584-2dbffdced70e
@test !iscall(x)

# ╔═╡ dfb9552d-49ee-4c63-89e5-1488df7c792c
@test iscall(2x)

# ╔═╡ b659bebf-0161-4f90-983c-f896183d82f6
@test operation(2x) == *

# ╔═╡ 833c1ebb-f89d-43b8-9998-7d4c42b3e9f7
@test arguments(2x) == [2, x]

# ╔═╡ 5f05bbad-9198-46b1-9229-a144865896a3
@test iscall(x^2)

# ╔═╡ 4a9c2522-1d21-4899-986d-9a68738308e7
@test operation(x^2) == ^

# ╔═╡ 3ba7fd36-1c93-441e-8037-c014f8e1ba5e
@test arguments(x^2) == [x, 2]

# ╔═╡ 5e9d0ac5-2318-4cb6-9305-688a6d98645c
@test operation(2x^2) == *

# ╔═╡ 4446dbb9-6108-4d21-a591-55ba86ecd719
@test arguments(2x^2) == [2, x^2]

# ╔═╡ f94da46c-9820-4fee-a24b-c386ad767d93
@test iscall(x + 1)

# ╔═╡ 19620fea-ed96-4a2a-8d7e-7e1d4884114b
@test operation(x + 1) == +

# ╔═╡ 05aab89f-2b12-4d55-9744-8698692841a4
@test arguments(x + 1) == [1, x]

# ╔═╡ 8f2214b3-3da5-4f69-a032-9bf63a2d3870
@test !iscall(x+1-x)

# ╔═╡ 82dd64c5-11b4-4b63-a291-6159b77a2a6a


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractAlgebra = "c3fe647b-3220-5bb0-a1ea-a7954cac585d"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
TermInterface = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"

[compat]
AbstractAlgebra = "~0.44.11"
PlutoTest = "~0.2.2"
TermInterface = "~2.0.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.4"
manifest_format = "2.0"
project_hash = "b8f4f947286025d258e7ba1a6fe2f821cc97e3fe"

[[deps.AbstractAlgebra]]
deps = ["LinearAlgebra", "MacroTools", "Preferences", "Random", "RandomExtensions", "SparseArrays"]
git-tree-sha1 = "38c53247c158cebf59d407b5648f76e3077ef393"
uuid = "c3fe647b-3220-5bb0-a1ea-a7954cac585d"
version = "0.44.11"

    [deps.AbstractAlgebra.extensions]
    TestExt = "Test"

    [deps.AbstractAlgebra.weakdeps]
    Requires = "ae029012-a4dd-5104-9daa-d747884805df"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MacroTools]]
git-tree-sha1 = "72aebe0b5051e5143a079a4685a46da330a40472"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.15"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "17aa9b81106e661cffa1c4c36c17ee1c50a86eda"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.RandomExtensions]]
deps = ["Random", "SparseArrays"]
git-tree-sha1 = "b8a399e95663485820000f26b6a43c794e166a49"
uuid = "fb686558-2515-59ef-acaa-46db3789a887"
version = "0.4.4"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TermInterface]]
git-tree-sha1 = "d673e0aca9e46a2f63720201f55cc7b3e7169b16"
uuid = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"
version = "2.0.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"
"""

# ╔═╡ Cell order:
# ╠═951cdd34-1825-11f0-2c7c-892d4c112cdf
# ╠═d9b3d542-f2da-47a7-b843-bfe6d6f50ddf
# ╠═551a1771-ecc3-4dc1-b40e-ac18588e7aa7
# ╠═dce2955f-bfe3-4715-bcfa-57ee322cc805
# ╠═ff6998c0-1c60-4f67-baf4-94cee920fec7
# ╠═b3c71b20-2fa3-4fb0-aca5-525b007b2d80
# ╠═2b25c48a-2754-460c-9350-92eb0a39029f
# ╠═ee41e0a4-4539-47e3-916a-bca2369915d3
# ╠═1a025300-1f5d-4b5f-8db4-5ec830f59c0e
# ╠═b0f2a948-acc4-4b99-93e0-3072d76ca10d
# ╠═734b8495-806c-41f8-98a4-37d9a0cdcb3f
# ╠═170f7f58-6d4c-481d-9dca-ed59a864a8ee
# ╠═457d7b08-7365-4154-910a-eeb696d3e9c7
# ╠═f134ab3f-edf1-444d-8e4f-c6e4f40dde5d
# ╠═c950ef6f-0208-4d50-8dd5-a89563eedd64
# ╠═dc43f430-e848-44d8-8584-2dbffdced70e
# ╠═dfb9552d-49ee-4c63-89e5-1488df7c792c
# ╠═b659bebf-0161-4f90-983c-f896183d82f6
# ╠═833c1ebb-f89d-43b8-9998-7d4c42b3e9f7
# ╠═5f05bbad-9198-46b1-9229-a144865896a3
# ╠═4a9c2522-1d21-4899-986d-9a68738308e7
# ╠═3ba7fd36-1c93-441e-8037-c014f8e1ba5e
# ╠═5e9d0ac5-2318-4cb6-9305-688a6d98645c
# ╠═4446dbb9-6108-4d21-a591-55ba86ecd719
# ╠═f94da46c-9820-4fee-a24b-c386ad767d93
# ╠═19620fea-ed96-4a2a-8d7e-7e1d4884114b
# ╠═05aab89f-2b12-4d55-9744-8698692841a4
# ╠═8f2214b3-3da5-4f69-a032-9bf63a2d3870
# ╠═82dd64c5-11b4-4b63-a291-6159b77a2a6a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
