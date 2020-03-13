clear;
clc;
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% ���ø� ��� �����ϱ�
Spec.MH = 3;
% 0 = �齺 ���ø�
% 1 = Tailored Indpendent M-H
% 2 = Tailored Dependent M-H
% 3 = ���Ǻ��� M-H

Spec.nu = 15; % ��Ʃ��Ʈ-t �ĺ����������� ������, Tailored M-H������ ����


%% Option: ���� ����
isForecast = 0; % ������ ������ �����ϸ� 1, �ƴϸ� 0 ���� �νÿ�.

% isForecast = 0 ==> no prediction
% isForecast = 1 ==> out-of-sample forecasting
% isForecast = 2 ==> Actual forecasting
%% �ڷ� �ҷ�����
stock_return = xlsread('KOSPI20141118','Data','B3:B3611');
stock_return = stock_return*100;

if isForecast == 1   
    yf = stock_return(end); % �����е� ����� ���� ����ġ 
 %    yf = [ ]; % �����е��� ������� ���� ���� yf�� �� ��ķ� ������ ��
    Y = stock_return(1:end-1, 1);
else
    Y = stock_return(1:end, 1);
end


%% MCMC
% ��������
theta_ = [0.2; 0.2; 0.6]; % ���
thetav_ = 0.1*ones(3,1); % �л�

Spec.theta_ = theta_;
Spec.thetav_ = thetav_;
Spec.Y = Y;

%% 1�ܰ�: ����ȭ
if Spec.MH > 0  % �齺 ���ø��� ���� �� �ʿ����
    theta0 = [theta_; 0]; % ����ȭ�� �ʱⰪ, ���� ���
    [theta_hat, fmax, V, Vinv] = SA_Newton(@lnpost, @paramconst, theta0, Spec);
    % theta_hat = ���ĺ����� ���
    % fmax = ���ĺ��� Ŀ���� �ش밪
end

%% 2 �ܰ�: MCMC ���ø�
n0 = 2000; % ���� ũ��
n1 = 20000; % MCMC ũ��
freq = 500; % �� freq �ݺ����ึ�� �߰���� ����

% MCMC �ùķ��̼�
[MHm, accpt, postmom_para] = MCMC(@lnpost, @lnlik, @paramconst, n0, n1, theta_hat, V, freq, Spec);

save MHm.txt -ascii MHm;
save postmom_para.txt -ascii  postmom_para;

Volm = zeros(n1, rows(Y));
Yfm = zeros(n1, 1); % �������� ������ ���
PredLikm = zeros(n1, 1); % �����е� ������ ���
for iter = 1: n1
    
    % ������ �����ϱ�
    theta = MHm(iter, :)';
    [~, Vol] = Kalman_mex(theta, Y);
    Volm(iter, :) = Vol'; % ������ ����
    
    if isForecast == 1
        [y_pred, lnpredlik] = Gen_Forecast(theta, Y, Vol, yf);
        Yfm(iter) = y_pred;
        PredLikm(iter) = exp(lnpredlik);
    end
end


%% �������
if isForecast == 1
    if isempty(yf) == 0
        predlik = meanc(PredLikm); % �����е�
        disp(['�����е���  ', num2str(predlik)]);
    end
    
    save Yfm Yfm
    save yf yf
    %% ES ����ϱ�
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

