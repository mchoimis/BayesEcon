function [betam, postmom] = Probit(Y, X, b0, B0, n0, n1)

[T, k] = size(X);

B0inv = invpd(B0);
B1inv = X'*X + B0inv;
B1 = invpd(B1inv);

beta = b0; % �ʱⰪ
betam = zeros(n0 + n1, k);

for iter = 1:(n0 + n1)
    
    [~, resid] = minresid(iter,100);
    if resid == 0
        clc
        disp(['���� �ݺ������� ', num2str(iter)]);
    end
    
    %% 1 �ܰ�: Z ���ø�
    mu = X*beta; % T by 1 ����
    upperb = maxc(abs(mu)) + 5; 
    lowerb = minc(-abs(mu)) - 5;
    
    % y�� 1�̸� ���, y�� 0�̸� ������ �ǵ��� ���ܵ� ���� ������ ���ø�
    Z = Y.*trandn(mu,ones(T,1),0,upperb) + (1 - Y).*trandn(mu,ones(T, 1),lowerb,0);
        
    %% 2 �ܰ�: beta ���ø�
    A = X'*Z + B0inv*b0;
    beta = B1*A + chol(B1)'*randn(k,1);
    betam(iter, :) = beta';
end

%% �������
betam = betam(n0+1:n0+n1,:);
alpha = 0.025;
maxac = 200;
postmom = MHout(betam,alpha,maxac);
  
disp('==================================================');
disp('     Mean     S.E.      2.5%      97.5%     Ineff.');
disp('---------------------------------------------------');
disp([postmom(:,2) postmom(:,3) postmom(:,4) postmom(:,6) postmom(:,7)]); 
disp('==================================================');
save betam.txt -ascii betam;
%% ���ĺ��� �׸��׸���
npara = cols(betam); % �Ķ������ ��
m1 = round(sqrt(npara));
m2 = ceil(sqrt(npara));
for i = 1:npara
    subplot(m1, m2, i);
    para = betam(:, i);
    minp = minc(para); % �ּ�
    maxp = maxc(para); % �ִ�
    intvl = (maxp - minp)/50;
    interval = minp:intvl:maxp;
    hist(para, interval);
    xlabel(['beta ', num2str(i)])
end

end