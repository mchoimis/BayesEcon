% 사후밀도 
function lnpost0 = lnpost(theta, Spec)

    lnlik0 = lnlik(theta, Spec); % 우도
    lnprior0 = lnprior(theta, Spec); % 사전 밀도
    lnpost0 = lnlik0 + lnprior0;
  
end
