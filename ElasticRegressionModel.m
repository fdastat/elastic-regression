
B = create_basismatrix(t, 20, 4);

%% Amplitude

N = size(f_train,2);
J = size(B,2);

rng(1)

tic 
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
fun = @(c)MyLogLikelihoodFn(c,y_train,B,t,f_train);
[c_hat,val, exitflag, output] = fminunc(fun,rand(J+1,1),options);
toc 


%% Single-Index Model

N = size(f_train,2);
J = size(B,2);

a = c_hat;

rng(1)
[h1, c_hat] = Amplitude_Index(f_train, t, B, y_train, 20, a, 'poly1')
yhat1 = c_hat(1) + MapC_to_y(size(f_test,2),c_hat(2:J+1),B,t,f_test);
SSEz1 = sum((y_test' - h1(yhat1)).^2)

rng(1)
[h2, c_hat] = Amplitude_Index(f_train, t, B, y_train, 20,a, 'poly2')
yhat2 = c_hat(1) + MapC_to_y(size(f_test,2),c_hat(2:J+1),B,t,f_test);
SSEz2 = sum((y_test' - h2(yhat2)).^2)

rng(1)
[h3, c_hat] = Amplitude_Index(f_train, t, B, y_train, 20,a, 'poly3')
yhat3 = c_hat(1) + MapC_to_y(size(f_test,2),c_hat(2:J+1),B,t,f_test);
SSEz3 = sum((y_test' - h3(yhat3)).^2)


