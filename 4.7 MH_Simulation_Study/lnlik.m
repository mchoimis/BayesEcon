% �α� �쵵�Լ� ����ϱ�
function lnL = lnlik(theta,Spec) 

Data = Spec.Data;
Y = Data(:,1);
X = Data(:,2:end);

beta = theta(1:end-1);
sig2 = theta(end);

T = rows(Data); 

sigma = sig2* ones(T,1);
lnLm = lnpdfn(Y, X*beta, sigma); % (T-1) by 1
lnL = sumc(lnLm); % �쵵��
   
end