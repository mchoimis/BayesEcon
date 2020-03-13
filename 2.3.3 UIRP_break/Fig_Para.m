clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

% 불러오기
load Beta1m
load Beta2m

%% a1
y1 = Beta1m(:, 1);
y2 = Beta2m(:, 1);

y = [y1, y2];
xlabel_latex = '$a_1$'; % x축 이름
Plot_Prior_Post(y1, y2, xlabel_latex, 'before the break','after the break')

%% a2
y1 = Beta1m(:, 2);
y2 = Beta2m(:, 2);

y = [y1, y2];
xlabel_latex = '$a_2$'; % x축 이름
Plot_Prior_Post(y1, y2, xlabel_latex, 'before the break','after the break')

load Sig2m

%% sigma
Sig2m = sqrt(Sig2m);

%% 그림 그리기
y1 = Sig2m(:, 1);
y2 = Sig2m(:, 2);

xlabel_latex = '$\sigma$'; % x축 이름
Plot_Prior_Post(y1, y2, xlabel_latex, 'before the break','after the break')