clear
clc
addpath('C:\Users\user\Dropbox\MATLAB\M_library')
 
%% �ڷ� �ҷ�����
load Yfm
load yf

%% �׸� �׸���
[kd,xi]= ksdensity(Yfm);
  
figure
plot(xi, kd, 'linewidth', 2.5);
xlim([-4 4])
xlabel('�ְ����ͷ� (%)')
ylabel('Ȯ���е�')
line([yf yf],[0 kd(51)],'Marker','o','LineStyle','--','Color','r','LineWidth',2.5)
line([-5 yf],[kd(51) kd(51)],'Marker','o','LineStyle',':','Color','r','LineWidth',2)
