clear;
clc;

addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');
%% �ڷ� �ҷ�����
Data = xlsread('Data_inflation.xls','sheet1','B5:D292'); 

Data = Data(113:end, :);
Inflation = Data(:, 1); % �Һ��ڹ�����·�
Oil_price = Data(:, 3)/20; % ������·�

Y = Inflation(2:end, 1); % ���Ӻ���, �� %
T = rows(Y); % Sample size

%% 1. ������ ���� ����
X = [ones(T, 1), Inflation(1:end-1, 1), Oil_price(1:end-1, :)];
k = cols(X); % �������� ��

%% ��������
% prior for sig2
a_0 = 20;  
d_0 = 4; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

% beta�� ���� ���� ����
b_0 = [0.5; 0.5; 0]; % ���� ���
B_0 = 0.25*eye(k); % B_0 = ���� �л�-���л�

%% �齺-���ø�
n0 = 1000;   % burn-in
n1 = 10000;  % MCMC size

[bm, sig2m] = Gibbs_Linear_N(Y, X, b_0, B_0, a_0, d_0, n0, n1, 0);

MHm = [bm, sig2m];

%% ���ĸ�� ã��
Data = [Y, X];
[theta_hat, lnpost_hat] = Gen_postmod(Data,MHm,b_0,B_0,a_0,d_0);

%% SD density ratio
ind_Res = 3; % beta �߿� ������ �ο��� �ĸ������� �ε���
ind_UNRes = [1;2]; % beta �߿��� ������ �ο����� ���� �Ķ������ �ε���
lnSDr = Linear_SDratio( Data, MHm, b_0, B_0, ind_Res, ind_UNRes);

%% Chib
lnML_Chib_UNRES  = Linear_Chib_ML( Data,MHm,b_0,B_0,a_0,d_0 ); % ���� 1�� ���� �α��ֺ��쵵 ��

%% ��ȭ���
lnML_HM_UNRES = Linear_HM_ML(MHm, Data);

%% ���ö� ���
lnML_Lap_UNRES = Linear_Laplace_ML( Data,MHm,b_0,B_0,a_0,d_0 );

%% DIC
postmean = meanc(MHm);
lnL = lnlik(postmean, Data);
DIC_UNRES = -2*lnL +2*cols(MHm);
disp(['��������� DIC = ', num2str(DIC_UNRES)]);

%% BIC
lnL = lnlik(theta_hat, Data);
BIC_UNRES = -2*lnL + cols(MHm)*log(rows(Data));
disp(['��������� BIC = ', num2str(BIC_UNRES)]);

%% 2. ���� ���� ����
X = [ones(T, 1), Inflation(1:end-1, 1)];
k = cols(X); % �������� ��

%% ��������
% prior for sig2
a_0 = 20;  
d_0 = 4; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

% beta�� ���� ���� ����
b_0 = [0.5; 0.5]; % ���� ���
B_0 = 0.25*eye(k); % B_0 = ���� �л�-���л�

%% �齺-���ø�
n0 = 500;   % burn-in
n1 = 5000;  % MCMC size

[bm, sig2m] = Gibbs_Linear_N(Y, X, b_0, B_0, a_0, d_0, n0, n1, 0);

MHm = [bm, sig2m];


%% ���ĸ�� ã��
Data = [Y, X];
[theta_hat,lnpost_hat] = Gen_postmod(Data,MHm,b_0,B_0,a_0,d_0);

%% Chib
lnML_Chib_RES  = Linear_Chib_ML( Data,MHm,b_0,B_0,a_0,d_0 ); % ���� 1�� ���� �α��ֺ��쵵 ��

%% ��ȭ���
lnML_HM_RES = Linear_HM_ML(MHm, Data);

%% ���ö� ���
lnML_Lap_RES = Linear_Laplace_ML( Data,MHm,b_0,B_0,a_0,d_0 );

%% DIC
postmean = meanc(MHm);
lnL = lnlik(postmean, Data);
DIC_RES = -2*lnL + 2*cols(MHm);
disp(['������� DIC = ', num2str(DIC_RES)]);

%% BIC
lnL = lnlik(theta_hat, Data);
BIC_RES = -2*lnL + cols(MHm)*log(rows(Data));
disp(['������� BIC = ', num2str(BIC_RES)]);

%% ������ ����Ȯ�� �� ������ ����
% Chib method
log_BF = lnML_Chib_UNRES - lnML_Chib_RES; % log ������ ����
PostProb_M1= exp(lnML_Chib_UNRES)/(exp(lnML_Chib_UNRES) + exp(lnML_Chib_RES));

disp('======== Chib method ===============================')
disp(['�α� �ֺ� �쵵(M1) is   ', num2str(lnML_Chib_UNRES)]);
disp(['�α� �ֺ� �쵵(M2) is   ', num2str(lnML_Chib_RES)]);
disp(['�α� Bayes factor is  ', num2str(log_BF)]);
disp(['Bayes factor is  ', num2str(exp(log_BF))]);
disp(['Posterior probability of M1 is   ', num2str(PostProb_M1)]);
disp('==================================================')

% ���ö� method
log_BF = lnML_Lap_UNRES - lnML_Lap_RES; % log ������ ����
PostProb_M1= exp(lnML_Lap_UNRES)/(exp(lnML_Lap_UNRES) + exp(lnML_Lap_RES));

disp('======== ���ö� method ===========================')
disp(['�α� �ֺ� �쵵(M1) is   ', num2str(lnML_Lap_UNRES)]);
disp(['�α� �ֺ� �쵵(M2) is   ', num2str(lnML_Lap_RES)]);
disp(['�α� Bayes factor is  ', num2str(log_BF)]);
disp(['Bayes factor is  ', num2str(exp(log_BF))]);
disp(['Posterior probability of M1 is   ', num2str(PostProb_M1)]);
disp('==================================================')

% ��ȭ��� method
log_BF = lnML_HM_UNRES - lnML_HM_RES; % log ������ ����
PostProb_M1= exp(lnML_Lap_UNRES)/(exp(lnML_Lap_UNRES) + exp(lnML_Lap_RES));

disp('======== ��ȭ ��� method===============================')
disp(['�α� �ֺ� �쵵(M1) is   ', num2str(lnML_HM_UNRES)]);
disp(['�α� �ֺ� �쵵(M2) is   ', num2str(lnML_HM_RES)]);
disp(['�α� Bayes factor is  ', num2str(log_BF)]);
disp(['Bayes factor is  ', num2str(exp(log_BF))]);
disp(['Posterior probability of M1 is   ', num2str(PostProb_M1)]);
disp('==================================================')
