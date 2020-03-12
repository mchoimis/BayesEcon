clear;
clc;

addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');
%% 자료 불러오기
Data = xlsread('Data_inflation.xls','sheet1','B5:D292'); 

Data = Data(113:end, :);
Inflation = Data(:, 1); % 소비자물가상승률
Oil_price = Data(:, 3)/20; % 유가상승률

Y = Inflation(2:end, 1); % 종속변수, 연 %
T = rows(Y); % Sample size

%% 1. 비제약 모형 추정
X = [ones(T, 1), Inflation(1:end-1, 1), Oil_price(1:end-1, :)];
k = cols(X); % 설명변수의 수

%% 사전분포
% prior for sig2
a_0 = 20;  
d_0 = 4; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

% beta에 대한 사전 분포
b_0 = [0.5; 0.5; 0]; % 사전 평균
B_0 = 0.25*eye(k); % B_0 = 사전 분산-공분산

%% 깁스-샘플링
n0 = 1000;   % burn-in
n1 = 10000;  % MCMC size

[bm, sig2m] = Gibbs_Linear_N(Y, X, b_0, B_0, a_0, d_0, n0, n1, 0);

MHm = [bm, sig2m];

%% 사후모드 찾기
Data = [Y, X];
[theta_hat, lnpost_hat] = Gen_postmod(Data,MHm,b_0,B_0,a_0,d_0);

%% SD density ratio
ind_Res = 3; % beta 중에 제약이 부여된 파마메터의 인덱스
ind_UNRes = [1;2]; % beta 중에서 제약이 부여되지 않은 파라메터의 인덱ㅅ
lnSDr = Linear_SDratio( Data, MHm, b_0, B_0, ind_Res, ind_UNRes);

%% Chib
lnML_Chib_UNRES  = Linear_Chib_ML( Data,MHm,b_0,B_0,a_0,d_0 ); % 모형 1에 대한 로그주변우도 값

%% 조화평균
lnML_HM_UNRES = Linear_HM_ML(MHm, Data);

%% 라플라스 기법
lnML_Lap_UNRES = Linear_Laplace_ML( Data,MHm,b_0,B_0,a_0,d_0 );

%% DIC
postmean = meanc(MHm);
lnL = lnlik(postmean, Data);
DIC_UNRES = -2*lnL +2*cols(MHm);
disp(['비제약식의 DIC = ', num2str(DIC_UNRES)]);

%% BIC
lnL = lnlik(theta_hat, Data);
BIC_UNRES = -2*lnL + cols(MHm)*log(rows(Data));
disp(['비제약식의 BIC = ', num2str(BIC_UNRES)]);

%% 2. 제약 모형 추정
X = [ones(T, 1), Inflation(1:end-1, 1)];
k = cols(X); % 설명변수의 수

%% 사전분포
% prior for sig2
a_0 = 20;  
d_0 = 4; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

% beta에 대한 사전 분포
b_0 = [0.5; 0.5]; % 사전 평균
B_0 = 0.25*eye(k); % B_0 = 사전 분산-공분산

%% 깁스-샘플링
n0 = 500;   % burn-in
n1 = 5000;  % MCMC size

[bm, sig2m] = Gibbs_Linear_N(Y, X, b_0, B_0, a_0, d_0, n0, n1, 0);

MHm = [bm, sig2m];


%% 사후모드 찾기
Data = [Y, X];
[theta_hat,lnpost_hat] = Gen_postmod(Data,MHm,b_0,B_0,a_0,d_0);

%% Chib
lnML_Chib_RES  = Linear_Chib_ML( Data,MHm,b_0,B_0,a_0,d_0 ); % 모형 1에 대한 로그주변우도 값

%% 조화평균
lnML_HM_RES = Linear_HM_ML(MHm, Data);

%% 라플라스 기법
lnML_Lap_RES = Linear_Laplace_ML( Data,MHm,b_0,B_0,a_0,d_0 );

%% DIC
postmean = meanc(MHm);
lnL = lnlik(postmean, Data);
DIC_RES = -2*lnL + 2*cols(MHm);
disp(['제약식의 DIC = ', num2str(DIC_RES)]);

%% BIC
lnL = lnlik(theta_hat, Data);
BIC_RES = -2*lnL + cols(MHm)*log(rows(Data));
disp(['제약식의 BIC = ', num2str(BIC_RES)]);

%% 모형의 사후확률 및 베이즈 팩터
% Chib method
log_BF = lnML_Chib_UNRES - lnML_Chib_RES; % log 베이즈 팩터
PostProb_M1= exp(lnML_Chib_UNRES)/(exp(lnML_Chib_UNRES) + exp(lnML_Chib_RES));

disp('======== Chib method ===============================')
disp(['로그 주변 우도(M1) is   ', num2str(lnML_Chib_UNRES)]);
disp(['로그 주변 우도(M2) is   ', num2str(lnML_Chib_RES)]);
disp(['로그 Bayes factor is  ', num2str(log_BF)]);
disp(['Bayes factor is  ', num2str(exp(log_BF))]);
disp(['Posterior probability of M1 is   ', num2str(PostProb_M1)]);
disp('==================================================')

% 라플라스 method
log_BF = lnML_Lap_UNRES - lnML_Lap_RES; % log 베이즈 팩터
PostProb_M1= exp(lnML_Lap_UNRES)/(exp(lnML_Lap_UNRES) + exp(lnML_Lap_RES));

disp('======== 라플라스 method ===========================')
disp(['로그 주변 우도(M1) is   ', num2str(lnML_Lap_UNRES)]);
disp(['로그 주변 우도(M2) is   ', num2str(lnML_Lap_RES)]);
disp(['로그 Bayes factor is  ', num2str(log_BF)]);
disp(['Bayes factor is  ', num2str(exp(log_BF))]);
disp(['Posterior probability of M1 is   ', num2str(PostProb_M1)]);
disp('==================================================')

% 조화평균 method
log_BF = lnML_HM_UNRES - lnML_HM_RES; % log 베이즈 팩터
PostProb_M1= exp(lnML_Lap_UNRES)/(exp(lnML_Lap_UNRES) + exp(lnML_Lap_RES));

disp('======== 조화 평균 method===============================')
disp(['로그 주변 우도(M1) is   ', num2str(lnML_HM_UNRES)]);
disp(['로그 주변 우도(M2) is   ', num2str(lnML_HM_RES)]);
disp(['로그 Bayes factor is  ', num2str(log_BF)]);
disp(['Bayes factor is  ', num2str(exp(log_BF))]);
disp(['Posterior probability of M1 is   ', num2str(PostProb_M1)]);
disp('==================================================')
