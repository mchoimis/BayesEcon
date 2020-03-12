clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

% 불러오기
tau = 0:1:120; % maturity
tau = tau';

lambda = 0.0609; % decay parameter

L1m = ones(rows(tau),1);
L2m = zeros(rows(tau),1);
L3m = zeros(rows(tau),1);

for tau = 0:120
    
    L2m(tau+1) = (1 - exp(-tau*lambda))/(tau*lambda);
    L3m(tau+1) = L2m(tau+1) - exp(-tau*lambda);
    
end

L2m(1) = 1;
L3m(1) = 0;

tau = 0:1:120; % maturity
tau = tau';

% figure size
fig_width = 6; % inch
fig_height = 5; % inch
margin_vert_u = 0.1; % inch
margin_vert_d = 0.5; % inch
margin_horz_l = 0.5; % inch
margin_horz_r = 0.1; % inch

[hFig,hAxe] = figmod(fig_width,fig_height,margin_vert_u,margin_vert_d,margin_horz_l,margin_horz_r);    

hPlot1 = plot(hAxe,tau,L1m);
set(hPlot1,'Color','b','LineStyle','-')
hold on;
hPlot2 = plot(hAxe,tau,L2m);
set(hPlot2,'Color','k','LineStyle','--')
hold on;
hPlot3 = plot(hAxe,tau,L3m);
set(hPlot3,'Color','k','LineStyle','-.')
set([hPlot1 hPlot2 hPlot3],'Linewidth',3)
xlabel('$$\tau$$','interpreter','Latex','FontSize',12)
ylabel('Loadings','FontSize',12)
ylim([0 1.1])
legend([hPlot1 hPlot2 hPlot3], 'loading on L_t','loading on S_t','loading on C_t','location','NorthEast','Orientation','vertical')