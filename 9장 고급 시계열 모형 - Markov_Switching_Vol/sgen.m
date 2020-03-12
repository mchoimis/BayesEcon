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