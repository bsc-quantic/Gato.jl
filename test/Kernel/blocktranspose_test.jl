using Test
using Gato.Kernel: blocktranspose!
using LinearAlgebra: I

@testset "blocktranpose - diagonals" begin
    for exp in 1:5
        m = Matrix(I(2^exp))
        @test blocktranspose!(m) == m
    end
end

for type in [ComplexF16, ComplexF32, ComplexF64]
    @testset "blocktranpose{$type} - random square matrices" begin
        for exp in 1:5
            @test begin
                m = rand(type, 2^exp, 2^exp)
                mt = similar(m)
                copy!(mt, m)
                blocktranspose!(mt)
                mt == transpose(m)
            end
        end
    end

    @testset "blocktranpose{$type} - random rectangular matrices" begin
        for exp in 1:5
            @test_throws DimensionMismatch begin
                m = rand(type, 2^exp, 2^(exp + 1))
                mt = similar(m)
                copy!(mt, m)
                blocktranspose!(mt)
                mt == transpose(m)
            end
        end
    end
end
