A = rand(2000, 100);
B = rand(2000, 1);

tic;
[Q1, R1] = qr(A);
X1 = R1\(pinv(Q1)*B);
toc;

tic;
[Q2, R2] = MGS(A);
X2 = R2\(pinv(Q2)*B);
toc;

tic;
X3 = A \ B;
toc;

max(X1 - X3)
max(X2 - X3)


% Source: https://rpubs.com/Barry_Daemi/682958
function [Q,R] = MGS(A)
% Usage: [Q,R] = MGS(A)
%
% This routine numerically approximates a thin QR decomposition, using 
% BLAS - 2 (Basic Linear Algebra Subroutine - 2), Modified Gran-Schmidt. 
% The routine also calculates the factorization and orthogonality errors
% accrued by the decomposition algrotihm.
%
% Inputs:  A      Randomly generated a m-by-n sized Matrix 
%                 
% Outputs: Q      The orthogonal matrix: Q
%          R      The upper triangular matrix: R
%
    [~,n] = size(A);
    Q = A;
    R = zeros(n,n);
    
    for j = 1:n
        R(j,j) = norm(Q(:,j));
        if (R(j,j) == 0)
            error('linearly dependent columns');
        end
        Q(:,j) = Q(:,j)/R(j,j);
        R(j,j+1:n) = Q(:,j)'*Q(:,j+1:n);
        Q(:,j+1:n) = Q(:,j+1:n) - Q(:,j)*R(j,j+1:n);
    end
end