function [Tau_hat, Eta_hat, postmom] = MCMC_UC(Spec)


ym = Spec.Ym;
n0 = Spec.n0;
n1 = Spec.n1;

T = rows(ym); % N = 만기의 수

n = n0 + n1;

nb1 = 1;   % mu and G
nb2 = 1;   % Sig2_eps
nb3 = 1;   % Sig2_u
nb = [nb1;nb2;nb3];

nmh = sumc(nb); % 파라메터 수

upp = cumsum(nb);
low = [0;upp(1:length(nb)-1)] + 1;

%% 파라메터의 인덱스
indv = 1:nmh;
indv = indv';
ind_phi = indv(low(1):upp(1));
ind_Sig2_eps = indv(low(2):upp(2));
ind_Sig2_u = indv(low(3):upp(3));

Spec.ind_phi = ind_phi;
Spec.ind_Sig2_eps = ind_Sig2_eps;
Spec.ind_Sig2_u = ind_Sig2_u;

% Factorloading

% 초기값 설정하기
theta = zeros(nmh,1);
theta(ind_phi) = Spec.b_;
theta(ind_Sig2_eps) = Spec.d0_eps/Spec.a0_eps;
theta(ind_Sig2_u) = Spec.d0_u/Spec.a0_u;

%% 저장할 방
MHm = zeros(n,nmh);
Taum = zeros(n, T);
Etam = zeros(n, T);

%% MCMC
for iter = 1:n
    
    Fm = Gen_Fm(theta, Spec);
    theta = Gen_mu_G(Fm, theta, Spec);      
    theta = Gen_Sig2_u(Fm, theta, Spec);
    theta = Gen_Sig2_eps(Fm, theta, Spec);
        
    MHm(iter,:) = theta';
    
    %  Step 4 : Sampling Fm
    
    Taum(iter, :) = Fm(:,1)';
    Etam(iter, :) = Fm(:,2)';
    
    
    % 중간결과보기
    if isequal(floor(iter/100),iter/100) == 1  % 1 if equal
        clc
        prt2(theta,Spec, iter)
    end
    
end



% %% burn-in 버리기

Taum = Taum(n0+1:n,:);
Etam = Etam(n0+1:n,:);

Tau_hat = meanc(Taum);
Eta_hat = meanc(Etam);
%%  결과보기
MHm = MHm(n0+1:n,:);
alpha = 0.025;
maxac = 200;
postmom = MHout(MHm,alpha,maxac);

disp('==================================================');
disp('     Parameter   추정치     표준편차');
disp(['phi =  ', num2str(postmom(Spec.ind_phi,2:3))]);
disp(['추세 변동성 =  ', num2str(postmom(Spec.ind_Sig2_eps,2:3))]);
disp(['Eta의 변동성 =  ', num2str(postmom(Spec.ind_Sig2_u,2:3))]);
disp('==================================================');


% 
%% Factor 그리기
xtick = 13:36:T;
xa = 1:T;
subplot(2,1,1)
h = plot(xa, ym, 'k-', xa, Tau_hat, 'r-' );
xlim([0, T+1]);
xlabel('Time');
set(gca,'XTick', xtick)
set(h,'Linewidth',1.5)
legend('inflation','Trend')
title('(a) Trend');

subplot(2,1,2)
h = plot(xa, Eta_hat, 'b-', xa, zeros(T, 1), 'k:' );
xlim([0, T+1]);
xlabel('Time');
set(gca,'XTick', xtick)
set(h,'Linewidth',1.5)
legend('Cycles','zeroline')
title('(b) Cycles');



% 부채수준 저장
filename = 'UC_inflation.xlsx';

A = {'Time'};
sheet = 'UC';
xlRange = 'A1';
xlswrite(filename, A, sheet, xlRange)

A = xa';
sheet = 'UC';
xlRange = 'A2';
xlswrite(filename, A, sheet, xlRange)

A = {'Trend'};
sheet = 'UC';
xlRange = 'B1';
xlswrite(filename, A, sheet, xlRange)

A = Tau_hat;
sheet = 'UC';
xlRange = 'B2';
xlswrite(filename, A, sheet, xlRange)

A = {'Cycles'};
sheet = 'UC';
xlRange = 'C1';
xlswrite(filename, A, sheet, xlRange)

A = Eta_hat;
sheet = 'UC';
xlRange = 'C2';
xlswrite(filename, A, sheet, xlRange)

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sigma 샘플링 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta = Gen_Sig2_u(Fm,theta,Spec)
Eta = Fm(:, 2);
phi = theta(Spec.ind_phi);
ind_Sig2_u = Spec.ind_Sig2_u;
a0 = Spec.a0_u;
d0 = Spec.d0_u;

Y = Eta(2:end);
X = Eta(1:end-1);
T = rows(Y);

residm = Y - phi*X; % 잔차항

v1 = a0 + T;
d1 = d0 +residm'*residm;
theta(ind_Sig2_u) = randig(v1/2,d1/2,1,1);


