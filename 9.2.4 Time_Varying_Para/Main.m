clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');
 
stream = RandStream('mcg16807','Seed',123);
RandStream.setGlobalStream(stream);

%% �ڷ� �ҷ�����
Data = xlsread('Stock_Watson_data','sheet1','B2:D168');        

% FFR = Data(:,1); % Federal funds rate
% Inflation = Data(:,2); % ���÷��̼�
% UN = Data(:,3); % �Ǿ���

Spec.Data = Data;

%% Options
n0 = 1000;   % burn-in
n1 = 5000;  % MCMC size

%% ��������
% prior for mu�� G
b_ = [0.05;0.8]; 
% b_(1) = C, b_(2) = G
var_ = 0.01*eye(rows(b_));
Spec.b_ = b_;
Spec.var_ = var_;

% prior for Omega
nu = 10;
R0 = 10; 
Spec.R0 = R0;
Spec.nu = nu;

% 100*sig2�� ���� ��������
a0 = 10;  
d0 = 10;  
Spec.a0 = a0;
Spec.d0 = d0;

[MHm, Fm, postmom] = MCMC_TVP(n0, n1, Spec);


