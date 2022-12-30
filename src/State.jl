import Base: eltype, size, ndims

using Quac

export State
export run!, apply!, data

# TODO allow for physical dimensions != 2
"""
Represents the statevector of a pure state with a dense array.
"""
struct State{T,N,S<:AbstractArray}
    data::S
    inds::Vector{Int}

    function State(data::S, inds) where {S<:AbstractArray}
        T = eltype(S)
        N = ndims(S)

        new{T,N,S}(data, inds)
    end
end

State(data::S) where {S<:AbstractArray} = State(data, [i for i in 1:ndims(data)])

State(n::Int) = State(Float32, n)

function State(::Type{T}, n::Int) where {T}
    data = zeros(Complex{T}, fill(2, n)...)
    data[1] = 1.0 + 0.0im

    State(data)
end

data(Ψ::State) = Ψ.data

eltype(::Type{State{A}}) where {A} = eltype(A)
eltype(o::State{A}) where {A} = eltype(A)

ndims(o::State) = ndims(o.data)

size(o::State) = size(o.data)
size(o::State, x) = size(o.data, x)

function Base.getindex(s::State, p::Base.Pair{Int,Int})
    d, i = p
    content = selectdim(data(s), d, i)

    shape = size(content) |> collect
    insert!(shape, d, 1)

    content = reshape(content, shape...)
    return State(content)
end

run!(Ψ::State, circ::Circuit) = foreach(gate -> apply!(Ψ, gate), circ)
