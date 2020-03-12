function [ lnpr ] = lnprior(theta, b_0, B_0, a_0, d_0 )
% Linear regression

k = rows(b_0);
beta = theta(1:k);
sig2 = theta(end);

lnpriorm = zeros(2,1);

lnpriorm(1) = lnpdfmvn(beta,b_0,B_0);
lnpriorm(2) = lnpdfig(sig2,a_0/2,d_0/2);

lnpr = sumc(lnpriorm);


end

