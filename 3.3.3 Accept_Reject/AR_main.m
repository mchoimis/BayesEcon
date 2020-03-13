clear;
clc;

addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% 예시: Accept-Reject Method

a = 3;
b = 3;
truemean = a/(a+b); % 이론적인 평균
truevar = (a*b)/((a+b)^2*(a+b+1)); % 이론적인 분산



%% A-R 기법 실행하기
T = 50000; % sample size
c = 1.8750; % must be chosen to maximize the probability of accepting x
% 타겟 밀도 = target_density
% 후보생성밀도 = proposal_density
grnd = @()rand(1); % 후보생성
Xm = ARrnd(@target_density,@proposal_density,grnd,c,T,1);

% 시뮬레이션 결과로 계산한 평균과 분산
A = meanc(Xm); 
B = var(Xm);

%% Histogram
Ym = betarnd(3,3,50000,1); % beta 분포에서 직접적으로 샘플링하기

save Xm.txt -ascii Xm;
save Ym.txt -ascii Ym;

xlabel_latex = 'X'; % x축 이름
Plot_Prior_Post(Xm, Ym, xlabel_latex, 'By A-R method','Directly from beta(3,3)')

%% Result
disp('=====================================================');
disp([' True mean ',' True variance']);
disp('=====================================================');
disp([truemean,         truevar]);
disp('======================================================');
disp([' sample mean', '  sample variance']);
disp('=====================================================');
disp([A B]);
disp('=====================================================');

