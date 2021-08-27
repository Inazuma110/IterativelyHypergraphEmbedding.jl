# IterativelyHypergraphEmbedding.jl
This is one of hypergraph embedding methods.

## Install
```jl
Pkg.add("https://github.com/Inazuma110/IterativelyHypergraphEmbedding.jl")
```

## Usage
```jl
hn_vec, he_vec = iteratively_hypergraph_embedding(h::Hypergraph, dims::Int=2,
    max_epoch::Int=10000, ϵ::Float64=1e-8)
```
`hn_vec` is a d-dimensional vector representation of the hypernode.
Note:
`h` must be a reachable.

## Contribution
Fork and send Pull Request.
