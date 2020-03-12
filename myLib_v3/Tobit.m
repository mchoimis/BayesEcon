function [betam, sig2m, postmom] = Tobit(Y, X, b_0, B_0, a_0, d_0, n0, n1)

[T, k] = size(X);

precB_0 = invpd(B_0);

beta = b_0; % 초기값
betam = zeros(n0 + n1, k);
sig2m = zeros(n0 + n1, 1);
isY0 = Y == 0; % Y = 0 인지 아닌지 인디케이터
sig2 = 0.5*d_0/(0.5*a_0 - 1); % initial value sig2

for iter = 1:(n0 + n1)
    
    [~, resid] = minresid(iter,100);
    if resid == 0
        clc
        disp(['현재 반복시행은 ', num2str(iter)]);
    end
    
    %% 1 단계: Z 샘플링
    mu = X*beta; % T by 1 벡터
    lowerb = -abs(mu) - 4*sqrt(sig2);
    
    % y가 양수 y = z, y가 0이면 z가 음수가 되도록 절단된 정규 분포에 샘플링
    Z = isY0.*trandn(mu,ones(T, 1),lowerb,0) + (1 - isY0).*Y;
        
    %% 2 단계: beta 샘플링
    beta= Gen_beta(Z, X, b_0, precB_0, sig2);
    betam(iter, :) = beta';
    
    %% 3 단계: beta 샘플링
    sig2 = Gen_sig2(Z, X, beta, a_0, d_0 );
    sig2m(iter) = sig2;
end

%% 결과보기
betam = betam(n0+1:n0+n1,:);
sig2m = sig2m(n0+1:n0+n1,:);
MHm = [betam, sig2m];

save MHm.txt -ascii MHm;

alpha = 0.025;
maxac = 200;
postmom = MHout(MHm,alpha,maxac);
  
disp('==================================================');
disp('     Mean     S.E.      2.5%      97.5%     Ineff.');
disp('--------------------------------------------------');
disp([postmom(:,2) postmom(:,3) postmom(:,4) postmom(:,6) postmom(:,7)]); 
disp('==================================================');

%% 사후분포 그림그리기
npara = cols(MHm); % 파라메터의 수
m1 = round(sqrt(npara));
m2 = ceil(sqrt(npara));
for i = 1:npara
    subplot(m1, m2, i);
    para = MHm(:, i);
    minp = minc(para); % 최소
    maxp = maxc(para); % 최대
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