clear;
clc;

addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% ����: Accept-Reject Method

a = 3;
b = 3;
truemean = a/(a+b); % �̷����� ���
truevar = (a*b)/((a+b)^2*(a+b+1)); % �̷����� �л�



%% A-R ��� �����ϱ�
T = 50000; % sample size
c = 1.8750; % must be chosen to maximize the probability of accepting x
% Ÿ�� �е� = target_density
% �ĺ������е� = proposal_density
grnd = @()rand(1); % �ĺ�����
Xm = ARrnd(@target_density,@proposal_density,grnd,c,T,1);

% �ùķ��̼� ����� ����� ��հ� �л�
A = meanc(Xm); 
B = var(Xm);

%% Histogram
Ym = betarnd(3,3,50000,1); % beta �������� ���������� ���ø��ϱ�

save Xm.txt -ascii Xm;
save Ym.txt -ascii Ym;

xlabel_latex = 'X'; % x�� �̸�
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

