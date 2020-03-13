function [Filtpm, P] = Filter(Y, X, beta1, beta2, sig21, sig22, p11, p22) 

P = zeros(2,2);
P(1,1) = p11;
P(1,2) = 1 - p11;
P(2,2) = p22;
P(2,1) = 1 - p22;

prb_ll = zeros(2,1);
prb_ll(1,1) = (1 - p22)/(2 - p11 - p22);
prb_ll(2,1) = 1 - prb_ll(1,1);
T = rows(Y);
Filtpm = zeros(T, 2);

for t = 1:T

   yt = Y(t);
   xt = X(t,:)';
   
   lnpdfm = zeros(2, 1); % y의 조건부 밀도 
   lnpdfm(1,1) = lnpdfn(yt, xt'*beta1, sig21);
   lnpdfm(2,1) = lnpdfn(yt, xt'*beta2, sig22);
   pdfm = exp(lnpdfm);  % 2 by 1
      
   prb_tl = zeros(2, 1); % 예상확률
   prb_tl(1,1) = P(1,1)*prb_ll(1,1) + P(2,1)*prb_ll(2,1);
   prb_tl(2,1) = P(1,2)*prb_ll(1,1) + P(2,2)*prb_ll(2,1);
   
   y_tlm = prb_tl.*pdfm; % 2 by 1 
   
   y_tl = sumc(y_tlm); % 1 by 1
   prb_tt = y_tlm/y_tl; % 필터드 확률
   Filtpm(t,:) = prb_tt';
   
   prb_ll = prb_tt;
  
end
