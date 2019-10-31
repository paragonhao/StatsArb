indus=[];
for i=1:566
    indus=[indus;allstocks(i).industrylist(1).industry];    
end
indusList = unique(cellstr(indus));
rho = zeros(566,40);

for i=1:566
    [~,idx]=ismember(cellstr(allstocks(i).industrylist(1).industry),indusList);
    rho(i,idx) =1;
end



% find arithmetic return
tri_T = size(tri,1);
retMat = tri(2:tri_T,:)./tri(1:(tri_T-1),:) - 1;

% short-term contrarian
T = size(retMat, 1);
n = size(retMat, 2);
alpharev_raw = zeros(tri_T, n);

triDecay = zeros(1,21);
for i = 0:20 
    triDecay(1,i+1) = (1/11) - (1/231) * i;
end

triDecay = flip(triDecay);

% for each column
for i = 1:n
    % for each row starting from 21
    window = 20;
    for j = 21:T
        alpharev_raw((j+1),i) = -1 * sum(triDecay * retMat((j-20):j,i) , 'omitnan');
    end
end

alpharev_raw = alpharev_raw * (eye(n) - rho * inv(transpose(rho) * rho) * transpose(rho));


% demean 
alpharevcxmean = mean(alpharev_raw, 2,'omitnan');
X_rev = alpharev_raw - alpharevcxmean;

% standardize 
alpharev = X_rev ./ std(X_rev, 0, 2, 'omitnan');
alpharev(alpharev > 3) = 3;
alpharev(alpharev < -3) = -3;


% SHORT-TERM PROCYCLICAL
alpharec_raw = zeros(tri_T, n);
triDecayAlpharec = zeros(1,45);

for i = 0:44 
    triDecayAlpharec(1,i+1) = (1/23) - (1/1035) * i;
end

triDecayAlpharec = flip(triDecayAlpharec);

% for each column
for i = 1:n
    % for each row starting from 21
    window = 44;
    for j = 45:T
        alpharec_raw((j+1),i) = -1 * sum(triDecayAlpharec * retMat((j- 44):j,i) , 'omitnan');
    end
end

% demean 
alpharecCXmean = mean(alpharec_raw, 2,'omitnan');
X_rec = alpharec_raw - alpharecCXmean;

% standardize
alpharec = X_rec ./ std(X_rec, 0, 2, 'omitnan');
alpharec(alpharec > 3) = 3;
alpharec(alpharec < -3) = -3;













