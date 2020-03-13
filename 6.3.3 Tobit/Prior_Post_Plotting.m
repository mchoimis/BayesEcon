clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

% �ҷ�����
load MHm.txt

% ��������
b0 = [2000; -500; -500; -500];
B0 = (500^2)*eye(rows(b0));

n1 = rows(MHm);



%% �׸� �׸���
% ���ĺ���
post = MHm(:, 1);
prior = b0(1) + sqrt(B0(1,1))*randn(n1, 1);

xlabel_latex = '$\beta_1$'; % x�� �̸�
Plot_Prior_Post(prior, post, xlabel_latex)

% ���ĺ���
post = MHm(:, 2);
prior = b0(2) + sqrt(B0(2,2))*randn(n1, 1);

xlabel_latex = '$\beta_2$'; % x�� �̸�
Plot_Prior_Post(prior, post, xlabel_latex)

% ���ĺ���
post = MHm(:, 3);
prior = b0(3) + sqrt(B0(3,3))*randn(n1, 1);

xlabel_latex = '$\beta_3$'; % x�� �̸�
Plot_Prior_Post(prior, post, xlabel_latex)

% ���ĺ���
post = MHm(:, 4);
prior = b0(4) + sqrt(B0(4,4))*randn(n1, 1);

xlabel_latex = '$\beta_4$'; % x�� �̸�
Plot_Prior_Post(prior, post, xlabel_latex)
