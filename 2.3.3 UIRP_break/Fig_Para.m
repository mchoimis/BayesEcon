clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

% �ҷ�����
load Beta1m
load Beta2m

%% a1
y1 = Beta1m(:, 1);
y2 = Beta2m(:, 1);

y = [y1, y2];
xlabel_latex = '$a_1$'; % x�� �̸�
Plot_Prior_Post(y1, y2, xlabel_latex, 'before the break','after the break')

%% a2
y1 = Beta1m(:, 2);
y2 = Beta2m(:, 2);

y = [y1, y2];
xlabel_latex = '$a_2$'; % x�� �̸�
Plot_Prior_Post(y1, y2, xlabel_latex, 'before the break','after the break')

load Sig2m

%% sigma
Sig2m = sqrt(Sig2m);

%% �׸� �׸���
y1 = Sig2m(:, 1);
y2 = Sig2m(:, 2);

xlabel_latex = '$\sigma$'; % x�� �̸�
Plot_Prior_Post(y1, y2, xlabel_latex, 'before the break','after the break')