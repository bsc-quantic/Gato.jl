using Quac
using LinearAlgebra: Diagonal, rmul!
import .Kernel

function apply!(Ψ::State{F}, gate::AbstractGate) where {F<:AbstractFloat}
    apply_matmul!(Ψ, gate)
end

# TODO get #lanes from type of `gate`, so `Array{T,N}` is not constructed dynamically if possible
# apply!(Ψ::State{T}, gate::AbstractGate) where {T} = Array{T,length(lanes(gate))}()

apply!(Ψ::State, gate::I) = nothing

@doc raw"""
Apply the ``X`` gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::X)
    lane = only(lanes(gate))
    A = selectdim(data(Ψ), lane, 1)
    B = selectdim(data(Ψ), lane, 2)
    Kernel.swap!(A, B)
end

@doc raw"""
Apply the ``Y`` gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::Y)
    lane = only(lanes(gate))
    A = selectdim(data(Ψ), lane, 1)
    B = selectdim(data(Ψ), lane, 2)
    rmul!(A, -1im)
    rmul!(B, 1im)
    Kernel.swap!(A, B)
end

@doc raw"""
Apply the ``Z`` gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::Z)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>2], -1)
end

@doc raw"""
Apply the Hadamard gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::H)
    error("not implemented yet")
end

@doc raw"""
Apply the ``S`` gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::S)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>2], cispi(1 // 2))
end

@doc raw"""
Apply the ``S^\dagger`` gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::Sd)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>2], cispi(-1 // 2))
end

@doc raw"""
Apply the ``T`` gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::T)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>2], cispi(1 // 4))
end

@doc raw"""
Apply the ``T^\dagger`` gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::Td)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>2], cispi(-1 // 4))
end

@doc raw"""
Apply the ``R_X`` gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::Rx)
    error("not implemented yet")
end

@doc raw"""
Apply the ``R_Y`` gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::Ry)
    error("not implemented yet")
end

@doc raw"""
Apply the ``R_Z`` gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::Rz)
    lane = only(lanes(gate))
    rmul!(Ψ[lane=>1], cis(x.θ))
end

# TODO check no problem if single control or multicontrol
@doc raw"""
Apply the `Control{T}` gate to the ``\Psi`` `State`.
"""
function apply!(Ψ::State, gate::Control)
    addr = [lane => 2 for lane in control(gate)]
    apply!(Ψ[addr...], gate.op)
end

@doc raw"""
Apply the ``SWAP`` gate to ``\Psi`` `State`.

# Notes
Current implementation lazily permutes the amplitude: i.e. it does not permute the data but the pointers to the data.
"""
function apply!(Ψ::State, gate::Swap)
    q1, q2 = lanes(gate)
    Ψ.inds[q1], Ψ.inds[q2] = Ψ.inds[q2], Ψ.inds[q1]
end
