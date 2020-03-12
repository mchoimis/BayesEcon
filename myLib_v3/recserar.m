% RECSERAR: gauss code
% RECSERAR(x,y0,a) constructs a recursive time series
% x: N*K   y0: P*K   a: P*K   y: N*K
% y(t)=x(t)+a(1)y(t-1)+...a(p)y(t-p) for t=p+1,..N
% y(t)=y0(t) for t=1,..P

function y = recserar(x, y0, a)
    p = size(y0, 1);
    [n, k] = size(x);

    y = zeros(n, k);
    y(1:p, :) = y0;
    aReverse = flipud(a);
    for i = p+1:n
         y(i, :) = sum(y(i-p:i-1, :).*aReverse, 1) + x(i, :);
    end
    
    
end