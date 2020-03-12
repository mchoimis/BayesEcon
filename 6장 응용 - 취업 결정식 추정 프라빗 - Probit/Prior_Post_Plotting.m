clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

% 불러오기
load betam.txt

% 사전분포
n1 = rows(betam);
prior = randn(n1, 1);


%% 그림 그리기
% 사후분포
post = betam(:, 2);

xlabel_latex = '$\beta_1$'; % x축 이름
Plot_Prior_Post(prior, post, xlabel_latex)

% 사후분포
post = betam(:, 3);

xlabel_latex = '$\beta_2$'; % x축 이름
Plot_Prior_Post(prior, post, xlabel_latex)

% 사후분포
post = betam(:, 4);

xlabel_latex = '$\beta_2$'; % x축 이름
Plot_Prior_Post(prior, post, xlabel_latex)