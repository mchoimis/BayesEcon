function [ MHm, accpt, postmom] = MCMC(lnpost,lnlik, paramconst, n0, n1, theta_hat, V, freq, Spec )
% MCMC 시뮬레이션

if Spec.MH < 1
   error(' Spec.MH >= 1 이어야 함 ');
end
n = n0 + n1;
nMH = rows(theta_hat); % MH 파라메터의 수
MHm = zeros(n,nMH);
counter = zeros(nMH,1);

theta0 = theta_hat; % initial value
V0 = V;

for iter = 1:n
%% 프로포절
    % theta0 = 이전 반복시행의 theta
    % theta_bar = 후보생성분포의 평균
    % theta_hat = 사후분포의 최빈값
    % theta1 = 프로포절 (proposal)
    [theta1, theta_bar, V] = Proposal_step(lnpost, paramconst, theta_hat, theta0, V0, Spec);
    
    %% MH step
    [theta0, accept, lnpost0] = MH_step(lnpost, paramconst, theta_bar, theta0, theta1, V, Spec );
    lnlik0 = lnlik(theta0,Spec);
    MHm(iter,:) = theta0'; % 저장
    
    % counting acceptance for each parameter
    counter = counter + accept;
    
%% 중간 결과보고    
     prt2(theta0,lnpost0,lnlik0,counter,iter, freq);
    
    
end

MHm = MHm(n0+1:n,:); % 번인
accpt = 100*counter/n;
save MHm.txt -ascii MHm;
%% Step 3 : 추정결과 보기
alpha= 0.025;
postmom = MHout(MHm,alpha);
Output = [postmom(:,2) postmom(:,3) postmom(:,4)  postmom(:,6) postmom(:,7) accpt postmom(:,8) ];
disp('===============================================================================');
switch Spec.MH
    case 0
        disp('깁스 샘플링');
    case 1
        disp('Tailored Independent M-H');
    case 2
        disp('Tailored Dependent M-H');
    case 3
        disp('임의 보행 M-H');
end
disp('===============================================================================');
disp('    평균     표준오차     2.5%     97.5%   비효율성 계수 acc.rate(%) Geweke-p 값   ');
disp('-------------------------------------------------------------------------------');
disp(Output);
disp('-------------------------------------------------------------------------------');

if Spec.MH > 0
    se = sqrt(diag(V0)); % 표준오차
disp('===============================================================================');
disp(' 라플라스 근사 결과');
disp('-------------------------------------------------------------------------------');
disp('    평균   표준오차  ');
disp('---------------------------------------------------------');
disp([theta_hat se]);
disp('---------------------------------------------------------');
fmax = lnlik(theta_hat,Spec);
disp(['우도 = ', num2str(fmax)]);
disp('---------------------------------------------------------');

end

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
    xlabel(['para ', num2str(i)])
end

end

%% 후보생성분포 샘플링
% theta0 = 이전 반복시행의 theta
% theta_bar = 후보생성분포의 평균
% theta_hat = 사후분포의 최빈값
% theta1 = 프로포절 (proposal)
function [theta1, theta_bar, V] = Proposal_step(lnpost, paramconst, theta_hat, theta0, V, Spec)

if Spec.MH == 1 % if tailored Independent M-H
    nu = Spec.nu; % t-분포의 자유도
    theta_bar = theta_hat;
    theta1 = randmvt(nu, theta_bar, V); % proposal
    
