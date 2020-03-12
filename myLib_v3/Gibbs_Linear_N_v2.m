function [bm, sig2m, postmom, lnPPL, PPLm] = Gibbs_Linear_N_v2(Y_full,X_full,b_0,B_0,a_0,d_0,n0,n1, printi, H)
% Gibbs-Sampling with normal error
% lnPPL = log PPL

if nargin == 8
    printi = 1;
    H = 0;
end

if nargin == 9
    H = 0;
end

precB_0 = invpd(B_0); % Precision matrix of B_0
n = n0 + n1; % total number of iteration

k = cols(X_full);
bm = zeros(n,k); % b 저장 공간
sig2m = zeros(n,1); % sig2 저장공간

% 초기값 설정
if a_0*d_0 > 0
    sig2 = 0.5*d_0/(0.5*a_0 - 1); % initial value for 1/sig2
else
    sig2 = stdc(Y_full)^2;
end

if H == 0 
    Y = Y_full;
    X = X_full;
    [bm, sig2m, postmom] = Gibbs_Linear_N( Y,X,b_0,B_0,a_0,d_0,n0,n1, printi);
    lnPPL = 0;
else
    PPLm = zeros(H, 1);
    T0 = rows(Y_full) - H;
    for indH = 1:H
        Y = Y_full(1:T0+indH-1,1);
        X = X_full(1:T0+indH-1,:);
        yf = Y_full(T0+indH,1);
        xf = X_full(T0+indH,:);
        PPL_Hm = zeros(n,1);
        for iter=1:n
                        
            % Step1 : Full condtional posterior distribution of b, given sig2
            beta = Gen_beta(Y,X,b_0,precB_0,sig2);
            bm(iter,:) = beta'; % save beta
            
            % Step2: Full conditional posterior distribution of sig2, given b
            sig2 = Gen_sig2(Y,X,beta,a_0,d_0);
            sig2m(iter) = sig2;
            
            PPL_Hm(iter) = lnpdfn(yf, xf*beta, sig2);
            
        end
        PPLm(indH) = log(meanc(exp(PPL_Hm(n0+1:n))));
    end
    
    bm = [ ]; 
    sig2m = [ ];
    postmom = [ ];
    lnPPL = sumc(PPLm);
    disp(['로그 사후예측우도 (Log PPL) = ',num2str(lnPPL)]);
    
end
end


    function [ beta ] = Gen_beta(Y, X, b_0, precB_0, sig2)
        
        k = cols(X);
        XX = X'*X;
        XY = X'*Y;
        
        B_1 = invpd((1/sig2)*XX + precB_0); % full conditional variance B_1
        A = (1/sig2)*XY + precB_0*b_0;
        M = B_1*A;
        
        beta = M + chol(B_1)'*randn(k,1); % sampling beta
        
        
    end

    function [ sig2 ] = Gen_sig2( Y, X, beta, a_0, d_0 )
        
        T = rows(X);
        a_1 = T + a_0;
        e = Y - X*beta;
        d_1 = d_0 + e'*e;
        
        sig2 = randig(a_1/2,d_1/2,1,1); % sig2 sampling
        
        
    end


