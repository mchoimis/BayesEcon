clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

load mFm.txt
load Yfm.txt
load realized_yc.txt
tau = [3, 6, 12, 24, 36, 60]'; 

T = rows(mFm);
%% Factor 그리기
xtick = 13:36:T;
xa = 1:T;
xticklabel = {'Jan 2002', 'Jan 2005', 'Jan 2008', 'Jan 2011', 'Jan 2014'};
subplot(2,1,1)
h = plot(xa, mFm(:,1), 'b-',xa, mFm(:,2), 'k--',xa, mFm(:,3), 'k:' );
xlim([0, T+1]);
xlabel('Time');
set(gca,'XTick', xtick)
set(gca,'XTickLabel',xticklabel,'fontsize', 10)
set(h,'Linewidth',2)
legend('Level','Slope','Curvature')
title('(a) Factors');

%% 예측분포 그리기
q = [0.05, 0.5, 0.95];
pred_yc = quantile(Yfm, q)';
subplot(2,1,2)
h = plot(tau, pred_yc(:,1), 'k:',tau, pred_yc(:,2), 'k--',tau, pred_yc(:,3), 'k:',tau, realized_yc, 'b-');
xlabel('Maturity');
xlim([tau(1), tau(end)]);
ylim([minc1(Yfm) maxc1(Yfm)]);
set(gca,'XTick', tau)
set(h,'Linewidth',2)
legend('5%', 'Median', '95%', 'Realized','location','Southeast')
title('(b) Predictive yield curve');