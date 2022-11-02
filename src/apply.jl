using Quac
using LinearAlgebra: Diagonal, rmul!

function apply!(Ψ::State{F}, gate::AbstractGate) where {F<:AbstractFloat}
    apply_matmul!(Ψ, gate)
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

@doc raw"""
Apply the **SWAP** gate to ``\Psi`` `State`.

# Notes
Current implementation lazily permutes the amplitude: i.e. it does not permute the data but the pointers to the data.
"""
function apply!(Ψ::State, gate::Swap)
    q1, q2 = lanes(gate)
    Ψ.inds[q1], Ψ.inds[q2] = Ψ.inds[q2], Ψ.inds[q1]
end
