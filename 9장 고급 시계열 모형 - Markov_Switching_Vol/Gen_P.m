function [p11, p22] = Gen_P(sm, N1, N2)

  countm = CountTransitions(sm); % countm(i,j) = 상태 i에서 상태 j로 간 횟수
  
  %% p11 샘플링
  N = countm(1,:)' + N1; 
  P = randDir(N); 
  p11 = P(1,1);
  
  %% p22 샘플링
  N = countm(2,:)' + N2; 
  P = randDir(N); 
  p22 = P(2,1);
  
end