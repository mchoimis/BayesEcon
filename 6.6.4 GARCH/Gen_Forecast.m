function [y_pred, lnpredlik] = Gen_Forecast(theta, ym, Vol, yf)

T = rows(ym);

a0 = theta(1);
a1 = theta(2);
gam1 = theta(3);

eL = ym(T); % 예측오차
sig2L = Vol(T);
sig2t = a0 + a1*(eL^2) + gam1*sig2L^2; % 조건부 분산
y_pred = sqrt(sig2t)*randn(1,1);

if isempty(yf)
   lnpredlik = 0;
else
   lnpredlik = lnpdfn(yf, 0, sig2t);
end

end