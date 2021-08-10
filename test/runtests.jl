using IterativelyHypergraphEmbedding
using SimpleHypergraphs
using Test

@testset "IterativelyHypergraphEmbedding.jl" begin
  h = Hypergraph{Int, Int}(4, 0)
  add_hyperedge!(h, vertices=Dict(1=>1, 2=>1, 3=>1))
  add_hyperedge!(h, vertices=Dict(3=>1, 4=>1))
  dims = 10
  hn_vec, he_vec = iteratively_hypergraph_embedding(h, dims)
  @test size(hn_vec) == (dims, nhv(h))
  @test size(he_vec) == (dims, nhe(h))

  h = Hypergraph{Int, Int}(4, 0)
  add_hyperedge!(h, vertices=Dict(1=>1, 2=>1, 3=>1))
  add_hyperedge!(h, vertices=Dict(3=>1, 4=>1))
  dims = 10
  hn_vec, he_vec = iteratively_hypergraph_embedding(h, dims)
  @test size(hn_vec) == (dims, nhv(h))
  @test size(he_vec) == (dims, nhe(h))
end
