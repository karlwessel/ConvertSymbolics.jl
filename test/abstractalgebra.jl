using AbstractAlgebra
using ConvertSymbolics
using Test
using TermInterface

R, x = polynomial_ring(QQ, :x)

@testset "Terminterface" begin
    # RationalPoly

    @test !iscall(x)

    @test iscall(2x)
    @test operation(2x) == *
    @test arguments(2x) == [2, x]

    @test iscall(x^2)
    @test operation(x^2) == ^
    @test arguments(x^2) == [x, 2]

    @test operation(2x^2) == *
    @test arguments(2x^2) == [2, x^2]

    @test iscall(x + 1)
    @test operation(x + 1) == +
    @test arguments(x + 1) == [1, x]

    @test !iscall(x+1-x)

    @test !iscall(x)
    @test !iscall(x + 1 - 1)
    @test !iscall(0*x)
    @test !iscall(2x/2)
    @test !iscall(0*(x + 1))
    @test !iscall(0*(2x))
    @test !iscall(0*(x^2))
    @test !iscall(x-x)

    @test iscall(x + 1)
    @test arguments(x+1) == [1, x]
    @test operation(x + 1) == +

    @test iscall(x^2)
    @test operation(x^2) == ^
    @test arguments(x^2) == [x, 2]

    @test iscall(2x)
    @test operation(2x) == *

    @test arguments(2x^2) == [2, x^2]

    @test iscall(x^2 + 1 -1)
    @test operation(x^2 + 1 -1) == ^
    @test arguments(x^2 + 1 -1) == [x, 2]

    @test iscall(2x^2 + 1 -1)
    @test operation(2x^2 + 1 -1) == *
    @test arguments(2x^2 + 1 -1) == [2, x^2]
end