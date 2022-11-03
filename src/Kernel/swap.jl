using StaticArrays: MVector
import SIMD: vload

"""
    swap!(A, B)

Swaps the content of two `StridedArray`s or `SubArray`s.
"""
function swap! end

function swap!(A::Ptr{T}, B::Ptr{T}, buffer::MVector{N,T}) where {T,N}
    unsafe_copyto!(buffer, A, N)
    unsafe_copyto!(A, B, N)
    unsafe_copyto!(B, buffer, N)
end

function swap_intercacheline_vectorized(A::Ptr{T}, B::Ptr{T}) where {T,CL}
    const N = T ÷ CL
    buffer = vload(SIMD.Vec{N,T}, A)

    error("not implemented yet")
end

function swap_aligned_warp_shuffle(cl)
    error("not implemented yet")
end