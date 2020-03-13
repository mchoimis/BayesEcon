clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');
 % isForecast = 0 ==> no prediction
 % isForecast = 1 ==> out-of-sample forecasting
 % isForecast = 2 ==> Actual forecasting
 
 %% Options
isForecast = 1; 
if isForecast == 1
    H = 1;
else
    H = 0;
end

%% 자료 불러오기
ym = xlsread('KOSPI20141118','Data','B3:B3611');
ym = demeanc(ym)*100; % 평균제거하기

if H > 0;
    yf = ym(end); % 실현된 주가 수익률
else
    yf = 0;
end

ym = ym(1:end-H, 1);


%% Gibbs-Sampling 
% prior for mu and phi
mu_phi_ = [-0.2;0.9];
var_ = 0.1*eye(2);
precb_ = inv(var_);

% sig2에 대한 prior
v_ = 4;
d_ = 20;

n0 = 1000;   % burn-in
n1 = 10000;  % MCMC size

tic
[Volm, Hm, MHm, Yfm, PredLikm] = MCMC_SVM(ym, yf, n0, n1, mu_phi_, precb_, v_, d_, isForecast);
toc
% 참고: MCMC_SVM는 속도가 느리므로 MCMC_SVM를 mex 파일로 변환하여 사용할 것을 권고함




