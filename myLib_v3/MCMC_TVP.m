function [MHm, Fm, postmom] = MCMC_TVP(n0, n1, Spec)
% MHm = 파라메터의 사후 분포
% Fm = 수준 요인의 사후 분포

Data = Spec.Data;

FFR = Data(:,1); % Federal funds rate
Inflation = Data(:,2); % 인플레이션

Y = FFR(2:end);
Z = [ones(rows(Y), 1), FFR(1:end-1, 1)];

% Factorloading
H = Inflation(1:end-1, 1);
k = cols(H); % factor의 수
Spec.k = k;

T = rows(Y); % N = 만기의 수

n = n0 + n1;

nb1 = 2;   % c and phi
nb2 = 1;   % Omega
nb3 = 1;   % Sigma
nb = [nb1;nb2;nb3];

nmh = sumc(nb); % 파라메터 수

upp = cumsum(nb);
low = [0;upp(1:length(nb)-1)] + 1;

%% 파라메터의 인덱스
indv = 1:nmh;
indv = indv';
ind_C_Phi = indv(low(1):upp(1));
ind_Omega = indv(low(2):upp(2));
ind_Sig = indv(low(3):upp(3));

Spec.ind_C_Phi = ind_C_Phi;
Spec.ind_Omega = ind_Omega;
Spec.ind_Sig = ind_Sig;

% 초기값 설정하기
theta = zeros(nmh,1);
Betam = 0.5*ones(T, 1); % factor의 초기값
theta(ind_C_Phi) = Spec.b_;
theta(ind_Omega) = 0.2;
theta(ind_Sig) = 0.01;

%% 저장할 방
MHm = zeros(n,nmh);
Fm = zeros(n,T);

%% MCMC
for iter = 1:n
    
    %  Step 1: c and phi 샘플링
    theta = Gen_C_Phi(Y, Z, H, Betam, theta, Spec);
    
    %  Step 2: omega 샘플링
    theta = Gen_Omega(Betam, theta, Spec);
    
    %  Step 3: Posterior Conditional Distribution of sigma, given omega and b
    theta = Gen_Sigma(Y, Z, H, Betam, theta, Spec);
    MHm(iter,:) = theta';
    
    %  Step 4 : Sampling Betam
    Betam = Gen_Betam(Y, Z, H, theta, Spec);
    Fm(iter,:) = Betam(:,1)';
       
    % 중간결과보기
    if isequal(floor(iter/100),iter/100) == 1  % 1 if equal
        clc
        prt2(theta,Spec,iter)
    end
    
end



%% burn-in 버리기
MHm = MHm(n0+1:n,:);
Fm = Fm(n0+1:n,:);

%%  결과보기
alpha = 0.025;
maxac = 200;
postmom = MHout(MHm,alpha,maxac);

disp('==================================================');
disp('     index   Mean     S.E.      2.5%      97.5%     Ineff.');
disp([postmom(:,1:4) postmom(:,6) postmom(:,7)]);
disp('==================================================');
save MHm.txt -ascii MHm;
save Fm.txt -ascii Fm;

%% Factor 그리기
q = [0.05, 0.5, 0.95];
qFm = quantile(Fm, q)';

xtick = 1:20:T;
xa = 1:T;
xticklabel = {'60:Q1', '65:Q1', '70:Q1', '75:Q1', '80:Q1', '85:Q1', '90:Q1', '95:Q1', '00:Q1'};
scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/3])
h = plot(xa, qFm(:,1), 'k--',xa, qFm(:,2), 'b-',xa, qFm(:,3), 'k:' );
xlim([0, T+1]);
xlabel('Time');
set(gca,'XTick', xtick)
set(gca,'XTickLabel',xticklabel,'fontsize', 10)
set(h,'Linewidth',2)
legend('2.5%','Median','97.5%')

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Omega 샘플링 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta = Gen_Omega(Betam, theta, Spec)

ind_Omega = Spec.ind_Omega;

nu = Spec.nu;
R0 = Spec.R0;

T = rows(Betam) - 1;

