clear;
clc;

addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% Importance Sampling Example
% X가 표준정규분포 f(x) = 표준정규분포의 pdf
% 임포턴스 함수 = 자유도가 5인 스튜던트 t 분포의 pdf
% g(x) = 1/(1 + x^2)
% 임포턴스 샘플링으로 E(g(x)) 근사하기.

%% 1. 정규분포에서 직접적으로 샘플링하기
N = 10000; % 시뮬레이션 크기

Xm = randn(N,1);
Ym = zeros(N,1);
for i = 1:N
    
    Ym(i) = 1/(1 + Xm(i)^2);
    
end

mY = meanc(Ym);

%% 2. 수학적으로 E(g(x)) 적분계산하기
fg = @(x) 1./(1+x.^2).*(1./sqrt(2.*pi).*exp(-x.^2./2));
integralval = integral(fg,-100,100);

%% 3. Importance sampling으로 E(g(x)) 계산하기
tm = trnd(5,N,1); % importance 함수에서 샘플링

% tpdf 계산
hm = tpdf(tm,5); % h(x) 계산

% 표준정규분포 pdf 계산
fm = normpdf(tm,0,1); % f(x) 계산

fhm = fm./hm;

% transformation
tranm = zeros(N,1);
for i = 1:N
    
    tranm(i) = 1/(1 + tm(i)^2);
    
end

% 결과
A = tranm.*fhm; % g(x)*(f(x)/h(x)) 계산
approx = meanc(A);

disp(['해석적 결과 = ', num2str(integralval)]);
disp(['Importance 샘플링 결과 = ', num2str(approx)]);
disp(['정규분포에서 직접적으로 샘플링한 결과 = ', num2str(mY)]);
