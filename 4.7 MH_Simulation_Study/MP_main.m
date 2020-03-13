%% ��ȭ��å ���� MH������� ���� (Single block Tailored M-H)
clear;
clc;
addpath('D:\Dropbox\��������_���ǳ�Ʈ\Matlab_code\myLib_v2');

%% �ڷ� �ҷ�����
Data = xlsread('SML_Data_ch4', 'Sheet1', 'B2:E101');

T = rows(Data);
Spec.Data = Data; % �ڷḦ ����(structure)�� �����ϱ�

%% ���ø� ��� �����ϱ�
Spec.MH = 2;
% 0 = �齺 ���ø�
% 1 = Tailored Indpendent M-H
% 2 = Tailored Dependent M-H
% 3 = ���Ǻ��� M-H

Spec.nu = 15; % ��Ʃ��Ʈ-t �ĺ����������� ������, Tailored M-H������ ����


%% �Ķ����
ind_Normal = [1;2;3]; % theta �� ���������� ���Ժ����� �Ķ���͵��� ��ġ
ind_IG = 4; % theta �� ���������� Inverse-Gamma �Ķ������ ��ġ

% structure
Spec.ind_Normal = ind_Normal;
Spec.ind_IG = ind_IG;

%% �������� ����
% beta�� ���� �������� (���Ժ���)
Normal_mu = [0; 0; 0]; % �������
Normal_V = [9; 9; 9]; % �����л�

Spec.Normal_mu = Normal_mu;
Spec.Normal_V = Normal_V;

% sig2�� �������� (������ ����)
a0 = 10;
d0 = 10;
Spec.a0 = a0;
Spec.d0 = d0;

%% 1�ܰ�: ����ȭ
if Spec.MH > 0  % �齺 ���ø��� ���� �� �ʿ����
    theta0 = [Normal_mu; 0.5*a0/(0.5*d0-1)]; % ����ȭ�� �ʱⰪ, ���� ���
    [theta_hat, fmax, V, Vinv] = SA_Newton(@lnpost, @paramconst, theta0, Spec);
    % theta_hat = ���ĺ����� ���
    % fmax = ���ĺ��� Ŀ���� �ش밪
end

%% 2 �ܰ�: MCMC ���ø�
n0 = 2000; % ���� ũ��
n1 = 20000; % MCMC ũ��
freq = 500; % �� freq �ݺ����ึ�� �߰���� ����

% MCMC �ùķ��̼�
if Spec.MH == 0  % �齺 ���ø�
    Y = Data(:, 1);
    X = Data(:, 2:end);
    [bm, sig2m] = Gibbs_Linear_N(Y, X, Normal_mu, diag(Normal_V), a0, d0, n0, n1);
    MHm = [bm, sig2m];
    accpt = 100*ones(cols(MHm), 1);
else  % M-H ���ø�
    [MHm, accpt] = MCMC(@lnpost, @lnlik, @paramconst, n0, n1, theta_hat, V, freq, Spec);
end
save MHm.txt -ascii MHm;



%% Step 3 : ������� ����
alpha= 0.025;
postmom = MHout(MHm,alpha);
Output = [postmom(:,2) postmom(:,3) postmom(:,4)  postmom(:,6) postmom(:,7) accpt postmom(:,8) ];
disp('===============================================================================');
switch Spec.MH
    case 0
        disp('�齺 ���ø�');
    case 1
        disp('Tailored Independent M-H');
    case 2
        disp('Tailored Dependent M-H');
    case 3
        disp('���� ���� M-H');
end
disp('===============================================================================');
disp('    ���     ǥ�ؿ���     2.5%     97.5%   ��ȿ���� ��� acc.rate(%) Geweke-p ��   ');
disp('-------------------------------------------------------------------------------');
disp(Output);
disp('-------------------------------------------------------------------------------');

if Spec.MH > 0
    se = sqrt(diag(V)); % ǥ�ؿ���
disp('===============================================================================');
disp(' ���ö� �ٻ� ���');
disp('-------------------------------------------------------------------------------');
disp('    ���   ǥ�ؿ���  ');
disp('---------------------------------------------------------');
disp([theta_hat se]);
disp('---------------------------------------------------------');
disp(['�쵵 = ', num2str(fmax)]);
disp('---------------------------------------------------------');

end
