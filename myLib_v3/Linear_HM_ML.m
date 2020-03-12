function lnML = Linear_HM_ML(MHm, Data )
% Harmonic mean ������� �α��ֺ��쵵 ���

n = rows(MHm);
invLm = zeros(n,1);


for iter = 1:n
    
    theta = MHm(iter,:)';
    
    invLm(iter) = 1/exp(lnlik(theta, Data));

end

lnML = log(n) - log(sumc(invLm));

disp('================================================================');
disp('��ȭ ��� ���');
disp('----------------------------------------------------------------');
disp(['�ֺ� �쵵 = ', num2str(lnML)]);
disp('=================================================================');


end

