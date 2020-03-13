% compute the log prior density
function [priorj] = lnprior(theta,Spec)

 theta_ = Spec.theta_; % 사전 평균
 thetav_ = Spec.thetav_; % 사전 분산

 priorj = lnpdfn(theta(1:3), theta_, thetav_);
 priorj = sumc(priorj);

 sig2_L = theta(1)/(1 - theta(2) - theta(3)); 
 priorj = priorj + lnpdfn(theta(4), 0, sig2_L);
 
end