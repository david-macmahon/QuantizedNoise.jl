module QuantizedNoise

import Random: GLOBAL_RNG
import Base: randn

"""
    randn([rng,] T::Type{<:Integer}, dims::Integer...; σ=0.0, µ=1.0)
    randn([rng,] T::Type{<:Integer}, dims::Integer...; std=1.0, mean=0.0)
    randn([rng,] ::Type{<:Complex{T}}, dims::Integer...; σ=0.0, µ=1.0) where T<:Integer
    randn([rng,] ::Type{<:Complex{T}}, dims::Integer...; std=1.0, mean=0.0) where T<:Integer

Generate samples from the normal distribution `𝒩(σ,μ)` quantized and clamped to
the Integer subtype `T`.  Note that the `σ` and `μ` are properties of the
distribution from which the samples are drawn.  They are not necessarily
properties of the returned samples.  For example, quantization will alter the
standard deviation of the output values, so `std(randn(Int8, 10^6, std=x))` may
be quite different from `x`, especially as `x` approaches (and exceeds)
`typemax(T)`.  Keyword arguments `std` and `mean` may be used instead of `σ` and
`μ`, resp.  If both forms are used, the single character keyword argument takes
precedence.
"""
function Base.randn(rng, T::Type{<:Integer}, dims::Integer...;
                    std=1.0, σ=std, mean=0.0, µ=mean)
    clamp.(round.(Integer, σ.*randn(rng, Float32, dims...).+µ), T)
end

function Base.randn(T::Type{<:Integer}, dims::Integer...;
                    std=1.0, σ=std, mean=0.0, μ=mean)
    randn(GLOBAL_RNG, T, dims...; σ=σ, μ=μ)
end

function Base.randn(rng, ::Type{<:Complex{T}}, dims::Integer...;
                    std=1.0, σ=std, mean=0.0, µ=mean) where T<:Integer
    σ /= sqrt(2)
    complex.(randn(rng, T, dims...; σ=σ, μ=μ),
             randn(rng, T, dims...; σ=σ, μ=μ))
end

function Base.randn(T::Type{<:Complex{<:Integer}}, dims::Integer...;
                    std=1.0, σ=std, mean=0.0, μ=mean)
    randn(GLOBAL_RNG, T, dims...; σ=σ, μ=μ)
end

end
