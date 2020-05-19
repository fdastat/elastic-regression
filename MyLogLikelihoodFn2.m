function x = MyLogLikelihoodFn2(c, y0, B, t, f, h)

[~, N] = size(f);

J = length(c);

y = MapC_to_y(N,c,B,t,f);

x = sum((y0- h(y)').*(y0 - h(y)'));
