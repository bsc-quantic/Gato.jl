using Quac
import LinearAlgebra: norm

export State
export run, apply!

# TODO allow for physical dimensions != 2
"""
Represents the statevector of a pure state with a dense array.
"""
struct State{F}
    data::AbstractArray{Complex{F}}
    inds::Vector{Symbol}

	"""
		State{F}(n)

	Initialize `State` to $\ket{0 \dots 0}$ product state.
	"""
    function State{F}(n::Int)
		data = zeros(Complex{F}, fill(2, n)...)
		data[1] = 1.0 + 0.0im
		new(, 1:n)
	end
end

State(n::Int) = State{Float32}(n)

LinearAlgebra.norm(Ψ::State, p::Real=2) = norm(Ψ.data, p)


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