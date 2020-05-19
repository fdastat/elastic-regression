function x = MyLogLikelihoodFn(c,y0, B, t,f)

[~, N] = size(f);

y = MapC_to_y(N,c,B,t,f);

x = sum((y0 - y).*(y0 - y));

