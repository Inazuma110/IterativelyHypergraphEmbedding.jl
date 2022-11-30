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

This figure shows a hypergraph constructed from Cora's co-citation network and embedded in three dimensions by this algorithm.
![image](https://user-images.githubusercontent.com/31335755/204723113-f24665f7-bd0f-4401-838c-1805a76dfc52.png)



## Refer
- [埋め込みベクトル間の類似度に基づく高速なハイパーグラフクラスタリング](https://www.jstage.jst.go.jp/article/jsaikbs/123/0/123_10/_article/-char/ja/)
- [High-Speed and Noise-Robust Embedding of Hypergraphs Based on Double-Centered Incidence Matrix](https://www.springerprofessional.de/en/high-speed-and-noise-robust-embedding-of-hypergraphs-based-on-do/19984222)

## Contribution
Fork and send Pull Request.