elseif Spec.MH == 2 % if tailored Dependent M-H
    nu = Spec.nu; % t-분포의 자유도
    V0 = V;
    lnpost0 = lnpost(theta0, Spec);
    indbj = 1:rows(theta0);
    indbj = indbj';
    g = - Gradpnew1(lnpost, theta0, indbj, Spec); % 4 by 1
    H = - FHESSnew1(lnpost, theta0, indbj, Spec); % 4 by 4
    H = real(H);
    H = 0.5*(H + H');
    Hinv = invpd(H);
    db = Hinv*g'/2;
    theta_bar = theta0 + db;
    
    valid = paramconst(theta_bar, Spec);  % 제약을 만족하면 valid = 1, 아니면 valid = 0
    islnpost = lnpost(theta_bar, Spec) - lnpost0 >= 0; 
    isOK = valid*islnpost;
    SF = 0.5; % Stepsize
    while isOK < 0.5 % 제약을 만족할 때까지 Stepsize크기 줄이기
        theta_bar = theta0 + SF*db;
        valid = paramconst(theta_bar, Spec);
        islnpost = lnpost(theta_bar, Spec) - lnpost0 >= 0;
        isOK = valid*islnpost;
        SF = SF*SF;
        if SF < 0.0001
            theta_bar = theta_hat;
            isOK = 1;
        end
    end
    
    % 후보생성분포의 분산-공분산 계산하기
    H = - FHESSnew1(lnpost, theta_bar, indbj, Spec); % 4 by 4
    H = real(H);
    H = 0.5*(H + H');
    V = invpd(H);
    V = 0.5*(V + V');
    
    % 프로포절 생성하기
    [~, p] = chol(V);
    if p > 0  % 만약 V에 에러가 있으면
        V = V0;
        theta1 = randmvt(nu,theta_bar,V);
    else
        theta1 = randmvt(nu,theta_bar,V);
    end
    
elseif Spec.MH == 3 % 임의보행 M-H
    theta_bar = theta0;
    theta1 = theta_bar + chol(V)'*randn(rows(theta_bar), 1);
end

end

%% M-H 비 계산하기

function [theta0, accept, lnpost0] = MH_step(lnpost, paramconst, theta_bar, theta0, theta1, V, Spec )

lnpost0 = lnpost(theta0, Spec);

% 후보생성밀도 계산하기
if Spec.MH < 3 % if tailored M-H
    nu = Spec.nu; % t-분포의 자유도
    q0 = lnpdfmvt(theta0, theta_bar, V, nu);
    q1 = lnpdfmvt(theta1, theta_bar, V, nu);
elseif Spec.MH == 3 % if 임의 보행 M-H
    q0 = 0;
    q1 = 0;
end

pd = lnpost0 + q1; % M-H 비의 분모(로그)

% 제약을 만족하는지 확인하기
valid = paramconst(theta1, Spec);

% 만약 만족하지 못하면 theta1은 기각되고 기존 값 theta0가 저장된다.
if valid == 0
    accept = 0;
    lnpost0 = pd;
else
    
    % 만약 제약을 만족하면 MH rate을 계산해서 기각또는 수용한다.
    lnpost1 = lnpost(theta1, Spec);
    
    pn = lnpost1 + q0; % M-H 비의 분자(로그)
    
    loga = pn - pd;% 로그 M-H 비
    
    accept = log(rand(1,1)) < loga; % 만약 수용되면 accept = 1, 아니면 accept = 0
    theta0 = accept*theta1 + (1-accept)*theta0;
    lnpost0 = accept*lnpost1 + (1-accept)*lnpost0;
    
end

end

function prt2(theta,lnpost0,lnlik0,counter,iter, freq)
% 중간결과 보여주기
[~, resid] = minresid(iter,freq);

if resid == 0
    acct_rate = 100*counter/iter; % acceptance rate
    
    clc
    disp('==================================================')
    disp(['현재 반복시행은 ',num2str(iter)]);
    disp('--------------------------------------------------')
    disp(['로그 우도 + 로그 사전밀도 = ',num2str(lnpost0)]);
    disp(['로그 우도 = ', num2str(lnlik0)]);
    disp('--------------------------------------------------');
    disp(' theta  acceptance rate (%)');
    disp('-----------------------------------');
    disp([theta, acct_rate]);
    disp('===================================');
    
end
end
