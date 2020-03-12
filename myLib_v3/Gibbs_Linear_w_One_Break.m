function [Beta1m, Beta2m, Sig2m, taum, tau_tsm, postmom] = Gibbs_Linear_w_One_Break(Y,X,b_0, B_0,a_0,d_0,n0,n1)

n = n0 + n1;       
precB_0 = inv(B_0);

% 저장할 방만들기
k = cols(X); % 설명변수의 수

%초기값 설정하기
sig21 = d_0/a_0;    % Initial value for sig21
sig22 = sig21;    % Initial value for sig22

T = rows(Y);
tau = round(0.5*T);
taum = zeros(n,1);
tau_tsm = zeros(T,1);
Beta1m = zeros(n,k);
Beta2m = zeros(n,k);
Sig2m = zeros(n,2);   % To save the generated sig2 
for iter = 1:n

    [~, resid] = minresid(iter,100);
    if resid == 0
        clc
        disp(['현재 반복시행은 ',num2str(iter)]);
    end
    
%  Step 1 : Posterior Conditional Distribution of b, given sig2

beta1 = Gen_beta(Y(1:tau),X(1:tau,:), b_0, precB_0, sig21);
Beta1m(iter, : ) = beta1';
beta2 = Gen_beta(Y(tau+1:end),X(tau+1:end,:), b_0, precB_0, sig22);
Beta2m(iter, : ) = beta2';


%  Step 2 : Posterior Conditional Distribution of sig2, given b
sig21 = Gen_sig2(Y(1:tau), X(1:tau,:), beta1, a_0, d_0 );
sig22 = Gen_sig2(Y(tau+1:end), X(tau+1:end,:), beta2, a_0, d_0 );
 Sig2m(iter,1) = sig21;
 Sig2m(iter,2) = sig22;
 
%  Step 3 : Sampling the breakpoint
beta = [beta1; beta2];
     tau = Gen_tau(Y, X, beta, sig21, sig22);

     taum(iter) = tau; 
     if iter > n0
         tau_tsm(tau) = tau_tsm(tau) +  1;
     end
end

% burn-in 버리기
  Beta1m = Beta1m(n0+1:n,:);
  Beta2m = Beta2m(n0+1:n,:);
  Sig2m = Sig2m(n0+1:n,:);
  tau_tsm = tau_tsm/n1;
  
  MHm_out = [Beta1m, Beta2m, Sig2m];
  
  taum = taum(n0+1:n);
  % 결과보기
  alpha = 0.025;
  maxac = 200;
  postmom = MHout(MHm_out,alpha,maxac);
  
disp('==================================================');
disp('     Mean     S.E.      2.5%      97.5%     Ineff.');
disp('--------------------------------------------------');
disp([postmom(:,2) postmom(:,3) postmom(:,4) postmom(:,6) postmom(:,7)]); 
disp('--------------------------------------------------');
  
end

function [beta] = Gen_beta( Y,X,b_0,precB_0,sig2)

k = cols(X);
XX = X'*X;
XY = X'*Y;
sig2inv = 1/sig2;
B_1 = invpd(sig2inv*XX + precB_0); % full conditional variance B_1
A = sig2inv*XY + precB_0*b_0;
M = B_1*A; 

beta = M + chol(B_1)'*randn(k,1); % sampling beta


end

function [ sig2 ] = Gen_sig2( Y,X,beta,a_0,d_0 )

T = rows(X);
a_1 = T + a_0;
e = Y - X*beta;
d_1 = d_0 + e'*e;

sig2 = randig(a_1/2,d_1/2,1,1); % sig2 sampling


end

function [tau] = Gen_tau(Y,X,beta,sig21,sig22)

T = rows(X);
k = cols(X);
likm = zeros(T,1);
a0 = round(0.2*T);
b0 = round(0.8*T);

for t = a0:b0
    
    D = ones(T,1);
    D(1:t-1) = zeros(t-1,1);
    sig2 = sig21*(1-D) + sig22*D; 
    D = kron(ones(1,k),D);
    X1 = X.*(1 - D);
    X2 = X.*D;
    X_iter = [X1 X2];
    ehat = Y - X_iter*beta;
    lik = lnpdfn(ehat,zeros(T,1),sig2);
    likm(t) = exp(sumc(lik));
    
end

tau_prb = likm/(sumc(likm));
tau = discret1(tau_prb,1);

end