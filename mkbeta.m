
% ewmktportfolio
ewmarket_portfolio = mean(tri, 2, 'omitnan');


% part 2 risk model 
y = datetime(myday,'InputFormat','dd-MMM-yyyy');
mon = month(y);
lagmon = lagmatrix(mon,1);
firstday = mon - lagmon;
index = find(firstday == 1 | firstday == -11 | isnan(firstday));

startIdx = index(13);
yrInterval = 12;
shrink = zeros(60,1);
shrinkIdx = 1;

totalret = [zeros(1,n);retMat];

for i = 13:length(index)
    % find out the active stock based on the first day of the current month
    past_1y = totalret(index(i - yrInterval):index(i),:);
    ewmarket_portfolio(index(i - yrInterval):index(i),:);
end








