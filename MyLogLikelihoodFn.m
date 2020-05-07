function x = MyLogLikelihoodFn(c,y0, n, B, t,f)
%function x = MyLogLikelihoodFn(c)

[M, N] = size(f);

J = length(c);

y = c(1) + MapC_to_y(N,c(2:J),B,t,f);

x = sum((y0- y).*(y0 - y));

