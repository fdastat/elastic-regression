function y = MapC_to_y(n,c,B,t,f)

dt = mean(diff(t));

for i=1:n
    bet = B*c;
    gam0 = DynamicProgrammingQ(f(:,i)',bet',0,0);
    gam = (gam0-gam0(1))/(gam0(end)-gam0(1));  % slight change on scale
    
    gam_dev = gradient(gam, dt);
    
    fn(:,i) = interp1(t, f(:,i), (t(end)-t(1)).*gam + t(1))'.*sqrt(gam_dev');
    y(i) = sum(bet.*fn(:,i))*dt;
end
