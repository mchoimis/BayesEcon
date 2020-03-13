function [S, Filtpm] = Gen_S(Y, X, beta1, beta2, sig21, sig22, p11, p22)
% S 샘플링

   % Filtered probability 계산하기
   [Filtpm, P] = Filter(Y, X, beta1, beta2, sig21, sig22, p11, p22);
   
   % Backwared recursion
   S = sgen(Filtpm, P);
   
end

function [Filtpm, P] = Filter(Y, X, beta1, beta2, sig21, sig22, p11, p22)
% Filtered probability 계산하기

P = zeros(2,2);
P(1,1) = p11;
P(1,2) = 1 - p11;
P(2,2) = p22;
P(2,1) = 1 - p22;

prb_ll = zeros(2,1);
if p22< 1
    prb_ll(1,1) = (1 - p22)/(2 - p11 - p22);
    prb_ll(2,1) = 1 - prb_ll(1,1);
else
    prb_ll(1,1) = 1;
end
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
end

%  Macro to generate st 
%  F : filtered probability 
%  Pcap : transition probability matrix 
%  ns : unmber of regimes 
function [sm, stm] = sgen(F,Pcap)
  ns = cols(F);  %  # of regimes 
  n = rows(F);
  sm = zeros(n,1);   %  regime index 
  stm = zeros(n,ns); % regime dummy 
  psm = zeros(n,ns); %  storage for the probabilities 

  pstyn = F(n,:);
  sm(n) = discret1(pstyn',1);
  stm(n,sm(n)) = 1;
  psm(n,:) = pstyn;

  t = n - 1;
  while t >= 1 
   st1 = sm(t+1); % value of the state at t+1 
   pstyn = F(t,:) .* Pcap(:,st1)'; % 1 * m+1 row vector 
   pstyn = pstyn/sumc(pstyn'); % Pr(st|Yn)  
   sm(t) = discret1(pstyn',1);
   stm(t,sm(t)) = 1;
   psm(t,:) = pstyn;
   t = t - 1;
  end 
end