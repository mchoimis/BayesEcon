%   to compute the inverted gamma density on a grid
%   beta is also a vector 
%   outputs the log of the density
function [retf] = lnpdfig(sig2,alpha,beta)

if rows(sig2) > rows(alpha)
   alpha = alpha*ones(rows(sig2),1);
   beta = beta*ones(rows(sig2),1);
end  

   c = alpha.*log(beta) - gammaln(alpha);
   z = c - (alpha+1).*log(sig2) - beta./sig2;

 
retf = z;
end