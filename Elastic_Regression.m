function [h, beta, cost] = Elastic_Regression(f, t, B, y0, MaxIter, link)

beta = 0;
[~, N] = size(f);
J = size(B,2);

options = optimoptions(@fminunc,'Display','iter', 'Algorithm','quasi-newton');
fun = @(c)MyLogLikelihoodFn(c, y0, B, t, f);
[c_hat,~,~,~] = fminunc(fun,rand(J,1),options);

beta1 = B*c_hat;
for i = 1:N
    bet = B*c_hat;
    gam0 = DynamicProgrammingQ(f(:,i)', bet',0,0);
    gam(i,:) = (gam0 - gam0(1))/(gam0(end)-gam0(1));
end

mgam = mean(gam);
gamI = invertGamma(mgam);
beta2 = interp1(t, beta1, (t(end) - t(1)).*gamI + t(1))';
y = MapC_to_y_pred(N, beta2, t, f);

h = fit(y', y0', link);

cost = 10e+10;
iter = 0;
tol = 10e-10;

while iter < MaxIter
    iter = iter +1
    
    options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
    fun = @(c)MyLogLikelihoodFn2(c, y0, B, t, f, h);
    [c_hatt,~, ~, ~] = fminunc(fun,c_hat,options);
    
    beta1 = B*c_hatt;
    for i = 1:N
        bet = B*c_hatt;
        gam0 = DynamicProgrammingQ(f(:,i)', bet',0,0);
        gam(i,:) = (gam0 - gam0(1))/(gam0(end)-gam0(1));
    end

    mgam = mean(gam);
    gamI = invertGamma(mgam);
    beta2 = interp1(t, beta1, (t(end) - t(1)).*gamI + t(1))';
    y = MapC_to_y_pred(N, beta2, t, f);

    h1 = fit(y', y0', link);
    val = sum((y0 - h1(y)').*(y0 - h1(y)'));
    
    if (cost - val)^2 < tol
        cost = val;
        c_hat = c_hatt;
        h = h1;
        beta = beta2;
        break
    end
cost = val;
c_hat = c_hatt;
h = h1;
beta = beta2;
end

