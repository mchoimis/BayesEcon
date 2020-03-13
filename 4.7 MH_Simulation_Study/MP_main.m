%% 통화정책 모형 MH기법으로 추정 (Single block Tailored M-H)
clear;
clc;
addpath('D:\Dropbox\베이지안_강의노트\Matlab_code\myLib_v2');

%% 자료 불러오기
Data = xlsread('SML_Data_ch4', 'Sheet1', 'B2:E101');

T = rows(Data);
Spec.Data = Data; % 자료를 구조(structure)에 저장하기

%% 샘플링 방법 선택하기
Spec.MH = 2;
% 0 = 깁스 샘플링
% 1 = Tailored Indpendent M-H
% 2 = Tailored Dependent M-H
% 3 = 임의보행 M-H

Spec.nu = 15; % 스튜던트-t 후보생성분포의 자유도, Tailored M-H에서만 사용됨


%% 파라메터
ind_Normal = [1;2;3]; % theta 중 사전분포가 정규분포인 파라메터들의 위치
ind_IG = 4; % theta 중 사전분포가 Inverse-Gamma 파라메터의 위치

% structure
Spec.ind_Normal = ind_Normal;
Spec.ind_IG = ind_IG;

%% 사전분포 설정
% beta에 대한 사전분포 (정규분포)
Normal_mu = [0; 0; 0]; % 사전평균
Normal_V = [9; 9; 9]; % 사전분산

Spec.Normal_mu = Normal_mu;
Spec.Normal_V = Normal_V;

% sig2의 사전분포 (역감마 분포)
a0 = 10;
d0 = 10;
Spec.a0 = a0;
Spec.d0 = d0;

%% 1단계: 최적화
if Spec.MH > 0  % 깁스 샘플링할 때는 할 필요없음
    theta0 = [Normal_mu; 0.5*a0/(0.5*d0-1)]; % 최적화의 초기값, 사전 평균
    [theta_hat, fmax, V, Vinv] = SA_Newton(@lnpost, @paramconst, theta0, Spec);
    % theta_hat = 사후분포의 모드
    % fmax = 사후분포 커넬의 극대값
end

%% 2 단계: MCMC 샘플링
n0 = 2000; % 번인 크기
n1 = 20000; % MCMC 크기
freq = 500; % 매 freq 반복시행마다 중간결과 보기

% MCMC 시뮬레이션
if Spec.MH == 0  % 깁스 샘플링
    Y = Data(:, 1);
    X = Data(:, 2:end);
    [bm, sig2m] = Gibbs_Linear_N(Y, X, Normal_mu, diag(Normal_V), a0, d0, n0, n1);
    MHm = [bm, sig2m];
    accpt = 100*ones(cols(MHm), 1);
else  % M-H 샘플링
    [MHm, accpt] = MCMC(@lnpost, @lnlik, @paramconst, n0, n1, theta_hat, V, freq, Spec);
end
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
    se = sqrt(diag(V)); % 표준오차
disp('===============================================================================');
disp(' 라플라스 근사 결과');
disp('-------------------------------------------------------------------------------');
disp('    평균   표준오차  ');
disp('---------------------------------------------------------');
disp([theta_hat se]);
disp('---------------------------------------------------------');
disp(['우도 = ', num2str(fmax)]);
disp('---------------------------------------------------------');

end
