clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

% 불러오기
load yfm_AR1.txt
load yfm_AR2.txt
load yfm_oil.txt
load weight.txt
y = [yfm_AR1, yfm_AR2, yfm_oil];

weight = round(rows(yfm_oil)*weight);
y_combi = [yfm_oil(1:weight(1)); yfm_AR1(1:weight(2));yfm_AR2(1:weight(3))];

postmom = MHout([y,y_combi],0.025,50);

%% 그림 그리기
xlabel_latex = '$y_{T+1}$'; % x축 이름


xlimit = [minc1(y) maxc1(y)]; % (x축) 분포의 범위

%% 밀도추정
[f1, x1] = ksdensity(y(:,1));
[f2, x2] = ksdensity(y(:,2));
[f3, x3] = ksdensity(y(:,3));
[f4, x4] = ksdensity(y_combi);
%% figure size
fig_width = 6; % inch
fig_height = 3; % inch
margin_vert_u = 0.1; % inch
margin_vert_d = 0.5; % inch
margin_horz_l = 0.5; % inch
margin_horz_r = 0.1; % inch

[hFig,hAxe] = figmod(fig_width,fig_height,margin_vert_u,margin_vert_d,margin_horz_l,margin_horz_r);

hPlot1 = plot(hAxe,x1,f1);
set(hPlot1,'Color','b','LineStyle','-')
hold on;
hPlot2 = plot(hAxe,x2,f2);
set(hPlot2,'Color','k','LineStyle','-')
hold on;
hPlot3 = plot(hAxe,x3,f3);
set(hPlot3,'Color','k','LineStyle','-.')
hold on;
set([hPlot1 hPlot2 hPlot3],'Linewidth',3)
xlabel(xlabel_latex,'interpreter','Latex','FontSize',15)
ylabel('density','FontSize',12)
xlim(xlimit)
h_legend=legend([hPlot1 hPlot2 hPlot3], 'AR(1)','AR(2)','유가','location','NorthEast','Orientation','vertical');
set(h_legend,'FontSize',12);

%% figure size
fig_width = 6; % inch
fig_height = 3; % inch
margin_vert_u = 0.1; % inch
margin_vert_d = 0.5; % inch
margin_horz_l = 0.5; % inch
margin_horz_r = 0.1; % inch

[hFig,hAxe] = figmod(fig_width,fig_height,margin_vert_u,margin_vert_d,margin_horz_l,margin_horz_r);

hPlot1 = plot(hAxe,x1,f1);
set(hPlot1,'Color','b','LineStyle','-')
hold on;

set(hPlot1,'Linewidth',3)
xlabel(xlabel_latex,'interpreter','Latex','FontSize',15)
ylabel('density','FontSize',12)
xlim(xlimit)


