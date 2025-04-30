using AbstractAlgebra
using ConvertSymbolics
using Test
using TermInterface
using Nemo: CalciumField

function wrap2dto1d(constructor)
    (B, v) -> begin
        R, (x, y) = constructor(B, [v, :y])
        return R, x
    end
end

@testset "generic tests" begin
    R1 = universal_polynomial_ring(CalciumField())
    gen.(Ref(R1), [:a, :b])
    R2, _ = laurent_polynomial_ring(R1, [:A, :B])
    ringtower = R2
    rings = [
        ("poly ring", polynomial_ring, [QQ]),
        ("laurent ring", laurent_polynomial_ring, [QQ]),
        ("multivariate poly ring", wrap2dto1d(polynomial_ring), [QQ]),
        ("universal poly ring", (R, v) -> begin
            P = universal_polynomial_ring(R)
            return P, gen(P, v)
        end, [QQ, CalciumField()]),
        ("multivariate laurent ring", wrap2dto1d(laurent_polynomial_ring), [QQ, R1]),
        ("absolute power series", 
            (R, v) -> power_series_ring(R, 4, v, model=:capped_absolute), 
            [QQ, ringtower]),
        ("multivariate power series", wrap2dto1d((R, vs) -> power_series_ring(R, 4, vs)), [QQ]),
    ]
    @testset "1D tests" begin
        for (name, constructor, baserings) in rings
            @testset "$name" begin
                for basering in baserings
                    @testset "Basering: $basering" begin
                        R, x = constructor(basering, :x)

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
        end
    end

    laurentrings = [
        ("laurent ring", laurent_polynomial_ring, [QQ]),
        ("multivariate laurent ring", wrap2dto1d(laurent_polynomial_ring), [QQ]),
    ]
    @testset "laurent tests" begin
        for (name, constructor, baserings) in laurentrings
            @testset "$name" begin
                for basering in baserings
                    @testset "Basering: $basering" begin
                        R, x = constructor(basering, :x)

                        @test iscall(x^-2)
                        @test operation(x^-2) == ^
                        @test arguments(x^-2) == [x, -2]
                    end
                end
            end
        end
    end

    multivariaterings = [
        ("poly ring", polynomial_ring, [QQ]),
        ("universal poly ring", (R, vs) -> begin
            P = universal_polynomial_ring(R)
            return P, gen.(Ref(P), vs)
        end, [QQ, CalciumField()]),
        ("laurent ring", laurent_polynomial_ring, [QQ]),
        ("power series", (R, vs) -> power_series_ring(R, 4, vs), [QQ]),
    ]
    @testset "multivariate tests" begin
        for (name, constructor, baserings) in multivariaterings
            @testset "$name" begin
                for basering in baserings
                    @testset "Basering: $basering" begin
                        R, (x, y) = constructor(basering, [:x, :y])

                        @test iscall(y*x)
                        @test operation(y*x) == *
                        @test arguments(y*x) == [x, y]
                    end
                end
            end
        end
    end
end