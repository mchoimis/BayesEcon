clear;
clc;

addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');
%% �ڷ� �ҷ�����
Data = xlsread('Data_inflation.xls','sheet1','B5:D292'); 

Data = Data(113:end, :);
Inflation = Data(:, 1); % �Һ��ڹ�����·�
Oil_price = Data(:, 3)/20; % ������·�

Y = Inflation(2:end, 1); % ���Ӻ���, �� %
T = rows(Y); % Sample size

%%  ���� 1: ������·�
X = [ones(T, 1), Inflation(1:end-1, 1), Oil_price(1:end-1, :)];
k = cols(X); % �������� ��

%% ��������
% prior for sig2
a_0 = 20;  
d_0 = 4; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

% beta�� ���� ���� ����
b_0 = [0.5; 0.5; 0]; % ���� ���
B_0 = 0.25*eye(k); % B_0 = ���� �л�-���л�

%% �齺-���ø�
n0 = 100;   % burn-in
n1 = 2000;  % MCMC size
H = 60;
[~, ~, ~, lnPPL_oil, PPLm_oil] = Gibbs_Linear_N_v2(Y,X,b_0,B_0,a_0,d_0,n0,n1, 0, H);

%% ���� 2: AR(1)
X = [ones(T, 1), Inflation(1:end-1, 1)];
k = cols(X); % �������� ��

%% ��������
% prior for sig2
a_0 = 20;  
d_0 = 4; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

% beta�� ���� ���� ����
b_0 = [0.5; 0.5]; % ���� ���
B_0 = 0.25*eye(k); % B_0 = ���� �л�-���л�

%% �齺-���ø�
[~, ~, ~, lnPPL_AR1, PPLm_AR1] = Gibbs_Linear_N_v2(Y,X,b_0,B_0,a_0,d_0,n0,n1, 0, H);

%% ���� 3: AR(2)
Y = Inflation(3:end);
T = rows(Y); 
X = [ones(T, 1), Inflation(2:end-1), Inflation(1:end-2)];

b_0 = [0.5; 0.5; 0]; % prior mean for beta
B_0 = 0.25*eye(rows(b_0)); % prior variance matrix for beta (no correlation)
a_0 = 20;
d_0 = 4;

[~, ~, ~, lnPPL_AR2, PPLm_AR2] = Gibbs_Linear_N_v2(Y,X,b_0,B_0,a_0,d_0,n0,n1, 0, H);

lnPPL = [lnPPL_oil;lnPPL_AR1 ;lnPPL_AR2];
weight = exp(lnPPL)/sumc(exp(lnPPL));
save weight.txt -ascii weight
