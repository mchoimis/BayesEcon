function Plot_Prior_Post(y1, y2, xlabel_latex, legend1, legend2)

y = [y1, y2];
xlimit = [minc1(y) maxc1(y)]; % (x��) ������ ����

%% �е�����
[f1, x1] = ksdensity(y1);

[f2, x2] = ksdensity(y2);

%% figure size
fig_width = 6; % inch
fig_height = 4; % inch
margin_vert_u = 0.2; % inch
margin_vert_d = 0.6; % inch
margin_horz_l = 0.8; % inch
margin_horz_r = 0.2; % inch

[hFig,hAxe] = figmod(fig_width,fig_height,margin_vert_u,margin_vert_d,margin_horz_l,margin_horz_r);

hPlot1 = plot(hAxe,x1,f1);
set(hPlot1,'Color','k','LineStyle','--')
hold on;
hPlot2 = plot(hAxe,x2,f2);
set(hPlot2,'Color','b','LineStyle','-')
hold on;
set([hPlot1 hPlot2],'Linewidth',3)
xlabel(xlabel_latex,'interpreter','Latex','FontSize',20)
ylabel('density','FontSize',15)
xlim(xlimit)
if nargin > 4
    h_legend=legend([hPlot1 hPlot2], legend1,legend2,'location','NorthEast','Orientation','vertical');
    
else
    h_legend=legend([hPlot1 hPlot2], 'prior','posterior','location','NorthEast','Orientation','vertical');
end
set(gca,'fontsize',15);
set(h_legend,'FontSize',16);

end