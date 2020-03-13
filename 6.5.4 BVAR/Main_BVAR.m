% clear; 
clc;
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3')

p = 4; % 시차의 크기, SVAR(p) 모형
mlag = 24; % 충격반응함수 Horizon의 크기 

%% 자료 불러오기 
Data = xlsread('watson.xls','Sheet1','A1:C167'); 
% 자료순서 = 인플레이션, 실업율, 금리, 1960:Q1 ~ 2001:Q3 
% Data = Data(81:end,:);

%% 평균 제거하기
Y = demeanc(Data); % T by k
k = cols(Y); % 변수의 수 
n0 = 500; % burn-in size
n1 = 2000; % MCMC size beyond burn-in
n = n0 + n1;

%% 사전분포 설정하기
% prior for inv(Omega)
nu = 10;
R0 = invpd(0.2*eye(k))/nu;  % Note that E(inv(Omega)) = d_*v_ 

% prior for Phi
pkk = p*k*k;
b_ = zeros(pkk,1); % beta = vec(Phi);
var_ = 1*eye(pkk);

Spec.b_ = b_;
Spec.var_ = var_;
Spec.p = p;
Spec.nu = nu;
Spec.R0 = R0;
Spec.Y = Y;
Spec.mlag = mlag;

[ImpulseRespm, MHm]= Recursive_VAR(n0, n1, Spec);
   
   
   
   