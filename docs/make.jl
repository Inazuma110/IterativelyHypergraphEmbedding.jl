using IterativelyHypergraphEmbedding
using Documenter

DocMeta.setdocmeta!(IterativelyHypergraphEmbedding, :DocTestSetup, :(using IterativelyHypergraphEmbedding); recursive=true)

makedocs(;
    modules=[IterativelyHypergraphEmbedding],
    authors="Inazuma110 <c011703534@edu.teu.ac.jp> and contributors",
    repo="https://github.com/Inazuma110/IterativelyHypergraphEmbedding.jl/blob/{commit}{path}#{line}",
    sitename="IterativelyHypergraphEmbedding.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Inazuma110.github.io/IterativelyHypergraphEmbedding.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Inazuma110/IterativelyHypergraphEmbedding.jl",
)
