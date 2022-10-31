using Test
using Gato: State

@testset "State constructor" begin
    @test State(1) isa State
    @test State(Float64, 1) isa State
end