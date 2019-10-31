mu  = 50000000;
lambda = 15000000;
T = size(tri,1);
n = size(tri,2);
w = zeros(n, 1); % initial position
trade = zeros(T, n); % trade
back_weight = zeros(T, n); % backtest position
daily_pnl = zeros(T, 1); % p&l for every day
r_star = 300000;

dates = datetime(myday,'InputFormat','dd-MMM-yyyy');

tcost(isnan(tcost)) = 0;

% optimisation
options = optimset('Algorithm', 'interior-point-convex');
options = optimset(options, 'Display', 'iter');
t0 = 246; % start trading on 2nd Jan 1998



for i = t0: (T-1)
   idx = find(isactivenow(i, :)==1);
   S = cov(retMat(i-t0+2:i, idx), 'omitrows');
   
   target = mean(diag(S), 'omitnan') * eye(length(idx));
   
   shrink_order = (dates(i).Year-1998) * 12 + dates(i).Month;
   hat_beta = shrink(shrink_order);
   hat_sigma = (1 - hat_beta) * target + hat_beta * S;
   
   H = 2 * mu * [hat_sigma -hat_sigma; -hat_sigma hat_sigma];
   g = [2 * mu * hat_sigma * w(idx) - alphablend(i, idx)' + lambda * tcost(i, idx)'; ...
       -2 * mu * hat_sigma * w(idx) + alphablend(i, idx)' + lambda * tcost(i, idx)'];
   
   A = [rho(idx, :)' -rho(idx, :)'; -rho(idx, :)' rho(idx, :)'];
   
   b = [r_star * ones(40,1) - rho(idx, :)' * w(idx); r_star*ones(40,1) + rho(idx, :)' * w(idx)];

   C = [mktbeta(shrink_order,idx) -mktbeta(shrink_order,idx)];
   d = mktbeta(shrink_order,idx) * w(idx);
   
   LB = zeros(2 * length(idx),1);
   theta = min(volume(i,idx) * 0.01, 150000);
   pie = min(10 * theta, 0.025 * 50000000);
   UB = [max(0, min(theta', pie' - w(idx))); max(0, min(theta', pie' + w(idx)))];
   
   [u, fval, exitflag, output] = quadprog(H, g, A, b, C, d, LB, UB, [], options);
   
   y = u(1:length(idx));
   z = u(length(idx)+1:end); 
   
   yy = zeros(n,1);
   zz = zeros(n,1);
   
   trade(i+1, :) = (yy-zz);
   
   w = w .* (1 + fillmissing(retMat(i, :), 'constant', 0)') + trade(i+1,: )';
   back_weight(i+1, :) = w';
   daily_pnl(i+1) = sum(back_weight(i+1, :) .* retMat(i+1, :), 'omitnan') - ...
        sum(trade(i+1, :) .* tcost(i+1, :), 'omitnan');
   
end 