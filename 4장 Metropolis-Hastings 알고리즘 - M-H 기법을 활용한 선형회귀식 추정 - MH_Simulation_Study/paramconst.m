
function [valid] = paramconst(psi, Spec)

validm = ones(30,1); 

% ��� �Ķ���ʹ� �����ؾ� �Ѵ�.
% �ϳ��� �������� �ʴٸ� ������ �������� �ʴ� ���̴�.
if minc(isfinite(psi)') == 0; 
    
    validm(1) = 0; 
    
end

% sig2�� ������� �Ѵ�.
validm(2) = psi(Spec.ind_IG) > 0;

valid = minc(validm); 

end