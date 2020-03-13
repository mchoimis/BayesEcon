function [lnL, Volm] = Kalman(theta, ym)

T = rows(ym);

a0 = theta(1);
a1 = theta(2);
gam1 = theta(3);
e_L = theta(4);

lnLm = zeros(T,1); 
Volm = lnLm; 

sig2_L = a0/(1-a1-gam1); 

for t =  1:T 
    yt = ym(t,1);
    sig2t = a0 + a1*e_L^2 + gam1*sig2_L; 
    lnLm(t) = lnpdfn(yt,0,sig2t); 
    Volm(t) = sqrt(sig2t);
    e_L = yt;
    sig2_L = sig2t; 
end

lnL = sumc(lnLm);

end


