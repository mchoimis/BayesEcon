function [beta1, beta2, Y1, Y2, X1, X2] = Gen_beta(Y, X, Sm, sig21, sig22, beta0, B0)

Y1 = Y(Sm == 1);
Y2 = Y(Sm == 2);

X1 = X(Sm == 1, :);
X2 = X(Sm == 2, :);

B0inv = inv(B0);
k = cols(X);

%% ·¹Áü 1
sig2inv = 1/sig21;
B1inv = sig2inv*(X1'*X1) + B0inv;
B1 = inv(B1inv);
A = sig2inv*X1'*Y1 + B0inv*beta0;
beta1 = B1*A + chol(B1)'*randn(k, 1);

%% ·¹Áü 2
sig2inv = 1/sig22;
B1inv = sig2inv*(X2'*X2) + B0inv;
B1 = inv(B1inv);
A = sig2inv*X2'*Y2 + B0inv*beta0;
beta2 = B1*A + chol(B1)'*randn(k, 1);
    
end