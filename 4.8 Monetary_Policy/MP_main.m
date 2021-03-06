%% 통화정책 모형 MH기법으로 추정 (Single block Tailored M-H)
clear;
clc;
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% 자료 불러오기
Data = xlsread('Stock_Watson_data','sheet1','B2:D168');        

Data = Data(82:end,:);
T = rows(Data); % 샘플의 크기, 실제 사용하는 샘플크기는 T-1
k = 5; % 추정하는 변수의 수, theta = (rho c beta1 beta2 sig2)'

FFR = Data(:,1); % Federal funds rate
Inflation = Data(:,2); % 인플레이션
UN = Data(:,3); % 실업률

Data = [FFR, Inflation, UN];
Spec.Data = Data;
    
%% 샘플링 방법 선택하기
Spec.MH = 1;
% 0 = 깁스 샘플링
% 1 = Tailored Indpendent M-H
% 2 = Tailored Dependent M-H
% 3 = 임의보행 M-H

Spec.nu = 15; % 스튜던트-t 후보생성분포의 자유도, Tailored M-H에서만 사용됨

%% 파라메터
ind_beta = 1; % 사전분포가 베타분포인 파라메터들의 인덱스
ind_Normal = [2;3;4]; % 사전분포가 정규분포인 파라메터들의 인덱스
ind_IG = 5; % 사전분포가 Inverse-Gamma 파라메터의 인덱스

% structure
Spec.ind_beta = ind_beta;
Spec.ind_Normal = ind_Normal;
Spec.ind_IG = ind_IG;

%% 사전분포 설정
% rho에 대한 사전분포 (베타분포)
Spec.alpha0 = 5;
Spec.beta0 = 5;

% (c, beta1, beta2)에 대한 사전분포 (정규분포)
Normal_mu = [5; 1; -1]; % c, beta1, beta2의 사전평균
Normal_V = [1; 1; 1]; % c, beta1, beta2의 사전분산

Spec.Normal_mu = Normal_mu;
Spec.Normal_V = Normal_V;

% sig2의 사전분포 (역감마 분포)
a0 = 8;
d0 = 24;
Spec.a0 = a0;
Spec.d0 = d0;

%% 1단계: 최적화
if Spec.MH > 0  % 깁스 샘플링할 때는 할 필요없음
    theta0 = [0.5;Normal_mu; 0.5*a0/(0.5*d0-1)]; % 최적화의 초기값, 사전 평균
    [theta_hat, fmax, V, Vinv] = SA_Newton(@lnpost, @paramconst, theta0, Spec);
    % theta_hat = 사후분포의 모드
    % fmax = 사후분포 커넬의 극대값
end

%% 2 단계: MCMC 샘플링
n0 = 2000; % 번인 크기
n1 = 20000; % MCMC 크기
freq = 500; % 매 freq 반복시행마다 중간결과 보기

% MCMC 시뮬레이션
[MHm, accpt] = MCMC(@lnpost, @lnlik, @paramconst, n0, n1, theta_hat, V, freq, Spec);

