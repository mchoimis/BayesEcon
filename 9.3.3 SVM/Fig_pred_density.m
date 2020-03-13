clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');
%% 자료 불러오기
load Yfm.txt
load yf.txt

%% 그림 그리기
[kd,xi]= ksdensity(Yfm);
  
p = 50; % yf와 가장 근접한 xi의 값이 xi(p)이다.
figure
plot(xi, kd, 'linewidth', 2.5);
xlim([-3.5 3.5])
ylim([0 0.6])
xlabel('Stock return (%)')
ylabel('Density')
line([xi(p) xi(p)],[0 kd(p)],'Marker','o','LineStyle','--','Color','k','LineWidth',2.5)
line([-5 xi(p)],[kd(p) kd(p)],'Marker','o','LineStyle',':','Color','k','LineWidth',2)
