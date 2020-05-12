function [h, c_hat, cost] = Amplitude_Index(f, t, B, y0, MaxIter, b, link)

J = size(B,2);
n = size(f, 2);

cost = 10000;
iter = 0;
tol = 0.0001;
while iter < MaxIter
    iter = iter +1
    y = c_hat(1) + MapC_to_y(n,c_hat(2:J+1),B,t,f);
    h = fit(y', y0', link);

    options = optimoptions(@fminunc,'Display','iter', 'Algorithm','quasi-newton');
    fun = @(c)MyLogLikelihoodFn2(c,y0,B,t,f,h);
    [c_hatt,val, exitflag, output] = fminunc(fun,b,options);
    if (cost - val)^2 < tol
        cost = val;
        c_hat = c_hatt;
        break
    end
cost = val;
c_hat = c_hatt;
end
