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

%% 1. ������ ���� ����
X = [ones(T, 1), Inflation(1:end-1, 1), Oil_price(1:end-1, :)];
k = cols(X); % �������� ��

%% ��������
% prior for sig2
a_0 = 20;  
d_0 = 4; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

% beta�� ���� ���� ����
b_0 = [0.5; 0.5; 0]; % ���� ���
B_0 = 0.25*eye(k); % B_0 = ���� �л�-���л�

% �齺-���ø�
n0 = 1000;   % burn-in
n1 = 10000;  % MCMC size

[bm, sig2m] = Gibbs_Linear_N(Y, X, b_0, B_0, a_0, d_0, n0, n1, 0);

xf = [1, Inflation(end), Oil_price(end)];
yfm = zeros(n1, 1);
for iter = 1:n1
   yfm(iter) =  xf*bm(iter, :)' + sqrt(sig2m(iter))*randn(1,1);
end

save yfm_oil.txt -ascii yfm


%% AR(1)
X = [ones(T, 1), Inflation(1:end-1, 1)];
k = cols(X); % �������� ��

% ��������
% prior for sig2
a_0 = 20;  
d_0 = 4; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

% beta�� ���� ���� ����
b_0 = [0.5; 0.5]; % ���� ���
B_0 = 0.25*eye(k); % B_0 = ���� �л�-���л�

% �齺-���ø�
n0 = 1000;   % burn-in
n1 = 10000;  % MCMC size

[bm, sig2m] = Gibbs_Linear_N(Y, X, b_0, B_0, a_0, d_0, n0, n1, 0);

xf = [1, Inflation(end)];
yfm = zeros(n1, 1);
for iter = 1:n1
   yfm(iter) =  xf*bm(iter, :)' + sqrt(sig2m(iter))*randn(1,1);
end

save yfm_AR1.txt -ascii yfm

%% ���� 3: AR(2)
Y = Inflation(3:end);
T = rows(Y); % T1 = T-1
X = [ones(T, 1), Inflation(2:end-1), Inflation(1:end-2)];

b_0 = [0.5; 0.5; 0]; % prior mean for beta
B_0 = 0.25*eye(rows(b_0)); % prior variance matrix for beta (no correlation)
a_0 = 20;
d_0 = 4;

[bm, sig2m, postmom] = Gibbs_Linear_N(Y,X,b_0,B_0,a_0,d_0,1000,10000,0);

n1 = rows(bm);
xf = [1, Inflation(end), Inflation(end-1)];
yfm = zeros(n1, 1);
for iter = 1:n1
   yfm(iter) =  xf*bm(iter, :)' + sqrt(sig2m(iter))*randn(1,1);
end
save yfm_AR2.txt -ascii yfm