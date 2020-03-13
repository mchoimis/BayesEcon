clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');
%% �ڷ� �ҷ�����
Data = xlsread('UIRP.xls','sheet1','B6:D102'); 

Exchange = Data(:, 1); % ���޷� ȯ�� ��������, 2004.1~2011.12
Kor_int = Data(1:end-1, 2); % �����ݸ�
US_int = Data(1:end-1, 3); % �ؿܱݸ�

% ��������
Depreciation_rate = log(Exchange(2:end)) - log(Exchange(1:end-1));
Y = Depreciation_rate*1200; % ���Ӻ���, �� %
T = rows(Y); % Sample size

X = Kor_int - US_int; % ������
X = [ones(T, 1), X];
k = cols(X); % �������� ��

%% ��������
% prior for sig2
a_0 = 50;  
d_0 = 1000*a_0; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

% beta�� ���� ���� ����
b_0 = [0; 1]; % ���� ���
B_0 = 25*eye(k); % B_0 = ���� �л�-���л�

%% �齺-���ø�
n0 = 500;   % burn-in
n1 = 5000;  % MCMC size

[bm, sig2m, postmom] = Gibbs_Linear_N(Y, X, b_0, B_0, a_0, d_0, n0, n1);



