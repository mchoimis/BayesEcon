clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% 자료 불러오기
Data = xlsread('UIRP.xls','sheet1','B6:D102'); 

Exchange = Data(:, 1); % 원달러 환율 종가기준, 2004.1~2011.12
Kor_int = Data(1:end-1, 2); % 국내금리
US_int = Data(1:end-1, 3); % 해외금리

% 평가절하율
Depreciation_rate = log(Exchange(2:end)) - log(Exchange(1:end-1));
Y = Depreciation_rate*1200; % 종속변수, 연 %
T = rows(Y); % Sample size

X = Kor_int - US_int; % 설명변수
X = [ones(T, 1), X];
k = cols(X); % 설명변수의 수

%% 사전분포
a_0 = 50;  
d_0 = 1000*a_0; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

% beta에 대한 사전 분포
b_0 = [0; 1]; % 사전 평균
B_0 = 25*eye(k); % B_0 = 사전 분산-공분산

n0 = 1000; % burn-in period
n1 = 10000; % Actual MCMC size

[Beta1m, Beta2m, Sig2m, taum, tau_tsm, postmom] = Gibbs_Linear_w_One_Break(Y,X,b_0,B_0,a_0,d_0,n0,n1);
save tau_tsm tau_tsm
save Beta1m Beta1m
save Beta2m Beta2m
save Sig2m Sig2m







