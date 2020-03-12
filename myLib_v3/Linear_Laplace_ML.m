function [ lnML, ln_joint_post ] = Linear_Laplace_ML( Data,MHm,b_0,B_0,a_0,d_0 )
% log marginal likelihood for linear regression model
% ���ö� ���
% lnML = lnpost - ln_joint_post
%% ���ĸ�� ����ϱ�
[theta_hat,lnpost_hat] = Gen_postmod(Data, MHm, b_0,B_0,a_0,d_0 );

% posterior mean and variance
postmean = meanc(MHm);
postvarcov = cov(MHm);

% log normal density
ln_joint_post = lnpdfmvn(theta_hat,postmean,postvarcov);

lnML = lnpost_hat - ln_joint_post;

disp('================================================================');
disp('���ö� ���');
disp('----------------------------------------------------------------');
disp(['�ֺ� �쵵 = ', num2str(lnML)]);
disp(['�쵵 +  �����е� = ', num2str(lnpost_hat)]);
disp(['���� �е� = ', num2str(ln_joint_post)]);
disp('=================================================================');

end

