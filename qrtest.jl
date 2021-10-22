using LinearAlgebra
using Octavian
using .Threads

# Julia adaptation of the following matlab code: https://rpubs.com/Barry_Daemi/682958

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

@views function MGS(A::Matrix{Float64})
    ~, n = size(A)
    Q = copy(A)
    R = zeros(n,n)
    @threads for j = 1:n
        nn = norm(Q[:,j])
        R[j,j] = nn
        Q[:,j] /= nn
        
        aux = matmul(Q[:,j]', Q[:,j+1:n])
        
        R[j,j+1:n] = aux
#        matmul!(reshape(R[j,j+1:n], 1, :), Q[:,j]', Q[:,j+1:n])

         Q[:,j+1:n] -= matmul(hcat(Q[:,j]), aux)
#        Q[:,j+1:n] -= hcat(Q[:,j]) * R[j,j+1:n]'
#        Q[:,j+1:n] -= matmul( reshape(Q[:,j], :, 1), reshape(R[j,j+1:n], 1, :))
#        Q[:,j+1:n] -= matmul(hcat(Q[:,j]), hcat(R[j,j+1:n]'))
#        Q[:,j+1:n] -= matmul( Q[:,j][:,:], R[j,j+1:n][:,:]')

    end
    return Q, R
end

A = rand(50, 50)
B = rand(50, 1)

@time begin
X1 = A \ B
end

@time begin
X2 = qr(A, Val(true)) \ B
end

@time begin
Q3, R3 = qr(A)
X3 = R3 \ (transpose(Q3) * B)
end

@time begin
Q4, R4 = MGS(A)
X4 = R4 \ matmul(transpose(Q4), B)
end

println(maximum(X1 - X2))
println(maximum(X1 - X3))
println(maximum(X1 - X4))



