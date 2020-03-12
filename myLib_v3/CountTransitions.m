function countm = CountTransitions(sm)

% Counting the # of Regime switches 
nreg = maxc(sm); % ������ ��
countm = zeros(nreg,nreg); % count�� ������ ��
n = rows(sm);

for t = 2:n;
    SL = sm(t-1);
    St = sm(t);
    countm(SL,St) = countm(SL,St) + 1;
end

end