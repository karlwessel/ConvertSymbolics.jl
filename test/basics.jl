using ConvertSymbolics
using SymbolicUtils: Symbolic
using Test
using Symbolics: Num

const SU = Symbolic{Number}
@testset "ConvertSymbolics.jl" begin
    T2 = Expr
    x2 = convertterm(T2, :x)
    T1 = Num
    x1 = convertterm(T1, :x)

    f1 = convertterm(T1, :(f(y)))

    @test f1 isa Num

    @test isequal(:(sin(x)), convertterm(T2, sin(x1)))
    @test isequal(sin(x1), convertterm(T1, :(sin(x))))
end

@testset "Generics" begin
    @test isequal(2, convertterm(Expr, 2))
    @test isequal(2.1, convertterm(Expr, 2.1))
    @test isequal(2//3, convertterm(Expr, 2//3))
    @test isequal(pi, convertterm(Expr, pi))

    x1 = convertterm(Expr, :x)
    @test x1 isa Symbol

    x2 = convertterm(Expr, x1)
    @test isequal(x1, convertterm(Expr, x2))

    y1 = convertterm(Expr, :y)
    @test !isequal(x1, y1)

    symboliclibs = [("SymbolicUtils", SU, SU), ("Symbolics", Num, Num)]
    for (D1, S1, T1) in symboliclibs
        @testset "S1: $D1" begin
            @test isequal(2, convertterm(T1, 2))
            @test isequal(2.1, convertterm(T1, 2.1))
            @test isequal(2//3, convertterm(T1, 2//3))
            @test isequal(pi, convertterm(T1, pi))

            x1 = convertterm(T1, :x)
            @test x1 isa S1

            y1 = convertterm(T1, :y)
            f1 = convertterm(T1, :(f(x,y)))
            @test f1 isa S1
            @test !isequal(x1, y1)


            @testset "S1: $D1 S2: Expr" begin
                x2 = convertterm(Expr, x1)

                @test isequal(:x, x2)
                @test isequal(x1, convertterm(T1, x2))

                f2 = convertterm(Expr, f1)
                @test isequal(:(f(x,y)), f2)
                @test isequal(f1, convertterm(T1, f2))

                @test isequal(x1 + 1, convertterm(T1, :(x + 1)))
                @test isequal(:(1 + x), convertterm(Expr, x1 + 1))

                @test isequal(f1 + 1, convertterm(T1, :(f(x, y) + 1)))
                @test isequal(:(1 + f(x, y)), convertterm(Expr, f1 + 1))

                @test isequal(:y, convertterm(Expr, y1))

                @test isequal(x1 + y1, convertterm(T1, :(x + y)))
                @test isequal(:(y + x), convertterm(Expr, x1 + y1))
            end
            for (D2, S2, T2) in symboliclibs
                @testset "S1: $D1 S2: $D2" begin
                    x2 = convertterm(T2, x1)
                    @test x2 isa S2
                    @test isequal(x1, convertterm(T1, x2))

                    f2 = convertterm(T2, f1)
                    @test f2 isa S2
                    @test isequal(f1, convertterm(T1, f2))

                    ops = [+, -, *, /, ^, atan]
                    terms = Any[1, 1.2, 1//2, y1, f1, pi]
                    for op in ops
                        for t1 in terms
                            t2 = convertterm(T2, t1)
                            @test isequal(op(x2, t2), convertterm(T2, op(x1, t1)))
                        end
                    end

                    ops = [-, sqrt, sin]
                    terms = [y1, f1]
                    for op in ops
                        for t1 in terms
                            t2 = convertterm(T2, t1)
                            @test isequal(op(t2), convertterm(T2, op(t1)))
                        end
                    end

                    @test isequal(x2 + 1, convertterm(T2, x1 + 1))
                    @test isequal(f2 + 1, convertterm(T2, f1 + 1))

                    y2 = convertterm(T2, :y)
                    @test !isequal(x2, y2)
                    @test isequal(y2, convertterm(T2, y1))

                    @test isequal(x2 + y2, convertterm(T2, x1 + y1))

                    @test isequal(x2 + f2, convertterm(T2, x1 + f1))
                end
            end
        end
    end
end

#=
@testset "Complex symbolics" begin
    symboliclibs = [("SymbolicUtils", SU, SU), ("Symbolics", Num, Num)]
    for (D1, S1, T1) in symboliclibs
        @testset "S1: $D1" begin
            @test isequal(im, convertterm(T1, im))
            @test isequal(2+im, convertterm(T1, 2+im))
            @test isequal(2.1im, convertterm(T1, 2.1im))

            x1 = convertterm(T1, "x")

            y1 = convertterm(T1, "y")
            f1 = convertterm(T1, :(f(x,y)))
            @testset "S1: $D1 S2: Expr" begin
                @test isequal(x1 + im*y1, convertterm(T1, :(x + im*y)))
            end
            for (D2, S2, T2) in symboliclibs
                @testset "S1: $D1 S2: $D2" begin
                    x2 = convertterm(T2, x1)
                    f2 = convertterm(T2, f1)
                    ops = [+, -, *, /, ^, atan]
                    terms = Any[im, 2im, 2.1im]
                    for op in ops
                        for t1 in terms
                            t2 = convertterm(T2, t1)
                            @test isequal(op(x2, t2), convertterm(T2, op(x1, t1)))
                        end
                    end

                    ops = [-, sqrt, sin]
                    terms = [im*y1, im*f1]
                    for op in ops
                        for t1 in terms
                            t2 = convertterm(T2, t1)
                            @test isequal(op(t2), convertterm(T2, op(t1)))
                        end
                    end
                    @test isequal(x2 + im*y2, convertterm(T2, x1 + im*y1))
                end
            end
        end
    end
end
=#
