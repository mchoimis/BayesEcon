function [ lnL ] = lnlik(theta, Data)
% 우도 계산

Y = Data(:,1);
X = Data(:,2:end);
k = cols(X);
T = rows(Y);

beta = theta(1:k);
sig2 = theta(k+1);

e = Y - X*beta;
lnL = sumc(lnpdfn(e,zeros(T,1),sig2*ones(T,1)));

end

