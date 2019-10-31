
% ewmktportfolio
ewmarket_portfolio = mean(retMat, 2, 'omitnan');


% part 2 risk model 
y = datetime(myday,'InputFormat','dd-MMM-yyyy');
mon = month(y);
lagmon = lagmatrix(mon,1);
firstday = mon - lagmon;
index = find(firstday == 1 | firstday == -11 | isnan(firstday));
yrInterval = 12;

totalret = [zeros(1,n);retMat];
mktbeta = [];
for i = 13:length(index)
    % find out the active stock based on the first day of the current month
    past_1y = totalret(index(i - yrInterval):index(i),:);
    past_1y(isnan(past_1y)) = 0;
    
    row = size(past_1y, 1);
    col = size(past_1y, 2);
    
    x = [ones(row,1) ewmarket_portfolio(index(i - yrInterval):index(i),:)];
    beta = inv(transpose(x) * x) * transpose(x) * past_1y;
    mktbeta = [mktbeta;beta(2,:)];
end








