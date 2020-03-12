
function [valid] = paramconst(psi, Spec)

validm = ones(30,1); 

% 모든 파라메터는 유한해야 한다.
% 하나라도 유한하지 않다면 제약을 만족하지 않는 것이다.
if minc(isfinite(psi)') == 0; 
    
    validm(1) = 0; 
    
end

% sig2는 양수여야 한다.
validm(2) = psi(Spec.ind_IG) > 0;

valid = minc(validm); 

end