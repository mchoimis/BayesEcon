function [bm, Sig2m, postmom] = Gibbs_Linear_t_error(Y,X,b_,var_,v_,d_,nu,n0,n1)

precb_ = invpd(var_);
nu_ = nu;  % lambda에 대한 prior
n = n0 + n1;       

% 저장할 방만들기
k = cols(X); % 설명변수의 수
T = rows(X); % sample size
bm = zeros(n,k);      % To save the generated b
Sig2m = zeros(n,1);   % To save the generated sig2 
Lambdam = zeros(n,T); % To save the generated lambda 

%초기값 설정하기
Lam = ones(T,1);
sig2_inv = 0.5;    % Initial value for 1/sig2 

for iter = 1:n
    
    [~, resid] = minresid(iter,100);
    if resid == 0
        clc
        disp(['현재 반복시행은 ',num2str(iter)]);
    end
%  Step 1 : Posterior Conditional Distribution of b, given sig2 and lambda 
    beta = Gen_beta(X,Y,Lam,b_,precb_,sig2_inv);
    bm(iter,:) = beta'; % beta 저장하기

%  Step 2 : Posterior Conditional Distribution of sig2, given b and lambda
     sig2 = Gen_sig2(Y,X,Lam,beta,v_,d_);
     sig2_inv = 1/sig2;
     Sig2m(iter) = sig2;  % sig2 저장하기
   
%  Step 3 : Posterior Conditional Distribution of lambda, given sig2 and b
     [Lam] = Gen_Lam(Y,X,beta,sig2_inv,nu_);   
     Lambdam(iter,:) = Lam';
     
end

% burn-in 버리기
  bm = bm(n0+1:n,:);
  Sig2m = Sig2m(n0+1:n);
  MHm_out = [bm Sig2m];
  
  %% 결과보기
  alpha = 0.025;
  maxac = 200;
  postmom = MHout(MHm_out,alpha,maxac);
  
disp('==================================================');
disp('     Mean     S.E.      2.5%      97.5%     Ineff.');
disp('--------------------------------------------------');
disp([postmom(:,2) postmom(:,3) postmom(:,4) postmom(:,6) postmom(:,7)]); 
disp('==================================================');
  
MHm = [bm, Sig2m];
save MHm.txt -ascii MHm;

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

function beta = Gen_beta(X,Y,Lam,b_,precb_,sig2_inv)

    Lam = diag(Lam);
    B1inv = sig2_inv*X'*Lam*X + precb_;
    B1inv = 0.5*(B1inv + B1inv');
    B1 = invpd(B1inv);
    A = sig2_inv*X'*Lam*Y + precb_*b_;

    beta = B1*A + chol(B1)'*randn(cols(X),1); % beta sampling 하기

end

function [Lam] = Gen_Lam(Y,X,beta,sig2_inv,nu_)

     T = rows(Y);
     Lam = zeros(T,1);
     ehat = Y - X*beta; % 잔차항
     ehat2 = ehat.*ehat; % 잔차항의 제곱
     nu1 = nu_ + 1;
     for i = 1:T
         nu2 = nu_ + sig2_inv*ehat2(i);
         Lam(i) = randgam(nu1/2,nu2/2,1,1); % 매 시점 sampling하기
     end
end

function [sig2] = Gen_sig2(Y,X,Lam,beta,v_,d_)
     T = rows(X);
     v1 = v_ + T;
     ehat = Y - X*beta; % 잔차항
     ehat1 = sqrt(Lam).*ehat;
     d1 = d_ + ehat'*ehat1;
 
     sig2 = randig(v1/2,d1/2,1,1); % sig2 sampling 하기
end



