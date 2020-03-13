clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');
%% �ڷ� �ҷ�����
load Yfm.txt
load yf.txt

%% �׸� �׸���
[kd,xi]= ksdensity(Yfm);
  
p = 50; % yf�� ���� ������ xi�� ���� xi(p)�̴�.
figure
plot(xi, kd, 'linewidth', 2.5);
xlim([-3.5 3.5])
ylim([0 0.6])
xlabel('Stock return (%)')
ylabel('Density')
line([xi(p) xi(p)],[0 kd(p)],'Marker','o','LineStyle','--','Color','k','LineWidth',2.5)
line([-5 xi(p)],[kd(p) kd(p)],'Marker','o','LineStyle',':','Color','k','LineWidth',2)
