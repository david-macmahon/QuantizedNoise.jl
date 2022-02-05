module QuantizedNoise

export randqn

import Random: GLOBAL_RNG

"""
    randqn([rng,] T::Type{<:Integer}, dims::Integer...; σ=1.0, µ=0.0)
    randqn([rng,] T::Type{<:Integer}, dims::Integer...; std=1.0, mean=0.0)
    randqn([rng,] ::Type{<:Complex{T}}, dims::Integer...; σ=1.0, µ=0.0) where T<:Integer
    randqn([rng,] ::Type{<:Complex{T}}, dims::Integer...; std=1.0, mean=0.0) where T<:Integer

Generate samples from the normal distribution `𝒩(μ,σ²)` quantized and clamped
to the Integer subtype `T`.  Note that the `σ` and `μ` are properties of the
distribution from which the samples are drawn.  They are not necessarily
properties of the returned samples.  For example, quantization will alter the
standard deviation of the output values, so `std(randqn(Int8, 10^6, std=x))` may
be quite different from `x`, especially as `x` approaches (and exceeds)
`typemax(T)`.  Keyword arguments `std` and `mean` may be used instead of `σ` and
`μ`, resp.  If both forms are used, the single character keyword argument takes
precedence.

For complex types, the standard deviation `σ` or `std` may be given as a `Real`
or `Complex`.  If `σ` is given as a `Real`, it specifies the standard deviation
of the complex values (i.e. each real/imaginary component will have a standard
deviarion of `σ/sqrt(2)`). If given as a `Complex`, each real/imaginary
component of `σ` will be the standard deviation of the corresponding components
of the output.  Note that `σ=1.0` is equivalent to `σ=(1+1im)/sqrt(2)`.
Likewise, if `µ` is a `Real`, the complex mean will be `µ+µ*im`.
"""
function randqn(rng, T::Type{<:Integer}, dims::Integer...;
                    std=1.0, σ=std, mean=0.0, µ=mean)
    clamp.(round.(Integer, σ.*Base.randn(rng, Float32, dims...).+µ), T)
end

function randqn(T::Type{<:Integer}, dims::Integer...;
                    std=1.0, σ=std, mean=0.0, μ=mean)
    randqn(GLOBAL_RNG, T, dims...; σ=σ, μ=μ)
end

function randqn(rng, ::Type{<:Complex{T}}, dims::Integer...;
                    std=1.0, σ=std, mean=1.0, µ=mean) where T<:Integer
    σr, σi = (typeof(σ) <: Real) ? (σ, σ)./sqrt(2) : (real(σ), imag(σ))
    µr, µi = (typeof(µ) <: Real) ? (µ, µ) : (real(µ), imag(µ))

    complex.(randqn(rng, T, dims...; σ=σr, μ=μr),
             randqn(rng, T, dims...; σ=σi, μ=μi))
end

function randqn(T::Type{<:Complex{<:Integer}}, dims::Integer...;
                    std=1.0, σ=std, mean=0.0, μ=mean)
    randqn(GLOBAL_RNG, T, dims...; σ=σ, μ=μ)
end

end
