"""
  iteratively_hypergraph_embedding(h::Hypergraph; dims=2, epoch=100)

Embeds hypernodes and hyperedges into a `dims`-dimensional vector.
Time complexity is O(`epoch` * `dims` * ∑ᵥdeg(v)).

**Arguments**
* h : Hypergraph
* dims : Dimension of the embedded vector
* epoch : Number of iterations to be performed to obtain each vector.
As large as possible is better.

"""
function iteratively_hypergraph_embedding(h::Hypergraph;
    dims::Int=2, max_epoch::Int=10000)
  @assert length(get_connected_components(h)) == 1 "Not Connected."
  N = nhv(h)
  M = nhe(h)
  X=rand(Uniform(-1, 1), dims, M)
  Y=rand(Uniform(-1, 1), dims, N)
  foreach(normalize!, eachcol(X))
  foreach(normalize!, eachcol(Y))
  old_sum_dot = Inf

  for e in 1:epoch
    for d in 1:dims Y[d, :] .-= mean(Y[d, :]) end
    X_new = zeros(dims, M)
    for he in 1:M
      hns = keys(getvertices(h, he))
      gᵣ = length(hns)
      for hn in hns
        dᵥ = length(gethyperedges(h, hn))
        X_new[:, he] += Y[:, hn]
      end
    end

    for d in 1:dims X_new[d, :] .-= mean(X_new[d, :]) end
    new_sum_dot = sum(dot.(eachcol(X), eachcol(X_new)))
    foreach(normalize!, eachcol(X_new))
    X = deepcopy(X_new)

    for d in 1:dims X[d, :] .-= mean(X[d, :]) end
    Y_new = zeros(dims, N)
    for hn in 1:N
      hes = keys(gethyperedges(h, hn))
      dᵥ = length(hes)
      for he in hes
        gᵣ = length(getvertices(h, he))
        Y_new[:, hn] += X[:, he]
      end
    end
    for d in 1:dims Y_new[d, :] .-= mean(Y_new[d, :]) end
    foreach(normalize!, eachcol(Y_new))
    Y = deepcopy(Y_new)

    if abs(new_sum_dot - old_sum_dot) < 1e-8
      println(e)
      break
    end
    old_sum_dot = new_sum_dot
  end

  return X, Y
end
