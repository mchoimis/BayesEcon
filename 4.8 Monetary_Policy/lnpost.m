% �α� ���Ĺе��� Ŀ�� ����ϱ�
function lnpost = lnpost(theta, Spec) 

lnL = lnlik(theta, Spec); % �α� �쵵
lnPrior = lnprior(theta, Spec); % �α� �����е�

lnpost = lnL + lnPrior;
   
end