using Random
"""
  iteratively_hypergraph_embedding(h::Hypergraph; dims=2, epoch=10000)

Embeds hypernodes and hyperedges into a `dims`-dimensional vector.
Time complexity is O(`epoch` * `dims` * ∑ᵥdeg(v)).

**Arguments**
* h : Hypergraph.
* dims : Dimension of the embedded vector.
* max_epoch : Number of iterations to be performed to obtain each vector.
As large as possible is better.
* ϵ : Convergence condition.
"""

function iteratively_hypergraph_embedding(h::Hypergraph; dims::Int=2,
    max_epoch::Int=10000, ϵ::Float64=1e-8, seed=nothing,
    hn_vec=nothing,
    he_vec=nothing,
    fast=true
    )
  N = nhv(h)
  M = nhe(h)
  if !isnothing(seed) Random.seed!(seed) end
  if isnothing(hn_vec) hn_vec = rand(Uniform(-1, 1), dims, nhv(h)) end
  if isnothing(he_vec) he_vec = rand(Uniform(-1, 1), dims, nhe(h)) end

  if !fast
    return use_double_centered_matrix(h, hn_vec, he_vec, max_epoch, ϵ)
  end

  foreach(normalize!, eachcol(he_vec))
  foreach(normalize!, eachcol(hn_vec))
  old_sum_dot = Inf

  for e in 1:max_epoch
    for d in 1:dims hn_vec[d, :] .-= mean(hn_vec[d, :]) end
    he_vec_new = zeros(dims, M)
    for he in 1:M
      hns = keys(getvertices(h, he))
      gᵣ = length(hns)
      for hn in hns
        dᵥ = length(gethyperedges(h, hn))
        he_vec_new[:, he] += hn_vec[:, hn]
      end
    end

    for d in 1:dims he_vec_new[d, :] .-= mean(he_vec_new[d, :]) end
    new_sum_dot = sum(dot.(eachcol(he_vec), eachcol(he_vec_new)))
    foreach(normalize!, eachcol(he_vec_new))
    he_vec = deepcopy(he_vec_new)

    for d in 1:dims he_vec[d, :] .-= mean(he_vec[d, :]) end
    hn_vec_new = zeros(dims, N)
    for hn in 1:N
      hes = keys(gethyperedges(h, hn))
      dᵥ = length(hes)
      for he in hes
        gᵣ = length(getvertices(h, he))
        hn_vec_new[:, hn] += he_vec[:, he]
      end
    end
    for d in 1:dims hn_vec_new[d, :] .-= mean(hn_vec_new[d, :]) end
    foreach(normalize!, eachcol(hn_vec_new))
    hn_vec = deepcopy(hn_vec_new)

    if abs(new_sum_dot - old_sum_dot) < ϵ
      break
    end
    old_sum_dot = new_sum_dot
  end

  return hn_vec, he_vec
end

function use_double_centered_matrix(h::Hypergraph, hn_vec, he_vec, max_epoch, ϵ)
    inc_mat = deepcopy(h[:, :])
    inc_mat[inc_mat .=== nothing] .= 0
    f(mat)::Matrix{Real} = mat
    double_centerd_mat = double_centering(f(inc_mat))
    old_sum_dot = Inf

    for e in 1:max_epoch
      tmp = deepcopy(he_vec)
      he_vec = (double_centerd_mat' * hn_vec')'
      hn_vec = (double_centerd_mat * tmp')'
      new_sum_dot = sum(dot.(eachcol(he_vec), eachcol(tmp)))
      foreach(normalize!, eachcol(he_vec))
      foreach(normalize!, eachcol(hn_vec))
      if abs(new_sum_dot - old_sum_dot) < ϵ
        break
      end
      old_sum_dot = new_sum_dot
    end

    return hn_vec, he_vec
end

function double_centering(mat::Matrix{Real})::Matrix{Real}
  n = size(mat)[1]
  m = size(mat)[2]
  jₙ = Matrix(I, n, n) - ones(n, n) / n
  jₘ = Matrix(I, m, m) - ones(m, m) / m
  return jₙ * mat * jₘ
end
