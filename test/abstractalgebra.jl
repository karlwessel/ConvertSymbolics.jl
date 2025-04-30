using AbstractAlgebra
using ConvertSymbolics
using Test
using TermInterface

@testset "poly ring" begin
    R, x = polynomial_ring(QQ, :x)
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

@testset "laurent ring" begin
    R, x = laurent_polynomial_ring(QQ, :x)
    @test !iscall(x)

    @test iscall(2x)
    @test operation(2x) == *
    @test arguments(2x) == [2, x]

    @test iscall(x^2)
    @test operation(x^2) == ^
    @test arguments(x^2) == [x, 2]

    @test iscall(x^-2)
    @test operation(x^-2) == ^
    @test arguments(x^-2) == [x, -2]

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

@testset "multi variate poly ring" begin
    R, (x, y) = polynomial_ring(QQ, [:x, :y])
    @test !iscall(x)

    @test iscall(2x)
    @test operation(2x) == *
    @test arguments(2x) == [2, x]

    @test iscall(y*x)
    @test operation(y*x) == *
    @test arguments(y*x) == [x, y]

    @test iscall(x^2)
    @test operation(x^2) == ^
    @test arguments(x^2) == [x, 2]

    @test operation(2x^2) == *
    @test arguments(2x^2) == [2, x^2]

    @test iscall(x + 1)
    @test operation(x + 1) == +
    @test arguments(x + 1) == [x, 1]

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
    @test arguments(x+1) == [x, 1]
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

@testset "universal poly ring" begin
    R = universal_polynomial_ring(QQ)
    x, y = gen.(Ref(R), [:x, :y])
    @test !iscall(x)

    @test iscall(2x)
    @test operation(2x) == *
    @test arguments(2x) == [2, x]

    @test iscall(y*x)
    @test operation(y*x) == *
    @test arguments(y*x) == [x, y]

    @test iscall(x^2)
    @test operation(x^2) == ^
    @test arguments(x^2) == [x, 2]

    @test operation(2x^2) == *
    @test arguments(2x^2) == [2, x^2]

    @test iscall(x + 1)
    @test operation(x + 1) == +
    @test arguments(x + 1) == [x, 1]

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
    @test arguments(x+1) == [x, 1]
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

@testset "multivariate laurent ring" begin
    R, (x, y) = laurent_polynomial_ring(QQ, [:x, :y])
    @test !iscall(x)

    @test iscall(2x)
    @test operation(2x) == *
    @test arguments(2x) == [2, x]

    @test iscall(y*x)
    @test operation(y*x) == *
    @test arguments(y*x) == [x, y]

    @test iscall(x^2)
    @test operation(x^2) == ^
    @test arguments(x^2) == [x, 2]

    @test iscall(x^-2)
    @test operation(x^-2) == ^
    @test arguments(x^-2) == [x, -2]

    @test operation(2x^2) == *
    @test arguments(2x^2) == [2, x^2]

    @test iscall(x + 1)
    @test operation(x + 1) == +
    @test arguments(x + 1) == [x, 1]

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
    @test arguments(x+1) == [x, 1]
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

@testset "absolute power series" begin
    R, x = power_series_ring(QQ, 4, :x, model=:capped_absolute)
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

@testset "multi variate power series" begin
    R, (x, y) = power_series_ring(QQ, 4, [:x, :y])
    @test !iscall(x)

    @test iscall(2x)
    @test operation(2x) == *
    @test arguments(2x) == [2, x]

    @test iscall(y*x)
    @test operation(y*x) == *
    @test arguments(y*x) == [x, y]

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