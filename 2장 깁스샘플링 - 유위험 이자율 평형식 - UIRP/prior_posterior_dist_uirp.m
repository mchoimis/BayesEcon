clear
clc
addpath('D:\Dropbox\베이지안_강의노트\Matlab_code\myLib_v2');

% 불러오기
load MHm.txt

% 사전분포
n1 = rows(MHm);
prior = 1 + 5*randn(n1, 1);

% 사후분포
post = MHm(:, 2);

%% 그림 그리기
xlabel_latex = '$a_2$'; % x축 이름
Plot_Prior_Post(prior, post, xlabel_latex)

