clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

% �ҷ�����
load betam.txt

% ��������
n1 = rows(betam);
prior = randn(n1, 1);


%% �׸� �׸���
% ���ĺ���
post = betam(:, 2);

xlabel_latex = '$\beta_1$'; % x�� �̸�
Plot_Prior_Post(prior, post, xlabel_latex)

% ���ĺ���
post = betam(:, 3);

xlabel_latex = '$\beta_2$'; % x�� �̸�
Plot_Prior_Post(prior, post, xlabel_latex)

% ���ĺ���
post = betam(:, 4);

xlabel_latex = '$\beta_2$'; % x�� �̸�
Plot_Prior_Post(prior, post, xlabel_latex)