clear
clc
addpath('D:\Dropbox\��������_���ǳ�Ʈ\Matlab_code\myLib_v2');

% �ҷ�����
load MHm.txt

% ��������
n1 = rows(MHm);
prior = 1 + 5*randn(n1, 1);

% ���ĺ���
post = MHm(:, 2);

%% �׸� �׸���
xlabel_latex = '$a_2$'; % x�� �̸�
Plot_Prior_Post(prior, post, xlabel_latex)

