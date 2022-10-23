using Quac

export State
export run, apply!, data

# TODO allow for physical dimensions != 2
"""
Represents the statevector of a pure state with a dense array.
"""
struct State{A<:AbstractArray}
    data::A
end

State(data::A) where {A<:AbstractArray} = State{A}(data)

function State{F}(n::Int) where {F<:AbstractFloat}
    data = zeros(Complex{F}, fill(2, n)...)
    data[1] = 1.0 + 0.0im

    State(data)
end

State(n::Int) = State{Float32}(n)

data(Ψ::State) = Ψ.data

eltype(::Type{State{A}}) where {A} = eltype(A)
eltype(o::State{A}) where {A} = eltype(A)

# TODO return a view of the `State`
function Base.getindex(s::State, p::Base.Pairs{Int,Int})
    error("not implemented yet")
end

run(circ::Circuit, Ψ::State) = foreach(gate -> apply!(Ψ, gate), circ)
