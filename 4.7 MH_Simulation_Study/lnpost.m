% 로그 사후밀도의 커넬 계산하기
function lnpost = lnpost(theta, Spec) 

lnL = lnlik(theta, Spec); % 로그 우도
lnPrior = lnprior(theta, Spec); % 로그 사전밀도

lnpost = lnL + lnPrior;
   
end