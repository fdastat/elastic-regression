clear; clc;

rng(12345);

%% Parameter List
T = 50; % Time samples
k = 1; 
J = 2*k; % half the number of coefficients used
sig = 0.01; % Noise level
n = 20; % number of training data


%% Initializations
t = (0:T)/T;
dt = mean(diff(t));

id = (1:k);
SS = sqrt(2)*sin(2*pi*t'*id);
CS = sqrt(2)*cos(2*pi*t'*id);
B = [SS CS]; %%% Basis functions for predictors in regression


%% True Coefficient Function
c0 = ones(2*k,1);
beta0 = B*c0;

% figure(1); clf; 
% plot(t,beta0,'LineWidth',2);
% set(gca,'fontsize', 18);
% hold on;


%% Form Simulated Data
% Generate data according to the model
for i=1:n
    
    fr(:,i) = B*randn(J,1);
    
    gam0 = DynamicProgrammingQ(fr(:,i)',beta0',0,0);
    gam = (gam0-gam0(1))/(gam0(end)-gam0(1));  % slight change on scale
    gam_dev = gradient(gam, dt);
    
    fnr(:,i) = interp1(t, fr(:,i), (t(end)-t(1)).*gam + t(1))'.*sqrt(gam_dev');

    y00(i) = (sum(beta0.*fnr(:,i))*dt).^2;
end
e = sig*randn(1,n);
yr = y00 + e;

%% Distort the Training and Test Parts
% Randomly warp the predictor functions
for i=1:n
    a(i) = 1 + 1*rand;
    gam  = t.^a(i);
    gam_dev = gradient(gam, dt);
    frr(:,i) = interp1(t, fr(:,i), (t(end)-t(1)).*gam + t(1))'.*sqrt(gam_dev');
end


%% This is where the inference starts
    
clear f_train f_test y_train y_test
f_train = frr(:,1:10);
f_test = frr(:,11:20);
y_train = yr(1:10);
y_test = yr(11:20);


% Basis

% % Different Basis (B-spline J = 4)
% clear B; 
% B = create_basismatrix(t, 4, 4);
% 
n = size(f_train, 2);
m = size(f_test, 2);

%% The model-based MLE - Elastic regression

% % call optimization
tic
    options = optimoptions(@fminunc,'Display','iter', 'Algorithm','quasi-newton');
    fun = @(c)MyLogLikelihoodFn(c,y_train,n,B,t,f_train);
    [c_hat,val, exitflag, output] = fminunc(fun,rand(J+1,1),options);
toc

a = c_hat;

% linear
[h1, c_hat_p1] = Amplitude_Index(f_train, t, B, y_train, 20, a, 'poly1')
yhat1 = c_hat_p1(1) + MapC_to_y(m,c_hat_p1(2:J+1),B,t,f_test);
yhatz1 = h1(yhat1)';
SSEz1 = sum((y_test - yhatz1).^2)

% quadratic
[h2, c_hat_p2] = Amplitude_Index(f_train, t, B, y_train, 20, a, 'poly2')
yhat2 = c_hat_p2(1) + MapC_to_y(m,c_hat_p2(2:J+1),B,t,f_test);
yhatz2 = h2(yhat2)';
SSEz2 = sum((y_test - yhatz2).^2)

% cubic
[h3, c_hat_p3] = Amplitude_Index(f_train, t, B, y_train, 20, a, 'poly3')
yhat3 = c_hat_p3(1) + MapC_to_y(m,c_hat_p3(2:J+1),B,t,f_test);
yhatz3 = h3(yhat3)';
SSEz3 = sum((y_test - yhatz3).^2)
