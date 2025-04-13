using DynamicPolynomials
using ConvertSymbolics
using Test
using TermInterface

@polyvar x y

@testset "Terminterface" begin
    # RationalPoly
    @test iscall(x/y)
    @test operation(x/y) == /
    @test arguments(x/y) == [x, y]

    @test !iscall(x)
    @test !iscall(x + 1 - 1)
    @test !iscall(0*x)
    @test !iscall(2x/2)
    @test !iscall(0*(x + 1))
    @test !iscall(0*(2x))
    @test !iscall(0*(x^2))
    @test !iscall(monomial(2x))
    @test !iscall(x-x)

    @test iscall(x + 1)
    @test arguments(x+1) == [1, x]
    @test operation(x + 1) == +

    @test iscall(x^2)
    @test operation(x^2) == ^
    @test arguments(x^2) == [x, 2]

    @test iscall(x*y)

    @test arguments(x*y^2) == [x, y^2]
    @test operation(x*y^2) == *

    @test iscall(2x)
    @test operation(2x) == *

    @test arguments(2x^2) == [2, x^2]

    @test arguments(1x*y)[2] isa AbstractMonomial

    @test iscall(x^2 + 1 -1)
    @test operation(x^2 + 1 -1) in [*, ^]
    @test arguments(x^2 + 1 -1) == [1, x^2]

    @test iscall(2x^2 + 1 -1)
    @test operation(2x^2 + 1 -1) == *
    @test arguments(2x^2 + 1 -1) == [2, x^2]
end