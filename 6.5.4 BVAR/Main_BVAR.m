% clear; 
clc;
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3')

p = 4; % ������ ũ��, SVAR(p) ����
mlag = 24; % ��ݹ����Լ� Horizon�� ũ�� 

%% �ڷ� �ҷ����� 
Data = xlsread('watson.xls','Sheet1','A1:C167'); 
% �ڷ���� = ���÷��̼�, �Ǿ���, �ݸ�, 1960:Q1 ~ 2001:Q3 
% Data = Data(81:end,:);

%% ��� �����ϱ�
Y = demeanc(Data); % T by k
k = cols(Y); % ������ �� 
n0 = 500; % burn-in size
n1 = 2000; % MCMC size beyond burn-in
n = n0 + n1;

%% �������� �����ϱ�
% prior for inv(Omega)
nu = 10;
R0 = invpd(0.2*eye(k))/nu;  % Note that E(inv(Omega)) = d_*v_ 

% prior for Phi
pkk = p*k*k;
b_ = zeros(pkk,1); % beta = vec(Phi);
var_ = 1*eye(pkk);

Spec.b_ = b_;
Spec.var_ = var_;
Spec.p = p;
Spec.nu = nu;
Spec.R0 = R0;
Spec.Y = Y;
Spec.mlag = mlag;

[ImpulseRespm, MHm]= Recursive_VAR(n0, n1, Spec);
   
   
   
   