clear
clc
addpath('D:\Dropbox\��������_���ǳ�Ʈ\Matlab_code\myLib_v2');

% �ҷ�����
load MHm.txt

% ��������
b_0 = [0.5; 0.5; 0]; % ���� ���
B_0 = diag(0.25*eye(rows(b_0))); % B_0 = ���� �л�-���л�

n1 = rows(MHm);
priorm = zeros(n1, cols(MHm));
for i = 1:rows(b_0)
    priorm(:, i) = b_0(i) + sqrt(B_0(i))*randn(n1, 1);
end

a_0 = 20;  
d_0 = 4;
priorm(:, 4) = randig(a_0/2,d_0/2,n1,1);

%% �׸� �׸���
xlabel_latex = '$c$'; % x�� �̸�
Plot_Prior_Post(priorm(:, 1), MHm(:, 1), xlabel_latex)

%% �׸� �׸���
xlabel_latex = '$\phi$'; % x�� �̸�
Plot_Prior_Post(priorm(:, 2), MHm(:, 2), xlabel_latex)

%% �׸� �׸���
xlabel_latex = '$\rho$'; % x�� �̸�
Plot_Prior_Post(priorm(:, 3), MHm(:, 3), xlabel_latex)

%% �׸� �׸���
xlabel_latex = '$\sigma^2$'; % x�� �̸�
Plot_Prior_Post(priorm(:, 4), MHm(:, 4), xlabel_latex)