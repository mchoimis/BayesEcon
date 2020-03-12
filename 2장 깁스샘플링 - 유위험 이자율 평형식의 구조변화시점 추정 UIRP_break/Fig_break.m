clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

load tau_tsm

T = rows(tau_tsm);

intvl = 1/12;
startday = 2004 + intvl;
endday = 2004 + intvl*T;
datat = startday:intvl:endday;
datat = datat';
datat = datat(1:T);

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/3.5 scrsz(3)/3.5 scrsz(4)/4.5])
h = plot(datat,tau_tsm,'b-');
ytick = 0.2:0.2:1;
% xi = 1:4:rows(x1);
% xtick = x1(xi);
set(gca,'YTick',ytick);
% set(gca,'XTick',xtick);
% ylim([-0.1 1.1]);
% xlim([x1(1) x1(end)]);
set(h,'LineWidth',2.5)
xlabel('Time');
ylabel('Mass');