using StaticArrays: SMatrix
using LinearAlgebra: transpose!, checksquare

__precompile__(true)

# TODO support rectangular matrices?
function blocktranspose!(A::StridedMatrix{T}) where {T}
    N = checksquare(A)

    buffer = SMatrix{N,N}(A)
    transpose!(A, buffer)
end

for T in [ComplexF32, ComplexF64]
    precompile(blocktranspose!, (StridedMatrix{T},))
end