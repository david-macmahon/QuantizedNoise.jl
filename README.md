# QuantizedNoise

This package provide the function `randqn` that generate random values from the
normal distribution `𝒩(μ,σ²)` quantized to `Integer` and `Complex{<:Integer>}`
types.  Usage is pretty much the same as `Base.randn` except for the addition of
`σ` and `µ` keyword arguments for the desired standard deviation and mean.  If
unspecified, `σ` defaults to 1.0 and `µ` defaults to 0.0.  The keywords `std`
and `mean` may be used instead of `σ` and `µ`, respectively.

## Usage

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

## Examples

```julia
julia> using QuantizedNoise

julia> randqn(Int8, std=13)
25

julia> randqn(Int8, 2, 3, σ=13)
2×3 Matrix{Int8}:
  97  108  89
 100   97  98

julia> randqn(Int8, 2, 3, σ=10, µ=100)
2×3 Matrix{Int8}:
 104  101  99
  83   94  94

julia> randqn(Complex{Int8}, 2, 3, σ=30)
2×3 Matrix{Complex{Int8}}:
   6-17im  -29-48im  -19+11im
 -31+18im    1+9im   -37+22im
```

## Installation

Until this becomes part of Julia's global registry, this package can be
installed from the Julia REPL by:

```
using Pkg
Pkg.add("https://github.com/david-macmahon/QuantizedNoise.jl")
```
...or...
```
]add https://github.com/david-macmahon/QuantizedNoise.jl
```
