function [betam, postmom] = Probit(Y, X, b0, B0, n0, n1)

[T, k] = size(X);

B0inv = invpd(B0);
B1inv = X'*X + B0inv;
B1 = invpd(B1inv);

beta = b0; % 초기값
betam = zeros(n0 + n1, k);

for iter = 1:(n0 + n1)
    
    [~, resid] = minresid(iter,100);
    if resid == 0
        clc
        disp(['현재 반복시행은 ', num2str(iter)]);
    end
    
    %% 1 단계: Z 샘플링
    mu = X*beta; % T by 1 벡터
    upperb = maxc(abs(mu)) + 5; 
    lowerb = minc(-abs(mu)) - 5;
    
    % y가 1이면 양수, y가 0이면 음수가 되도록 절단된 정규 분포에 샘플링
    Z = Y.*trandn(mu,ones(T,1),0,upperb) + (1 - Y).*trandn(mu,ones(T, 1),lowerb,0);
        
    %% 2 단계: beta 샘플링
    A = X'*Z + B0inv*b0;
    beta = B1*A + chol(B1)'*randn(k,1);
    betam(iter, :) = beta';
end

%% 결과보기
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
%% 사후분포 그림그리기
npara = cols(betam); % 파라메터의 수
m1 = round(sqrt(npara));
m2 = ceil(sqrt(npara));
for i = 1:npara
    subplot(m1, m2, i);
    para = betam(:, i);
    minp = minc(para); % 최소
    maxp = maxc(para); % 최대
    intvl = (maxp - minp)/50;
    interval = minp:intvl:maxp;
    hist(para, interval);
    xlabel(['beta ', num2str(i)])
end

end