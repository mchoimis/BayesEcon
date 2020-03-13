function p11 = Gen_P(sm, N1)

  countm = CountTransitions(sm); % countm(i,j) = 상태 i에서 상태 j로 간 횟수
  
  %% p11 샘플링
  N = countm(1,:)' + N1; 
  P = randDir(N); 
  p11 = P(1,1);
   
end