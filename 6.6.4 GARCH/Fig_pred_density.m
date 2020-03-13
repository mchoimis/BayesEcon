clear
clc
addpath('C:\Users\user\Dropbox\MATLAB\M_library')
 
%% 자료 불러오기
load Yfm
load yf

%% 그림 그리기
[kd,xi]= ksdensity(Yfm);
  
figure
plot(xi, kd, 'linewidth', 2.5);
xlim([-4 4])
xlabel('주가수익률 (%)')
ylabel('확률밀도')
line([yf yf],[0 kd(51)],'Marker','o','LineStyle','--','Color','r','LineWidth',2.5)
line([-5 yf],[kd(51) kd(51)],'Marker','o','LineStyle',':','Color','r','LineWidth',2)
