clear
clc
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

% 불러오기
load MHm.txt

post = MHm(:, 3);

%% Restricted 
prior = 1 + 1*randn(rows(MHm), 1);
[f1, x1] = ksdensity(prior); 

[f2, x2] = ksdensity(post);

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/3.5 scrsz(3)/3.5 scrsz(4)/3.5])
h = plot(x1, f1, 'k--', x2, f2, 'b-');
xlabel('$$\beta_1$$','interpreter','Latex','FontSize',12)
xlim([-2 4])
ylabel('Density','FontSize',12)
set(h,'LineWidth',3)
legend(h, 'Prior','Posterior','location','NorthEast','Orientation','vertical')

