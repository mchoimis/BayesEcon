clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');


load Fm.txt -ascii Fm;
T = cols(Fm);
%% Factor ±×¸®±â
q = [0.05, 0.5, 0.95];
qFm = quantile(Fm, q)';

xtick = 1:20:T;
xa = 1:T;
xticklabel = {'60:Q1', '65:Q1', '70:Q1', '75:Q1', '80:Q1', '85:Q1', '90:Q1', '95:Q1', '00:Q1'};
scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2.5 scrsz(3)/2.5 scrsz(4)/3.5])
h = plot(xa, qFm(:,1), 'k--',xa, qFm(:,2), 'b-',xa, qFm(:,3), 'k:' );
xlim([0, T+1]);
xlabel('Time');
set(gca,'XTick', xtick)
set(gca,'XTickLabel',xticklabel,'fontsize', 10)
set(h,'Linewidth',2)
legend('2.5%','Median','97.5%')