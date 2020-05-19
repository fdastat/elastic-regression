clear; clc;

rng(123);

%% Parameter List

T = 50; % Time samples
k = 1; 
J = 2*k; % half the number of coefficients used
sig = 0.01; % Noise level
n = 20;


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


%% Distort the samples
% Randomly warp the predictor functions

for i=1:n
    a(i) = 1 + 0.5*rand;
    gam  = t.^a(i);
    gam_dev = gradient(gam, dt);
    frr(:,i) = interp1(t, fr(:,i), (t(end)-t(1)).*gam + t(1))'.*sqrt(gam_dev');
end

%% Training and test set

f_train = frr(:,1:10);
f_test = frr(:,11:20);
y_train = yr(1:10);
y_test = yr(11:20);


%% Elastic regression

% Estimation

[h, beta, cost] = Elastic_Regression(f_train, t, B, y_train, 20, 'poly1');

% Prediction

[M, N] = size(f_test);
yhat = h(MapC_to_y_pred(N, beta, t, f_test))';

