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

% 깁스-샘플링
n0 = 1000;   % burn-in
n1 = 10000;  % MCMC size

[bm, sig2m] = Gibbs_Linear_N(Y, X, b_0, B_0, a_0, d_0, n0, n1, 0);

xf = [1, Inflation(end), Oil_price(end)];
yfm = zeros(n1, 1);
for iter = 1:n1
   yfm(iter) =  xf*bm(iter, :)' + sqrt(sig2m(iter))*randn(1,1);
end

save yfm_oil.txt -ascii yfm


%% AR(1)
X = [ones(T, 1), Inflation(1:end-1, 1)];
k = cols(X); % 설명변수의 수

% 사전분포
% prior for sig2
a_0 = 20;  
d_0 = 4; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

% beta에 대한 사전 분포
b_0 = [0.5; 0.5]; % 사전 평균
B_0 = 0.25*eye(k); % B_0 = 사전 분산-공분산

% 깁스-샘플링
n0 = 1000;   % burn-in
n1 = 10000;  % MCMC size

[bm, sig2m] = Gibbs_Linear_N(Y, X, b_0, B_0, a_0, d_0, n0, n1, 0);

xf = [1, Inflation(end)];
yfm = zeros(n1, 1);
for iter = 1:n1
   yfm(iter) =  xf*bm(iter, :)' + sqrt(sig2m(iter))*randn(1,1);
end

save yfm_AR1.txt -ascii yfm

%% 모형 3: AR(2)
Y = Inflation(3:end);
T = rows(Y); % T1 = T-1
X = [ones(T, 1), Inflation(2:end-1), Inflation(1:end-2)];

b_0 = [0.5; 0.5; 0]; % prior mean for beta
B_0 = 0.25*eye(rows(b_0)); % prior variance matrix for beta (no correlation)
a_0 = 20;
d_0 = 4;

[bm, sig2m, postmom] = Gibbs_Linear_N(Y,X,b_0,B_0,a_0,d_0,1000,10000,0);

n1 = rows(bm);
xf = [1, Inflation(end), Inflation(end-1)];
yfm = zeros(n1, 1);
for iter = 1:n1
   yfm(iter) =  xf*bm(iter, :)' + sqrt(sig2m(iter))*randn(1,1);
end
save yfm_AR2.txt -ascii yfm