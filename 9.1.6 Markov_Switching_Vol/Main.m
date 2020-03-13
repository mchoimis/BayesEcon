clear; 
clc;
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');
 
%% 자료 불러오기
Data = xlsread('KOSPI20141118','Data','B3:F3611');

Data = Data*100;

Y = Data(2:end, 1);
X = [ones(rows(Y), 1), Data(1:end-1, 1)];
n0 = 1000;
n1 = 5000;
n = n0 + n1;

%% 사전분포
% beta의 사전분포
beta0 = zeros(2, 1);
B0 = 0.1*eye(2);

% sig21, sig22의 사전분포
alpha0 = 2;
delta0 = 4;

% p11의 사전분포
a10 = 50;
b10 = 5;
N1 = [a10; b10];

% p22의 사전분포
a20 = 5;
b20 = 50;
N2 = [a20; b20];

%% 초기값 설정
absY = abs(Y); 
S = absY > meanc(absY); % 상태 1은 저변동성, 상태 2는 고변동성 상태
S = S + 1;

sig21 = delta0/alpha0;
sig22 = delta0/alpha0;

p11 = a10/(a10 + b10);
p22 = a20/(a20 + b20);

%% 저장할 방
T = rows(Y);
Sm = zeros(n, T);
beta1m = zeros(n, 2);
beta2m = zeros(n, 2);
sig2m = zeros(n, 2);
Pm = zeros(n, 2);

%% MCMC 시작
for iter = 1:n
   
   if isequal(floor(iter/100),iter/100) == 1  % 1 if equal
       clc
       disp(['현재 반복시행 = ', num2str(iter)]);
   end   

%  Step 1 : beta 샘플링
    [beta1, beta2, Y1, Y2, X1, X2] = Gen_beta(Y, X, S, sig21, sig22, beta0, B0);
     beta1m(iter, :) = beta1';
     beta2m(iter, :) = beta2';
     
%  Step 2 : sig2 샘플링
    [sig21, sig22] = Gen_Sigma(Y1, Y2, X1, X2, beta1, beta2, sig21, sig22, alpha0, delta0);
     sig2m(iter, :) = [sig21, sig22];
     
%  Step 3 : S 샘플링
   [Filtpm, P] = Filter(Y, X, beta1, beta2, sig21, sig22, p11, p22);
   S = sgen(Filtpm, P);
   Sm(iter, :) = S';

%  Step 4 : P 샘플링
   [p11, p22] = Gen_P(S, N1, N2);
    Pm(iter, :) = [p11, p22];

end

MHm = [beta1m, beta2m, sig2m, Pm];
MHm = MHm(n0+1:n, :); % 번인 버리기
alpha = 0.025;
maxac = 200;
postmom = MHout(MHm,alpha,maxac);
  
 %% 그림 그리기   
Sm = Sm(n0+1:n, :); % 번인 버리기
post_prob2 = meanc(Sm) - 1;
subplot(2,1,1);
plot(post_prob2);
xlim([0, T])
ylim([-0.05, 1.05])
xlabel('Time');
ylabel('probability');
title('(a) Posterior Prob. of High Volatility State');

subplot(2,1,2);
plot(absY);
xlim([0, T])
xlabel('Time');
ylabel('(%)');
title('(b) abs(stock return)');
