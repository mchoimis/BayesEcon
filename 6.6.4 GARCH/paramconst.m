% the parameter constraints
% valid = 0 if invalid
% valid = 1 if valid
function [valid, validm] = paramconst(theta, Spec)

  validm = ones(30,1);
  
  isfin = isfinite(theta);
  validm(1) = minc(isfin) > 0.5;
  
  if validm(1) > 0
      
     validm(2) = minc(theta(1:3)) > 0;
       
     validm(3) = theta(2) + theta(3) < 0.995;
      
  end
  
   valid = minc(validm); % if any element is equal to zero, invalid

%    if valid == 0   % valid = 0 if invalid
%        i = 1:30;
%      disp([i' validm]);
%       disp(theta);
%    end
    
  end