ehat = Betam(2:end) - Betam(1:end-1); % 잔차항
d1 = R0 + 100*(ehat'*ehat);
v1 = nu + T;
theta(ind_Omega) = randig(v1/2,d1/2,1,1)/100;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sigma 샘플링 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta = Gen_Sigma(Y, Z, H, Betam, theta, Spec)

ind_Sig = Spec.ind_Sig;
ind_C_Phi = Spec.ind_C_Phi;

a0 = Spec.a0;
d0 = Spec.d0;

ehat = Y - Z*theta(ind_C_Phi) - H.*Betam;
d1 = d0 + 100*(ehat'*ehat);
v1 = a0 + rows(Y);
theta(ind_Sig) = randig(v1/2,d1/2,1,1)/100;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 중간결과보고 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  prt2(theta,Spec,iter)

Omega = theta(Spec.ind_Omega);
Sigma = theta(Spec.ind_Sig);
C_Phi = theta(Spec.ind_C_Phi);
Vol = diag(Omega);

disp('==================================');
disp( ['현재 반복시행은 ', num2str(iter)]);
disp('----------------------------------');
disp( ['C 와 G =  ', num2str(C_Phi')]);
disp('----------------------------------');
disp( ['Factor 변동성 =  ', num2str(100*Vol')]);
disp( ['Recaled Sigma =  ', num2str(100*Sigma')]);
disp('----------------------------------');


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% mu와 G 샘플링 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta = Gen_C_Phi(Y, Z, H, Betam, theta0, Spec)

b_ = Spec.b_;
var_ = Spec.var_;
ind_Sig = Spec.ind_Sig;
ind_C_Phi = Spec.ind_C_Phi;

sig2inv = theta0(ind_Sig);

Y_star = Y - H.*Betam;
X = Z;

XX = X'*X; % 설명변수, 3차원
XY = X'*Y_star;

precb_ = invpd(var_);
B1inv = precb_ + sig2inv*XX;
B1inv = 0.5*(B1inv + B1inv');
B1 = invpd(B1inv);
B1 = 0.5*(B1 + B1');
beta = B1*(precb_*b_ + sig2inv*XY) + chol(B1)'*randn(rows(b_),1); % beta sampling 하기
theta = theta0;
theta(ind_C_Phi) = beta;

valid = paramconst(theta, Spec); % 안정성 제약 만족여부 확인
if valid == 0
    theta(ind_C_Phi) = theta0(ind_C_Phi);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Factor 샘플링 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Betam = Gen_Betam(Y, Z, H, theta, Spec)

T = rows(Y);
ind_C_Phi = Spec.ind_C_Phi;
ind_Omega = Spec.ind_Omega;
ind_Sig = Spec.ind_Sig;

k = cols(H);

Y_star = Y - Z*theta(ind_C_Phi);

mu = 0;
G = 1;

%% Kalman filtering step
f_ttm = zeros(k,1,T);
P_ttm = zeros(k,k,T);
f_ll = zeros(k,1);
P_ll = 100*eye(k); % 비조건부 분산-공분산 행렬
Omega = theta(ind_Omega);
Q = Omega;
Sigma = theta(ind_Sig);

for t = 1:T
    
    Ht = H(t, :)';
    f_tl = mu + G*f_ll;
    P_tl = G*P_ll*G' + Q;
    var_tl = Ht'*P_tl*Ht + Sigma;
    var_tl = 0.5*(var_tl + var_tl');
    var_tlinv = invpd(var_tl);
    
    e_tl = Y_star(t,:)' - Ht'*f_tl;
    Kalgain = P_tl*Ht*var_tlinv;
    f_tt = f_tl + Kalgain*e_tl;
    P_tt = eye(k) - Kalgain*Ht';
    P_tt = P_tt*P_tl;
    
    f_ttm(:,:,t) = f_tt;
    P_ttm(:,:,t) = P_tt;
    
    f_ll = f_tt;
    P_ll = P_tt;
    
end

%% Backward recursion
Betam = zeros(T,k);  % T by k

P_tt = P_ttm(:,:,T);  % k by k
P_tt = (P_tt + P_tt')/2;
cP_tt = cholmod(P_tt); % k by k

f_tt = f_ttm(:,:,T); % k by 1
ft = f_tt + cP_tt'*randn(k,1);  % k by 1
Betam(T,:) = ft'; % 1 by by k
t = T - 1; %  time index

while t >= 1;
    
    f_tt = f_ttm(:,:,t);  % km3 by 1
    P_tt = P_ttm(:,:,t);  % km3 by km3
    
    GPG_Q = G*P_tt*G' + Q; % k by k
    GPG_Q = (GPG_Q + GPG_Q')/2;
    GPG_Qinv = invpd(GPG_Q); % k by k
    
    e_tl = Betam(t+1,:)' - mu - G*f_tt; % k by 1
    
    PGG = P_tt*G'*GPG_Qinv;  % km3 by k
    f_tt1 = f_tt + PGG*e_tl;  % km3 by 1
    
    PGP = PGG*G*P_tt;  % km3 by km3
    P_tt1 = P_tt - PGP;
    
    P_tt1 = (P_tt1 + P_tt1')/2;
    cP_tt1 = cholmod(P_tt1);
    
    ft = f_tt1 + cP_tt1'*randn(k,1);
    Betam(t,:) = ft'; % 1 by by k
    
    t = t - 1;
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 제약 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [valid] = paramconst(theta, Spec)

validm = ones(30,1);

if minc(isfinite(theta)) == 0;
    validm(30) = 0;
end

if maxc(isnan(theta)) == 1;
    validm(29) = 0;
end

% phi의 절대값이 1 보다 작도록 제약
ind_C_Phi = Spec.ind_C_Phi;
phi = theta(ind_C_Phi(2));
validm(1) = abs(phi) < 1;

valid = minc(validm); % if any element is equal to zero, invalid

end
