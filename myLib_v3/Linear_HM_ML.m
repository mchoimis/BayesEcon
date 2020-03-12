function lnML = Linear_HM_ML(MHm, Data )
% Harmonic mean 방법으로 로그주변우도 계산

n = rows(MHm);
invLm = zeros(n,1);


for iter = 1:n
    
    theta = MHm(iter,:)';
    
    invLm(iter) = 1/exp(lnlik(theta, Data));

end

lnML = log(n) - log(sumc(invLm));

disp('================================================================');
disp('조화 평균 기법');
disp('----------------------------------------------------------------');
disp(['주변 우도 = ', num2str(lnML)]);
disp('=================================================================');


end

