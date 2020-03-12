function [bm, sig2m, postmom] = Gibbs_Linear_N( Y,X,b_0,B_0,a_0,d_0,n0,n1, printi )
% Gibbs-Sampling with normal error

if nargin == 8
    printi = 1;
end
precB_0 = invpd(B_0); % Precision matrix of B_0
n = n0 + n1; % total number of iteration

k = cols(X);
bm = zeros(n,k); % b ���� ����
sig2m = zeros(n,1); % sig2 �������

% �ʱⰪ ����
if a_0*d_0 > 0
    sig2 = 0.5*d_0/(0.5*a_0 - 1); % initial value for 1/sig2
else
    sig2 = stdc(Y)^2;
end
for iter=1:n
    
    if printi == 1
        [~, resid] = minresid(iter,100);
        if resid == 0
            clc
            disp(['���� �ݺ������� ',num2str(iter)]);
        end
    end
    
    % Step1 : Full condtional posterior distribution of b, given sig2
    beta = Gen_beta(Y,X,b_0,precB_0,sig2);
    bm(iter,:) = beta'; % save beta
    
    % Step2: Full conditional posterior distribution of sig2, given b
    sig2 = Gen_sig2(Y,X,beta,a_0,d_0);
    sig2m(iter) = sig2;
end

bm = bm(n0+1:n,:); % burn-in period
sig2m = sig2m(n0+1:n,1);

%% �������
MHm = [bm, sig2m];
alpha = 0.025;
maxac = 200; % pacf, acf to 200 orders
postmom = MHout(MHm,alpha,maxac);

disp('================================================================');
disp('   Estimates    S.E.     2.5%      97.5%     Ineff ');
disp('----------------------------------------------------------------');
disp([postmom(:,2) postmom(:,3) postmom(:,4) postmom(:,6) postmom(:,7)]);
disp('=================================================================');

save MHm.txt -ascii MHm;
save postmom.txt -ascii postmom;
%% ���ĺ��� �׸��׸���
npara = cols(MHm); % �Ķ������ ��
m1 = round(sqrt(npara));
m2 = ceil(sqrt(npara));
for i = 1:npara
    subplot(m1, m2, i);
    para = MHm(:, i);
    minp = minc(para); % �ּ�
    maxp = maxc(para); % �ִ�
    intvl = (maxp - minp)/50;
    interval = minp:intvl:maxp;
    hist(para, interval);
    if i < npara
        xlabel(['beta ', num2str(i)])
    elseif i == npara
        xlabel('\sigma^2')
    end
end

end

function [ beta ] = Gen_beta(Y, X, b_0, precB_0, sig2)

k = cols(X);
XX = X'*X;
XY = X'*Y;

B_1 = invpd((1/sig2)*XX + precB_0); % full conditional variance B_1
A = (1/sig2)*XY + precB_0*b_0;
M = B_1*A;

beta = M + chol(B_1)'*randn(k,1); % sampling beta


end

function [ sig2 ] = Gen_sig2( Y, X, beta, a_0, d_0 )

T = rows(X);
a_1 = T + a_0;
e = Y - X*beta;
d_1 = d_0 + e'*e;

sig2 = randig(a_1/2,d_1/2,1,1); % sig2 sampling


end


