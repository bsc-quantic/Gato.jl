using Quac
using LinearAlgebra: Diagonal, rmul!

function apply!(Ψ::State{F}, gate::AbstractGate) where {F<:AbstractFloat}
    apply_matmul!(Ψ, gate)
end

function apply_matmul!(Ψ::State{F}, gate) where {F<:AbstractFloat}
    # TODO permute indices
    perm = ...
    permutedims!(Ψ.data, perm)

    shape = size(Ψ.data)
    Ψ.data = reshape(Ψ.data, ...)

    # TODO multiply matrices
end

# TODO get #lanes from type of `gate`, so `Array{T,N}` is not constructed dynamically if possible
# apply!(Ψ::State{T}, gate::AbstractGate) where {T} = Array{T,length(lanes(gate))}()

apply!(Ψ::State, gate::I) = nothing

# TODO use antidiagonal representation or just permute memory? maybe former should be part of latter
function apply!(Ψ::State, gate::X)
    error("not implemented yet")
end

# TODO use antidiagonal representation
function apply!(Ψ::State, gate::Y)
    error("not implemented yet")
end

function apply!(Ψ::State, gate::Z)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>1], -1)
end

function apply!(Ψ::State, gate::H)
    error("not implemented yet")
end

function apply!(Ψ::State, gate::S)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>1], cispi(1 // 2))
end

function apply!(Ψ::State, gate::Sd)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>1], cispi(-1 // 2))
end

function apply!(Ψ::State, gate::T)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>1], cispi(1 // 4))
end

function apply!(Ψ::State, gate::Td)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>1], cispi(-1 // 4))
end

function apply!(Ψ::State, gate::Rx)
    error("not implemented yet")
end

function apply!(Ψ::State, gate::Ry)
    error("not implemented yet")
end

function apply!(Ψ::State, gate::Rz)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>1], cis(x.θ))
end

# TODO check no problem if single control or multicontrol
function apply!(Ψ::State, gate::Control)
    addr = [lane => 1 for lane in control(gate)]
    apply!(Ψ[addr...], gate.op)
end

# TODO create own `permutedims!` (it does not support in-place permutation)
apply!(Ψ::State, gate::Swap) = error("not implemented yet")
