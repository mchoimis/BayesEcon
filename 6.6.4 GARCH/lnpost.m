% ���Ĺе� 
function lnpost0 = lnpost(theta, Spec)

    lnlik0 = lnlik(theta, Spec); % �쵵
    lnprior0 = lnprior(theta, Spec); % ���� �е�
    lnpost0 = lnlik0 + lnprior0;
  
end
