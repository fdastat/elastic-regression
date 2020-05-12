function x = MyLogLikelihoodFn2(c,y0, n, B, t,f, h)


[M, N] = size(f);

J = length(c);

y = c(1) + MapC_to_y(N,c(2:J),B,t,f);

x = sum((y0- h(y)').*(y0 - h(y)'));



% function x = MyLogLikelihoodFn(c,y0,n, B, t,f,q)
% %function x = MyLogLikelihoodFn(c)
% 
% [M, N] = size(f);
% 
% J = length(c);
% 
% y = c(1) + MapC_to_y(N,c(2:J),B,t,f,q);
% 
% z = fit(y', y0', 'poly1');
% 
% x = sum((y0- z(y)').*(y0 - z(y)'));
