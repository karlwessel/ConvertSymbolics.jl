using AbstractAlgebra
using ConvertSymbolics
using Test
using TermInterface

function wrap2dto1d(constructor)
    (B, v) -> begin
        R, (x, y) = constructor(B, [v, :y])
        return R, x
    end
end

@testset "generic tests" begin
    rings = [
        ("poly ring", polynomial_ring),
        ("laurent ring", laurent_polynomial_ring),
        ("multivariate poly ring", wrap2dto1d(polynomial_ring)),
        ("universal poly ring", (R, v) -> begin
            P = universal_polynomial_ring(R)
            return P, gen(P, v)
        end),
        ("multivariate laurent ring", wrap2dto1d(laurent_polynomial_ring)),
        ("absolute power series", (R, v) -> power_series_ring(R, 4, v, model=:capped_absolute)),
        ("multivariate power series", wrap2dto1d((R, vs) -> power_series_ring(R, 4, vs))),
    ]
    @testset "1D tests" begin
        for (name, constructor) in rings
            @testset "$name" begin
                R, x = constructor(QQ, :x)

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
                @test (arguments(x+1) == [1, x]) || (arguments(x+1) == [x, 1])
            
                @test !iscall(x+1-x)
            
                @test !iscall(x)
                @test !iscall(x + 1 - 1)
                @test !iscall(0*x)
                @test !iscall(2x/2)
                @test !iscall(0*(x + 1))
                @test !iscall(0*(2x))
                @test !iscall(0*(x^2))
                @test !iscall(x-x)
            
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
        end
    end

    laurentrings = [
        ("laurent ring", laurent_polynomial_ring),
        ("multivariate laurent ring", wrap2dto1d(laurent_polynomial_ring)),
    ]
    @testset "laurent tests" begin
        for (name, constructor) in laurentrings
            @testset "$name" begin
                R, x = constructor(QQ, :x)

                @test iscall(x^-2)
                @test operation(x^-2) == ^
                @test arguments(x^-2) == [x, -2]
            end
        end
    end

    multivariaterings = [
        ("poly ring", polynomial_ring),
        ("universal poly ring", (R, vs) -> begin
            P = universal_polynomial_ring(R)
            return P, gen.(Ref(P), vs)
        end),
        ("laurent ring", laurent_polynomial_ring),
        ("power series", (R, vs) -> power_series_ring(R, 4, vs)),
    ]
    @testset "multivariate tests" begin
        for (name, constructor) in multivariaterings
            @testset "$name" begin
                R, (x, y) = constructor(QQ, [:x, :y])

                @test iscall(y*x)
                @test operation(y*x) == *
                @test arguments(y*x) == [x, y]
            end
        end
    end
end