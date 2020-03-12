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

%%  모형 1: 유가상승률
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
n0 = 100;   % burn-in
n1 = 2000;  % MCMC size
H = 60;
[~, ~, ~, lnPPL_oil, PPLm_oil] = Gibbs_Linear_N_v2(Y,X,b_0,B_0,a_0,d_0,n0,n1, 0, H);

%% 모형 2: AR(1)
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
[~, ~, ~, lnPPL_AR1, PPLm_AR1] = Gibbs_Linear_N_v2(Y,X,b_0,B_0,a_0,d_0,n0,n1, 0, H);

%% 모형 3: AR(2)
Y = Inflation(3:end);
T = rows(Y); 
X = [ones(T, 1), Inflation(2:end-1), Inflation(1:end-2)];

b_0 = [0.5; 0.5; 0]; % prior mean for beta
B_0 = 0.25*eye(rows(b_0)); % prior variance matrix for beta (no correlation)
a_0 = 20;
d_0 = 4;

[~, ~, ~, lnPPL_AR2, PPLm_AR2] = Gibbs_Linear_N_v2(Y,X,b_0,B_0,a_0,d_0,n0,n1, 0, H);

lnPPL = [lnPPL_oil;lnPPL_AR1 ;lnPPL_AR2];
weight = exp(lnPPL)/sumc(exp(lnPPL));
save weight.txt -ascii weight
