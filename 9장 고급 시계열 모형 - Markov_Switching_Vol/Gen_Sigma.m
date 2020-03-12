function [sig21, sig22] = Gen_Sigma(Y1,Y2,X1,X2,beta1,beta2,sig21_,sig22_,alpha0, delta0)

     %% ���� 1
     ehat = Y1 - X1*beta1;
     d1 = delta0 + ehat'*ehat;
     a1 = alpha0 + rows(X1);
     sig21 = randig(a1/2,d1/2,1,1); 
     isOK = sig21 < sig22_;
     sig21 = isOK*sig21 + (1 - isOK)*sig21_; % �ĺ����� �������� Ȯ��
     %% ���� 2
     ehat = Y2 - X2*beta2;
     d1 = delta0 + ehat'*ehat;
     a1 = alpha0 + rows(X2);
     sig22 = randig(a1/2,d1/2,1,1); 
     isOK = sig21 < sig22;
     sig22 = isOK*sig22 + (1 - isOK)*sig22_; % �ĺ����� �������� Ȯ��
     
end