using LinearAlgebra
using StaticArrays
using Octavian
using .Threads

# Julia adaptation of the following Matlab code: https://rpubs.com/Barry_Daemi/682958

# Usage: [Q,R] = MGS(A)
#
# This routine numerically approximates a thin QR decomposition,
# Modified Gran-Schmidt. 
# The routine also calculates the factorization and orthogonality errors
# accrued by the decomposition algorithm.
#
# Inputs:  A      Randomly generated a m-by-n sized Matrix 
#                 
# Outputs: Q      The orthogonal matrix: Q
#          R      The upper triangular matrix: R

function MGS(A::Matrix{Float64})
    m, n = size(A)
    Q = copy(A)
    R = zeros(Float64, n, n)
    nn = 0.0
    aux1 = SMatrix{m, n, Float64, m*n}
    @views for j = 1:n
        nn = norm(Q[:,j])
        R[j,j] = nn
        Q[:,j] /= nn

        aux1 = reshape(Q[:,j], :, 1)
        aux2 = matmul(Q[:,j]', Q[:,j+1:n])
        #aux2 = matmul(transpose(Q[:,j]), Q[:,j+1:n])

        R[j,j+1:n] = aux2

        Q[:,j+1:n] .-= aux1 .* aux2
        #Q[:,j+1:n] .-= matmul(aux1, aux2)

    end
    return Q, R
end


m = 100000
n = 100
A = rand(m, n)
B = rand(m, 1)

@time begin
X1 = A \ B
end

@time begin
X2 = qr(A, Val(true)) \ B
end

@time begin
Q3, R3 = MGS(A)
X3 = R3 \ matmul(transpose(Q3), B)
end
;

println(maximum(X1 - X2))
println(maximum(X1 - X3))

