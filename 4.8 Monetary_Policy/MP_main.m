%% ��ȭ��å ���� MH������� ���� (Single block Tailored M-H)
clear;
clc;
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% �ڷ� �ҷ�����
Data = xlsread('Stock_Watson_data','sheet1','B2:D168');        

Data = Data(82:end,:);
T = rows(Data); % ������ ũ��, ���� ����ϴ� ����ũ��� T-1
k = 5; % �����ϴ� ������ ��, theta = (rho c beta1 beta2 sig2)'

FFR = Data(:,1); % Federal funds rate
Inflation = Data(:,2); % ���÷��̼�
UN = Data(:,3); % �Ǿ���

Data = [FFR, Inflation, UN];
Spec.Data = Data;
    
%% ���ø� ��� �����ϱ�
Spec.MH = 1;
% 0 = �齺 ���ø�
% 1 = Tailored Indpendent M-H
% 2 = Tailored Dependent M-H
% 3 = ���Ǻ��� M-H

Spec.nu = 15; % ��Ʃ��Ʈ-t �ĺ����������� ������, Tailored M-H������ ����

%% �Ķ����
ind_beta = 1; % ���������� ��Ÿ������ �Ķ���͵��� �ε���
ind_Normal = [2;3;4]; % ���������� ���Ժ����� �Ķ���͵��� �ε���
ind_IG = 5; % ���������� Inverse-Gamma �Ķ������ �ε���

% structure
Spec.ind_beta = ind_beta;
Spec.ind_Normal = ind_Normal;
Spec.ind_IG = ind_IG;

%% �������� ����
% rho�� ���� �������� (��Ÿ����)
Spec.alpha0 = 5;
Spec.beta0 = 5;

% (c, beta1, beta2)�� ���� �������� (���Ժ���)
Normal_mu = [5; 1; -1]; % c, beta1, beta2�� �������
Normal_V = [1; 1; 1]; % c, beta1, beta2�� �����л�

Spec.Normal_mu = Normal_mu;
Spec.Normal_V = Normal_V;

% sig2�� �������� (������ ����)
a0 = 8;
d0 = 24;
Spec.a0 = a0;
Spec.d0 = d0;

%% 1�ܰ�: ����ȭ
if Spec.MH > 0  % �齺 ���ø��� ���� �� �ʿ����
    theta0 = [0.5;Normal_mu; 0.5*a0/(0.5*d0-1)]; % ����ȭ�� �ʱⰪ, ���� ���
    [theta_hat, fmax, V, Vinv] = SA_Newton(@lnpost, @paramconst, theta0, Spec);
    % theta_hat = ���ĺ����� ���
    % fmax = ���ĺ��� Ŀ���� �ش밪
end

%% 2 �ܰ�: MCMC ���ø�
n0 = 2000; % ���� ũ��
n1 = 20000; % MCMC ũ��
freq = 500; % �� freq �ݺ����ึ�� �߰���� ����

% MCMC �ùķ��̼�
[MHm, accpt] = MCMC(@lnpost, @lnlik, @paramconst, n0, n1, theta_hat, V, freq, Spec);
