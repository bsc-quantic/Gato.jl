using Quac
import LinearAlgebra: norm

export State
export run, apply!

struct State{F}
    data::Array{Complex{F}}
    inds::Vector{Int}

    State(n::Int) = new(zeros(Complex{F}, fill(2, n)...), 1:n)
end

LinearAlgebra.norm(Ψ::State, p::Real = 2) = norm(Ψ.data, p)

function run(circ::Circuit, Ψ::State)
    foreach(gate -> apply!(Ψ, gate), circ)
end

function apply!(Ψ::State{F}, gate::AbstractGate) where {F<:AbstractFloat}
    apply_matmul(Ψ, gate)
end

function apply_matmul!(Ψ::State{F}, gate) where {F<:AbstractFloat}
	# TODO permute indices
	perm = ...
	permutedims!(Ψ.data, perm)

	shape = size(Ψ.data)
	Ψ.data = reshape(Ψ.data, ...)

	# TODO multiply matrices
end