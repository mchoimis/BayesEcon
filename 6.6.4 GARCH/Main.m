clear;
clc;
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% 샘플링 방법 선택하기
Spec.MH = 3;
% 0 = 깁스 샘플링
% 1 = Tailored Indpendent M-H
% 2 = Tailored Dependent M-H
% 3 = 임의보행 M-H

Spec.nu = 15; % 스튜던트-t 후보생성분포의 자유도, Tailored M-H에서만 사용됨


%% Option: 예측 여부
isForecast = 0; % 마지막 시점을 예측하면 1, 아니면 0 으로 두시오.

% isForecast = 0 ==> no prediction
% isForecast = 1 ==> out-of-sample forecasting
% isForecast = 2 ==> Actual forecasting
%% 자료 불러오기
stock_return = xlsread('KOSPI20141118','Data','B3:B3611');
stock_return = stock_return*100;

if isForecast == 1   
    yf = stock_return(end); % 예측밀도 계산을 위한 실현치 
 %    yf = [ ]; % 예측밀도를 계산하지 않을 때는 yf를 빈 행렬로 설정할 것
    Y = stock_return(1:end-1, 1);
else
    Y = stock_return(1:end, 1);
end


%% MCMC
% 사전분포
theta_ = [0.2; 0.2; 0.6]; % 평균
thetav_ = 0.1*ones(3,1); % 분산

Spec.theta_ = theta_;
Spec.thetav_ = thetav_;
Spec.Y = Y;

%% 1단계: 최적화
if Spec.MH > 0  % 깁스 샘플링할 때는 할 필요없음
    theta0 = [theta_; 0]; % 최적화의 초기값, 사전 평균
    [theta_hat, fmax, V, Vinv] = SA_Newton(@lnpost, @paramconst, theta0, Spec);
    % theta_hat = 사후분포의 모드
    % fmax = 사후분포 커넬의 극대값
end

%% 2 단계: MCMC 샘플링
n0 = 2000; % 번인 크기
n1 = 20000; % MCMC 크기
freq = 500; % 매 freq 반복시행마다 중간결과 보기

% MCMC 시뮬레이션
[MHm, accpt, postmom_para] = MCMC(@lnpost, @lnlik, @paramconst, n0, n1, theta_hat, V, freq, Spec);

save MHm.txt -ascii MHm;
save postmom_para.txt -ascii  postmom_para;

Volm = zeros(n1, rows(Y));
Yfm = zeros(n1, 1); % 예측분포 저장할 장소
PredLikm = zeros(n1, 1); % 예측밀도 저장할 장소
for iter = 1: n1
    
    % 변동성 추출하기
    theta = MHm(iter, :)';
    [~, Vol] = Kalman_mex(theta, Y);
    Volm(iter, :) = Vol'; % 변동성 저장
    
    if isForecast == 1
        [y_pred, lnpredlik] = Gen_Forecast(theta, Y, Vol, yf);
        Yfm(iter) = y_pred;
        PredLikm(iter) = exp(lnpredlik);
    end
end


%% 결과보기
if isForecast == 1
    if isempty(yf) == 0
        predlik = meanc(PredLikm); % 예측밀도
        disp(['예측밀도는  ', num2str(predlik)]);
    end
    
    save Yfm Yfm
    save yf yf
    %% ES 계산하기
    VaR = quantile(Yfm, 0.05);
    disp(['VaR is  ', num2str(VaR), ' %']);
    ES_Yfm = Yfm(Yfm<VaR);
    ES = meanc(ES_Yfm);
    disp(['ES is  ', num2str(ES), ' %']);
    ql = [0.025 0.975];
    cb = quantile(Yfm, ql);
    disp(['95% C.I. is  [', num2str(cb),']']);
end




Vol = meanc(Volm);
T = rows(Vol);
xa = 1:T;
figure
if isForecast > 0
    subplot(2,1,1)
    plot(xa, abs(Y), 'k:', xa, Vol, 'b-');
    xlim([0 T+1]);
    xlabel('time','fontsize', 10)
    title('(a) Volatility')
    legend('|y|','volatility');
    
    subplot(2,1,2)
    miny = minc(Yfm);
    maxy = maxc(Yfm);
    int = (maxy - miny)/50;
    interval = miny:int:maxy;
    hist(Yfm, interval);
    title('(b) Predictive Dist.')
else
    plot([abs(Y), Vol]);
    title('Volatility')
    legend('|y|','volatility');
end

