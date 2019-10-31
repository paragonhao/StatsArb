

% alpha_sum = 0.50 .* a1_windsorized + 0.25 .* a2_windsorized + 0.15 .*
% a3_windsorized + 0.10 .* a4_windsorized;

alpah_sum = 0.50 .* alpharev + 0.25 * alpharec + 0.15 * alphaval + 0.1 * alphamom;

% demean 
alpah_sum_mean = mean(alpah_sum, 2,'omitnan');
X_blend = alpah_sum - alpah_sum_mean;

% standardize
alphablend = X_blend ./ std(X_blend, 0, 2, 'omitnan');
alphablend(alphablend > 3) = 3;
alphablend(alphablend < -3) = -3;

