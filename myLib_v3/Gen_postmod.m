function [theta_hat, lnpost_hat,lnlik_hat,lnpostm] = Gen_postmod(Data, MHm, b_0,B_0,a_0,d_0 )
% 사후 모드 찾기
% theta_hat = 사후모드
% lnpost_hat = 사후 밀도 극대값


n = rows(MHm); % MCMC size
lnpostm = zeros(n,1); % 로그사후밀도함수값 저장할 방
lnpost_hat = -exp(20);
for iter = 1:n
    
    theta = MHm(iter,:)';
    
    lnlik1 = lnlik(theta,Data);
    lnprior1 = lnprior(theta,b_0,B_0,a_0,d_0);
    lnpost1 = lnlik1 + lnprior1;
    lnpostm(iter) = lnpost1;
    if lnpost1 > lnpost_hat
        theta_hat = theta;
        lnpost_hat = lnpost1;
        lnlik_hat = lnlik1;
    end
    
    
end


end

