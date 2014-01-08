function [IDX,C] = ProbKmeans(embedspace,numcluster)
%% probability Kmeans
len = size(embedspace,1);
numcluster = min(len,numcluster);
temp = randperm(len,numcluster);
C = embedspace(temp,:);
iteration = 500;
for i = 1:iteration
    temp = embedspace*C';
    maximum = max(temp,[],2);
    temp = bsxfun(@rdivide,temp,maximum);
    temp = (temp == 1);
    IDX = temp*(1:numcluster)';
    % update C
    for j = 1:numcluster
        C(j,:) = mean(embedspace(IDX == j,:),1);
    end
end