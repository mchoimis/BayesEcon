function [ lnML, ln_joint_post ] = Linear_Laplace_ML( Data,MHm,b_0,B_0,a_0,d_0 )
% log marginal likelihood for linear regression model
% 라플라스 기법
% lnML = lnpost - ln_joint_post
%% 사후모드 계산하기
[theta_hat,lnpost_hat] = Gen_postmod(Data, MHm, b_0,B_0,a_0,d_0 );

% posterior mean and variance
postmean = meanc(MHm);
postvarcov = cov(MHm);

% log normal density
ln_joint_post = lnpdfmvn(theta_hat,postmean,postvarcov);

lnML = lnpost_hat - ln_joint_post;

disp('================================================================');
disp('라플라스 기법');
disp('----------------------------------------------------------------');
disp(['주변 우도 = ', num2str(lnML)]);
disp(['우도 +  사전밀도 = ', num2str(lnpost_hat)]);
disp(['사후 밀도 = ', num2str(ln_joint_post)]);
disp('=================================================================');

end

