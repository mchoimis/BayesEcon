function [lnL] = lnlik(theta, Spec) 

Y = Spec.Y;

theta = real(theta);
lnL = Kalman_mex(theta, Y); % 여기서 에러가 발생하면 Kalman_mex를
% Kalman 으로 대체하거나, Kalman를 직접 Kalman_mex로 변환해서 사용하시오.


end
