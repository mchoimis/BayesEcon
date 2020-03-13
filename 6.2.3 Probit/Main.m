clc;
clear;
addpath('D:\Dropbox\MATLAB\Textbook\myLib_v3');

%% 자료 불러오기
Data = xlsread('Probit_Data','Sheet1','B2:E1001');

T = rows(Data);
Y = Data(:, 1);
X = [ones(T, 1), Data(:, 2:end)];

%% 사전분포
k = cols(X);
b0 = zeros(k,1);
B0 = 1*eye(k);

n0 = 2000;
n1 = 10000;
[betam, postmom] = Probit(Y, X, b0, B0, n0, n1);














