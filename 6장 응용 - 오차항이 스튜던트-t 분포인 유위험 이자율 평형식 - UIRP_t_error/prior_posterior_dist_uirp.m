clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

% 불러오기
load MHm.txt

n1 = rows(MHm);
prior = 1 + 5*randn(n1, 1);
post = MHm(:, 2);

%% 그림 그리기
xlabel_latex = '$a_2$'; % x축 이름
Plot_Prior_Post(prior, post, xlabel_latex)