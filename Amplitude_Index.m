function [h, c_hat, cost] = Amplitude_Index(f, t, B, y0, MaxIter, b, link)

J = size(B,2);
n = size(f, 2);

%fx = 0;
% A = 0;
% B = 0;
c_hat = b;
cost = 10000;
iter = 0;
tol = 0.0001;
while iter < MaxIter
    iter = iter +1
    y = c_hat(1) + MapC_to_y(n,c_hat(2:J+1),B,t,f);
    h = fit(y', y0', link);
    %rng(1)
    options = optimoptions(@fminunc,'Display','iter', 'Algorithm','quasi-newton');
    fun = @(c)MyLogLikelihoodFn2(c,y0,n,B,t,f,h);
    [c_hatt,val, exitflag, output] = fminunc(fun,b,options); % b or c_hat
    if (cost - val)^2 < tol
        cost = val;
        c_hat = c_hatt;
        break
    end
cost = val;
c_hat = c_hatt;
%if cost >val
%cost = val;
%c_hat = c_hatt;
%else
%c_hat = c_hat;
end



%     % Plotting fitted line
%     yy = c_hat(1) + MapC_to_y(n,c_hat(2:J+1),B,t,f,q);
%     gg = [yy' y'];
%     ggg = sortrows(gg);
%     figure(iter*100)
%     plot(ggg(:,1), ggg(:,2), '*', 'linewidth',2)
%     hold on;
%     hh = plot(h, yy', y' )
%     set(hh, 'LineWidth',2)

    
%     tol = (fx - val).^2;
%     if tol < 0.1;
%         break;
%     else
%         fx = val;
%     end;
end


% function [h, c_hat, cost] = Amplitude_Index(f, t, B, y0, MaxIter, b, link)
% 
% J = size(B,2);
% n = size(f, 2);
% 
% %fx = 0;
% % A = 0;
% % B = 0;
% c_hat = b;
% cost = 10000;
% iter = 0;
% tol = 0.0001;
% while iter < MaxIter
%     iter = iter +1
%     y = c_hat(1) + MapC_to_y(n,c_hat(2:J+1),B,t,f);
%     h = fit(y', y0', link);
%     %rng(1)
%     options = optimoptions(@fminunc,'Display','iter', 'Algorithm','quasi-newton');
%     fun = @(c)MyLogLikelihoodFn2(c,y0,n,B,t,f,h);
%     [c_hatt,val, exitflag, output] = fminunc(fun,b,options); % b or c_hat
%     if (cost - val)^2 < tol
%         cost = val;
%         c_hat = c_hatt;
%         break
%     else
%         cost = val;
%         c_hat = c_hatt;
%     end
% 
% 
% %     % Plotting fitted line
% %     yy = c_hat(1) + MapC_to_y(n,c_hat(2:J+1),B,t,f,q);
% %     gg = [yy' y'];
% %     ggg = sortrows(gg);
% %     figure(iter*100)
% %     plot(ggg(:,1), ggg(:,2), '*', 'linewidth',2)
% %     hold on;
% %     hh = plot(h, yy', y' )
% %     set(hh, 'LineWidth',2)
% 
%     
% %     tol = (fx - val).^2;
% %     if tol < 0.1;
% %         break;
% %     else
% %         fx = val;
% %     end;
% end

% function [h, c_hatt, val] = Amplitude_Index(f, t, B, y0, MaxIter, b, link)
% 
% J = size(B,2);
% n = size(f, 2);
% 
% %fx = 0;
% % A = 0;
% % B = 0;
% c_hat = b;
% for iter = 1:MaxIter
%     iter
%     y = c_hat(1) + MapC_to_y(n,c_hat(2:J+1),B,t,f);
%     h = fit(y', y0', link);
%     %rng(1)
%     options = optimoptions(@fminunc,'Display','iter', 'Algorithm','quasi-newton');
%     fun = @(c)MyLogLikelihoodFn2(c,y0,n,B,t,f,h);
%     [c_hatt,val, exitflag, output] = fminunc(fun,rand(J+1,1),options); % b or c_hat
%     c_hat = c_hatt;
% %     % Plotting fitted line
% %     yy = c_hat(1) + MapC_to_y(n,c_hat(2:J+1),B,t,f,q);
% %     gg = [yy' y'];
% %     ggg = sortrows(gg);
% %     figure(iter*100)
% %     plot(ggg(:,1), ggg(:,2), '*', 'linewidth',2)
% %     hold on;
% %     hh = plot(h, yy', y' )
% %     set(hh, 'LineWidth',2)
% 
%     
% %     tol = (fx - val).^2;
% %     if tol < 0.1;
% %         break;
% %     else
% %         fx = val;
% %     end;
% end


