using QuantizedNoise
using Test
using Statistics

@testset "QuantizedNoise.jl" begin
    @testset "real" begin
        @test typeof(randn(Int8)) == Int8

        z = randn(Int8, 2)
        @test typeof(z) == Vector{Int8}
        @test size(z) == (2,)

        z = randn(Int16, 3, 3)
        @test typeof(z) == Array{Int16, 2}
        @test size(z) == (3,3)

        # 8-bit quantiation affects standard deviation least near 31
        z = randn(Int8, 10^6, σ=31)
        @test std(z) ≈ 31 atol=0.2

        z = randn(Int8, 10^6, std=31)
        @test std(z) ≈ 31 atol=0.2
    end

    @testset "complex" begin
        @test typeof(randn(Complex{Int8})) == Complex{Int8}

        z = randn(Complex{Int8}, 2)
        @test typeof(z) == Vector{Complex{Int8}}
        @test size(z) == (2,)

        z = randn(Complex{Int16}, 3, 3)
        @test typeof(z) == Array{Complex{Int16}, 2}
        @test size(z) == (3,3)

        # 8-bit quantiation affects standard deviation least near 31
        z = randn(Complex{Int8}, 10^6, σ=31)
        @test std(z) ≈ 31 atol=0.2

        z = randn(Complex{Int8}, 10^6, std=31)
        @test std(z) ≈ 31 atol=0.2
    end
end
