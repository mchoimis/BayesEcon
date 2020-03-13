clc;
clear;
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% 자료 불러오기

Data = xlsread('Tobit_Data','Sheet1','B2:E501');
T = rows(Data);
Y = Data(:, 1);
X = [ones(T, 1), Data(:, 2:end)];

%% 사전분포
k = cols(X);
b0 = [2000; -500; -500; -500];
B0 = (500^2)*eye(k);

% prior for sig2
a_0 = 180;  
d_0 = (450^2)*a_0; % prior mean = 0.5*d_0/(0.5*a_0 - 1);

n0 = 2000;
n1 = 10000;
[betam, sig2m, postmom] = Tobit(Y, X, b0, B0, a_0, d_0, n0, n1);














