clear;
clc;
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% �ڷ� �ҷ�����
Data = xlsread('Data_Changepoint','Sheet1','B6:B197');

Data = 100*(log(Data(13:end, 1)) - log(Data(1:end-12, 1)));

Y = Data(2:end);
X = [ones(rows(Y), 1), Data(1:end-1, 1)];
n0 = 1000;
n1 = 5000;
n = n0 + n1;

%% ��������
% beta�� ��������
beta0 = [0.3; 0.85];
B0 = 0.25*eye(2);

% sig21, sig22�� ��������
alpha0 = 30;
delta0 = 3;

% p11�� ��������
a10 = 200;
b10 = 5;
N1 = [a10; b10];

%% �ʱⰪ ����
T = rows(Y);
S = ones(T, 1);
S(120:T) = 2;

sig21 = 0.5*delta0/(0.5*alpha0 - 1);
sig22 = 0.5*delta0/(0.5*alpha0 - 1);

p11 = a10/(a10 + b10);
p22 = 1;

%% ������ ��
T = rows(Y);
Sm = zeros(n, T); % ���� �ð迭�� ������ ��
Changepointm = zeros(T, 1); % ������ȭ���� ������ ��
beta1m = zeros(n, 2); % c�� phi�� ������ ��
beta2m = zeros(n, 2);
sig2m = zeros(n, 2);
Pm = zeros(n, 1);

%% MCMC ����
for iter = 1:n
    
    if isequal(floor(iter/100),iter/100) == 1  % 1 if equal
        clc
        disp(['���� �ݺ����� = ', num2str(iter)]);
    end
    
    %  Step 1 : beta ���ø�
    [beta1, beta2, Y1, Y2, X1, X2] = Gen_beta(Y, X, S, sig21, sig22, beta0, B0);
    beta1m(iter, :) = beta1';
    beta2m(iter, :) = beta2';
    
    %  Step 2 : sig2 ���ø�
    [sig21, sig22] = Gen_Sigma(Y1, Y2, X1, X2, beta1, beta2, alpha0, delta0);
    sig2m(iter, :) = [sig21, sig22];
    
    %  Step 3 : S ���ø�
    [S, Filtpm] = Gen_S(Y, X, beta1, beta2, sig21, sig22, p11, p22);
    Sm(iter, :) = S';
    
    if iter > n0
        dS = S(2:end) - S(1:end-1); % ���°� 1���� 2�� ���� ���� ã��
        chp = find(dS == 1) + 1; % ������ȭ����
        Changepointm(chp) = Changepointm(chp) + 1;
    end
    
    %  Step 4 : P ���ø�
    p11 = Gen_P(S, N1);
    Pm(iter, :) = p11;
    
end

Changepointm = Changepointm/n1; % ������ȭ������ ����Ȯ��

MHm = [beta1m, beta2m, sig2m, Pm];
MHm = MHm(n0+1:n, :); % ���� ������
alpha = 0.025;
maxac = 200;
postmom = MHout(MHm,alpha,maxac);



%% �׸� �׸���
Sm = Sm(n0+1:n, :); % ���� ������
post_prob2 = meanc(Sm) - 1; % ���� 2�� Ȯ��

xtick = 12:24:T;
xticklabel = {'Jan 01','Jan 03', 'Jan 05','Jan 07','Jan 09','Jan 11','Jan 13','Jan 15'};

figure
plot(Y, 'Linewidth',2.5);
xlim([0, T])
ylim([0, 1.2*maxc(Y)])
set(gca,'XTick',xtick);
set(gca,'XTicklabel',xticklabel);
xlabel('Time');
ylabel('(%)');


xtick = 12:36:T;
xticklabel = {'Jan 01','Jan 04', 'Jan 07','Jan 10','Jan 13'};

subplot(2,1,1)
plot(post_prob2, 'Linewidth',2.5);
xlim([0, T])
ylim([-0.05, 1.05])
set(gca,'XTick',xtick);
set(gca,'XTicklabel',xticklabel);
xlabel('Time');
ylabel('probability');
title('(a) Posterior Prob. of Low Inflation State');

subplot(2,1,2)
plot(Changepointm, 'Linewidth',2.5);
xlim([0, T])
ylim([-0.05, 1.2*maxc(Changepointm)])
set(gca,'XTick',xtick);
set(gca,'XTicklabel',xticklabel);
xlabel('Time');
ylabel('probability');
title('(b) Posterior Prob. of Changepoint');