clear;
clc;

addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% Importance Sampling Example
% X�� ǥ�����Ժ��� f(x) = ǥ�����Ժ����� pdf
% �����Ͻ� �Լ� = �������� 5�� ��Ʃ��Ʈ t ������ pdf
% g(x) = 1/(1 + x^2)
% �����Ͻ� ���ø����� E(g(x)) �ٻ��ϱ�.

%% 1. ���Ժ������� ���������� ���ø��ϱ�
N = 10000; % �ùķ��̼� ũ��

Xm = randn(N,1);
Ym = zeros(N,1);
for i = 1:N
    
    Ym(i) = 1/(1 + Xm(i)^2);
    
end

mY = meanc(Ym);

%% 2. ���������� E(g(x)) ���а���ϱ�
fg = @(x) 1./(1+x.^2).*(1./sqrt(2.*pi).*exp(-x.^2./2));
integralval = integral(fg,-100,100);

%% 3. Importance sampling���� E(g(x)) ����ϱ�
tm = trnd(5,N,1); % importance �Լ����� ���ø�

% tpdf ���
hm = tpdf(tm,5); % h(x) ���

% ǥ�����Ժ��� pdf ���
fm = normpdf(tm,0,1); % f(x) ���

fhm = fm./hm;

% transformation
tranm = zeros(N,1);
for i = 1:N
    
    tranm(i) = 1/(1 + tm(i)^2);
    
end

% ���
A = tranm.*fhm; % g(x)*(f(x)/h(x)) ���
approx = meanc(A);

disp(['�ؼ��� ��� = ', num2str(integralval)]);
disp(['Importance ���ø� ��� = ', num2str(approx)]);
disp(['���Ժ������� ���������� ���ø��� ��� = ', num2str(mY)]);
