clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

% �ҷ�����
load MHm.txt

n1 = rows(MHm);
prior = 1 + 5*randn(n1, 1);
post = MHm(:, 2);

%% �׸� �׸���
xlabel_latex = '$a_2$'; % x�� �̸�
Plot_Prior_Post(prior, post, xlabel_latex)