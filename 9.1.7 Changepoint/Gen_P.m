function p11 = Gen_P(sm, N1)

  countm = CountTransitions(sm); % countm(i,j) = ���� i���� ���� j�� �� Ƚ��
  
  %% p11 ���ø�
  N = countm(1,:)' + N1; 
  P = randDir(N); 
  p11 = P(1,1);
   
end