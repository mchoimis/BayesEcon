function [ X ] = ARrnd( f,g,grnd,c,m,n )
% Sample x by using Accept-Rejection Method

X = zeros(m,n);
for i=1:m*n
    accept = false;
    while accept == false
        v = grnd();
        u = rand();
        if u <= f(v)/(c*g(v))
            X(i) = v;
            accept = true; 
        end
    end
end 

end

