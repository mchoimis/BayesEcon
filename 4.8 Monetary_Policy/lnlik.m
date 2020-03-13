% 로그 우도함수 계산하기
function lnL = lnlik(theta,Spec) 

Data = Spec.Data;
FFR = Data(:,1);
Inflation = Data(:,2);
UN = Data(:,3);

rho = theta(1);
c = theta(2);
beta1 = theta(3); 
beta2 = theta(4); 
sig2 = theta(5); 

T = rows(Data); 

Yt = FFR(2:T);
Ybar = (1 - rho)*c + (1 - rho)*beta1*Inflation(1:T-1) + (1 - rho)*beta2*UN(1:T-1) + rho*FFR(1:T-1);
sigma = sig2* ones(T-1,1);
lnLm = lnpdfn(Yt, Ybar, sigma); % (T-1) by 1
lnL = sumc(lnLm); % 우도값
   
end