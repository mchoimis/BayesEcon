function [lnL] = lnlik(theta, Spec) 

Y = Spec.Y;

theta = real(theta);
lnL = Kalman_mex(theta, Y); % ���⼭ ������ �߻��ϸ� Kalman_mex��
% Kalman ���� ��ü�ϰų�, Kalman�� ���� Kalman_mex�� ��ȯ�ؼ� ����Ͻÿ�.


end
