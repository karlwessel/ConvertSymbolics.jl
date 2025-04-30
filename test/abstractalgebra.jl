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

function wrapbasering(constructor, depth)
    (B, v) -> begin
        R, _ = constructor(B, :dummy)
        for _ in 1:depth
            R = base_ring(R)
        end
        return R, first(gens(R))
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
        ("basering of multivariate laurent ring", wrapbasering(wrap2dto1d(laurent_polynomial_ring), 1), [R1]),
        ("absolute power series", 
            (R, v) -> power_series_ring(R, 4, v, model=:capped_absolute), 
            [QQ, ringtower]),
        ("basering 1 of absolute power series", 
            wrapbasering((R, v) -> power_series_ring(R, 4, v, model=:capped_absolute), 1), 
            [ringtower]),
        ("basering 2 of absolute power series", 
            wrapbasering((R, v) -> power_series_ring(R, 4, v, model=:capped_absolute), 2), 
            [ringtower]),
        ("multivariate power series", wrap2dto1d((R, vs) -> power_series_ring(R, 4, vs)), [QQ]),
    ]
    @testset "1D tests" begin
        for (name, constructor, baserings) in rings
            @testset "$name" begin
                for basering in baserings
                    @testset "Basering: $basering" begin
                        R, x = constructor(basering, :x)

                        c = 2*one(R)

                        @test !iscall(x)

                        @test iscall(c*x)
                        @test operation(c*x) == *
                        @test arguments(c*x) == [c, x]
                    
                        @test iscall(x^2)
                        @test operation(x^2) == ^
                        @test arguments(x^2) == [x, 2]
                    
                        @test operation(c*x^2) == *
                        @test arguments(c*x^2) == [c, x^2]
                    
                        @test iscall(x + c)
                        @test operation(x + c) == +
                        @test (arguments(x+c) == [c, x]) || (arguments(x+c) == [x, c])
                    
                        @test !iscall(x+c-x)
                    
                        @test !iscall(x)
                        @test !iscall(x + c - c)
                        @test !iscall(0*x)
                        @test !iscall(c*x/c)
                        @test !iscall(0*(x + c))
                        @test !iscall(0*(c*x))
                        @test !iscall(0*(x^2))
                        @test !iscall(x-x)
                    
                        @test iscall(x^2)
                        @test operation(x^2) == ^
                        @test arguments(x^2) == [x, 2]
                    
                        @test arguments(c*x^2) == [c, x^2]
                    
                        @test iscall(x^2 + c -c)
                        @test operation(x^2 + c -c) == ^
                        @test arguments(x^2 + c -c) == [x, 2]
                    
                        @test iscall(c*x^2 + c -c)
                        @test operation(c*x^2 + c -c) == *
                        @test arguments(c*x^2 + c -c) == [c, x^2]
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

    towerrings = [
        ("multivariate laurent ring", wrap2dto1d(laurent_polynomial_ring), [R1]),
        ("basering of multivariate laurent ring", wrapbasering(wrap2dto1d(laurent_polynomial_ring), 1), [R1]),
        #=("absolute power series", 
            (R, v) -> power_series_ring(R, 4, v, model=:capped_absolute), 
            [ringtower]), BROKEN =# 
        ("basering 1 of absolute power series", 
            wrapbasering((R, v) -> power_series_ring(R, 4, v, model=:capped_absolute), 1), 
            [ringtower]),
        ("basering 2 of absolute power series", 
            wrapbasering((R, v) -> power_series_ring(R, 4, v, model=:capped_absolute), 2), 
            [ringtower]),
    ]
    @testset "tower tests" begin
        for (name, constructor, baserings) in towerrings
            @testset "$name" begin
                for basering in baserings
                    @testset "Basering: $basering" begin
                        R, x = constructor(basering, :x)

                        c = 2*one(basering)

                        @test !iscall(x)

                        @test iscall(c*x)
                        @test operation(c*x) == *
                        @test arguments(c*x) == [c, x]

                        @test iscall(c + x)
                        @test operation(c + x) == +
                        @test arguments(c + x) == [x, c]

                        @test iscall(c*x^2 + c -c)
                        @test operation(c*x^2 + c -c) == *
                        @test arguments(c*x^2 + c -c) == [c, x^2]
                    end
                end
            end
        end
    end
end