end

function theta = Gen_Sig2_eps(Fm,theta,Spec)
Tau = Fm(:, 1);
ind_Sig2_eps = Spec.ind_Sig2_eps;
a0 = Spec.a0_eps;
d0 = Spec.d0_eps;

Y = Tau(2:end);
X = Tau(1:end-1);
T = rows(Y);

residm = Y - X; % 잔차항

v1 = a0 + T;
d1 = d0 +residm'*residm;
theta(ind_Sig2_eps) = randig(v1/2,d1/2,1,1);


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 중간결과보고 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  prt2(theta,Spec, iter)


disp('==================================');
disp( [' current iteration is ', num2str(iter)]);
disp('----------------------------------');
disp( ['phi =  ', num2str(theta(Spec.ind_phi))]);
disp( ['추세 변동성 =  ', num2str(theta(Spec.ind_Sig2_eps))]);
disp( ['Eta의 변동성 =  ', num2str(theta(Spec.ind_Sig2_u))]);
disp('----------------------------------');


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% mu와 G 샘플링 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [theta, phi] = Gen_mu_G(Fm, theta, Spec)

b_ = Spec.b_;
var_ = Spec.var_;
ind_phi = Spec.ind_phi;

Etam = Fm(:, 2);
X = Etam(1:end-1);
Y = Etam(2:end);

sig2_u = theta(Spec.ind_Sig2_u);
XX = X'*X;
XY = X'*Y;

precb_ = 1/var_;
Bn_inv = precb_ + XX/sig2_u;
Bn_inv = 0.5*(Bn_inv + Bn_inv');
varb1 = 1/Bn_inv;
b1 = varb1*(precb_*b_ + XY/sig2_u); % full conditional mean
Chol_varb1 = sqrt(varb1);
phi = b1 + Chol_varb1*randn(1, 1); % beta sampling 하기
theta1 = theta;
theta1(ind_phi) = phi;

if abs(phi) < 0.95
    theta = theta1;
else
    phi = theta(ind_phi);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Factor 샘플링 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Fm = Gen_Fm(theta, Spec)

ym = Spec.Ym;
T = rows(ym);
ind_phi = Spec.ind_phi;
G = diag([1; theta(ind_phi)]);
k = 2;
Gamma = ones(1, 2);

%%%%% Kalman filtering step
f_ttm = zeros(k, 1, T);
P_ttm = zeros(k, k ,T);
f_ll = [ym(1); 0];
P_ll = diag([0; 1]); % 비조건부 분산-공분산 행렬
Q = diag([theta(Spec.ind_Sig2_eps); theta(Spec.ind_Sig2_u)]);
Sigma = 0;

for t = 1:T
    
    f_tl = G*f_ll;
    P_tl = G*P_ll*G' + Q;
    var_tl = Gamma*P_tl*Gamma' +  Sigma;
    var_tl = 0.5*(var_tl + var_tl');
    var_tlinv = invpd(var_tl);
    
    e_tl = ym(t,:)' - Gamma*f_tl;
    Kalgain = P_tl*Gamma'*var_tlinv;
    f_tt = f_tl + Kalgain*e_tl;
    P_tt = eye(k) - Kalgain*Gamma;
    P_tt = P_tt*P_tl;
    
    f_ttm(:,:,t) = f_tt;
    P_ttm(:,:,t) = P_tt;
    
    f_ll = f_tt;
    P_ll = P_tt;
    
end

%%% Backward recursion
Fm = zeros(T,k);  % T by k

P_tt = P_ttm(:,:,T);  % k by k
P_tt = (P_tt + P_tt')/2;
cP_tt = cholmod(P_tt); % k by k

f_tt = f_ttm(:,:,T); % k by 1
ft = f_tt + cP_tt'*randn(k,1);  % k by 1
Fm(T,:) = ft'; % 1 by by k
t = T - 1; %  time index

while t >= 1;
    
    f_tt = f_ttm(:,:,t);  % km3 by 1
    P_tt = P_ttm(:,:,t);  % km3 by km3
    
    GPG_Q = G*P_tt*G' + Q; % k by k
    GPG_Q = (GPG_Q + GPG_Q')/2;
    GPG_Qinv = invpd(GPG_Q); % k by k
    
    e_tl = Fm(t+1,:)' - G*f_tt; % k by 1
    
    PGG = P_tt*G'*GPG_Qinv;  % km3 by k
    f_tt1 = f_tt + PGG*e_tl;  % km3 by 1
    
    PGP = PGG*G*P_tt;  % km3 by km3
    P_tt1 = P_tt - PGP;
    
    P_tt1 = (P_tt1 + P_tt1')/2;
    cP_tt1 = cholmod(P_tt1);
    
    ft = f_tt1 + cP_tt1'*randn(k,1);
    Fm(t,:) = ft'; % 1 by by k
    
    t = t - 1;
end

end


