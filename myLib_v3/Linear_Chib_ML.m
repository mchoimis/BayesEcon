function [lnML, ln_joint_post]  = Linear_Chib_ML( Data,MHm,b_0,B_0,a_0,d_0 )
% log marginal likelihood for linear regression model
% Chib ���
% lnML = lnpost - ln_joint_post

%% ���ĸ�� ����ϱ�
[theta_hat,lnpost_hat] = Gen_postmod(Data, MHm, b_0,B_0,a_0,d_0 );

%% ���Ĺе� ����ϱ�
k = rows(b_0);
betam = MHm(:,1:k);
ln_joint_post = Logpost(Data, betam,theta_hat,b_0,B_0,a_0,d_0 );

lnML = lnpost_hat - ln_joint_post;

disp('================================================================');
disp('Chib ���');
disp('----------------------------------------------------------------');
disp(['�ֺ� �쵵 = ', num2str(lnML)]);
disp(['�쵵 +  �����е� = ', num2str(lnpost_hat)]);
disp(['���� �е� = ', num2str(ln_joint_post)]);
disp('=================================================================');


end

function ln_joint_post = Logpost(Data,betam,theta_hat,b_0,B_0,a_0,d_0 )

Y = Data(:,1);
X = Data(:,2:end);
T = rows(Data);
n = rows(betam);
k = rows(b_0);

beta_hat = theta_hat(1:k);
sig2_hat = theta_hat(end);

%% 1. log full conditional for beta
XX = X'*X;
XY = X'*Y;
precB_0 = invpd(B_0);
sig2_inv = 1/sig2_hat;

B_1 = invpd(sig2_inv*XX + precB_0); % full conditional variance B_1
A = (sig2_inv*XY + precB_0*b_0);
M = B_1*A; 

lnfcb = lnpdfmvn(beta_hat,M,B_1); % log full conditional for beta

%% 2. log posterior for sig2
igpdfm = zeros(n,1);

a_1 = T + a_0;
for iter = 1:n
    
b = betam(iter,:)';    
e = Y - X*b;
d_1 = d_0 + e'*e;

igpdfm(iter) = exp(lnpdfig(sig2_hat,a_1/2,d_1/2));

end

igpdf = meanc(igpdfm);
lnig = log(igpdf);

%% ���Ĺе�

ln_joint_post = lnfcb + lnig;

end

