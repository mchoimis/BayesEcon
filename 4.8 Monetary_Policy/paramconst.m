
function [valid] = paramconst(psi, Spec)

validm = ones(30,1); 

% ��� �Ķ���ʹ� �����ؾ� �Ѵ�.
% �ϳ��� �������� �ʴٸ� ������ �������� �ʴ� ���̴�.
if minc(isfinite(psi)') == 0; 
    
    validm(1) = 0; 
    
end

% rho�� 0���� ũ�� 1���� �۴�.
validm(3) = psi(1) > 0;  
validm(4) = psi(1) < 1;

% sig2�� ������� �Ѵ�.
validm(5) = psi(Spec.ind_IG) > 0;

valid = minc(validm); 

end