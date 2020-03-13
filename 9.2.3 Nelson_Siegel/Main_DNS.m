clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');
 
stream = RandStream('mcg16807','Seed',123);
RandStream.setGlobalStream(stream);

%% �ڷ� �ҷ�����
Ym = xlsread('KOR_YC','Sheet1','B2:G163'); % �� percent

Spec.Ym = Ym;
Spec.lambda = 0.0609; % decay parameter
tau = [3, 6, 12, 24, 36, 60]'; % ����(��)
Spec.tau = tau;

%% Options
k = 3; % number of latent factors
Spec.k = k; % Factor�� ��
isforecast = 1; % �����ϰ� ������ 1, �ƴϸ� 0
Spec.isforecast = isforecast;
n0 = 1000;   % burn-in
n1 = 2000;  % MCMC size

%% ��������
% prior for mu�� G
b_ = [0.05;0.95;-0.02;0.95;0;0.8]; 
% b_(1) = mu(1), b_(2) = G(1,1),
% b_(3) = mu(2), b_(4) = G(2,2),
% b_(5) = mu(3), b_(6) = G(3,3)
var_ = 0.01*eye(rows(b_));
Spec.b_ = b_;
Spec.var_ = var_;

% prior for inv(Omega)
nu = 10;
R0 = invpd(0.15*eye(k))/nu;  % Note that E(inv(Omega)) = d_*v_ 
Spec.R0 = R0;
Spec.nu = nu;

% 10000*sig2�� ���� ��������
a0 = 20;  
d0 = 20;  
Spec.a0 = a0;
Spec.d0 = d0;

[MHm, F1m, F2m, F3m, yfm, postmom] = MCMC_DNS(n0, n1, Spec);


