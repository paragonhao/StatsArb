load('database.mat')

% Alpha 3: Long-term Contrarian
% 1/mtbv: book to market ratio
alphaval = ones(1504, 566)./mtbv;
alphaval(isinf(alphaval)) = nan;
% winsorization
alphaval = alphaval - mean(alphaval, 2, 'omitnan');
alphaval = alphaval./std(alphaval, 0, 2, 'omitnan');
alphaval(alphaval > 3) = 3;
alphaval(alphaval < -3) = -3;

% Alpha 4: 
% Assuming 252 trading day per year, 21 trading day per month
% The first available date is day 253
% T-12 month ~ T-1 month return would be return from day 1 to day 231 
alphamom = tri(232:1483, :) ./ tri(1:1252, :)-1;
alphamom = alphamom - mean(alphamom, 2, 'omitnan');
alphamom = alphamom./std(alphamom, 0, 2, 'omitnan');
alphamom(alphamom > 3) = 3;
alphamom(alphamom < -3) = -3;
% To construct T*n matrix, backfill first year's alpha_4 with 0
alphamom = [zeros(252,566); alphamom];

save('last_2_alpha.mat','alphaval','alphamom')
