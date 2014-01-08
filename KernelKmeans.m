function [IDX,C] = KernelKmeans(matrix,numcluster)
%% do kernel kmeans
% K is the kernel function
sigma = 1;
K = zeros(size(matrix));
len = size(matrix,1);
for i = 1:len
    for j = 1:len
        % Gaussian Kernel
        K(i,j) = exp(-(norm(matrix(:,i)-matrix(:,j)))^2/2/sigma);
    end
end

numcluster = min(len,numcluster);
C = randperm(len,numcluster);
% Assign a cluster to each vertex
for i = 1:len
    temp = diag(K(C,C));
    temp = temp(:);
    temp = K(i,i)+temp-2*K(C,i);
    [~,IX] = max(temp);
    IDX(i) = IX;
end
iteration = 500;
for i = 1:iteration
    %prepare mc
    mcsquare = zeros(numcluster,1);
    cross = zeros(numcluster,len);
    for j = 1:numcluster
        mcsquare(j) = sum(sum(K(IDX==j,IDX==j)));
        mcsquare(j) = mcsquare(j)/(sum(IDX==j))^2;
        temp = 2*sum(K(:,IDX==j),2)./sum(IDX==j);
        cross(j,:) = temp';
    end
    % update cluster
    for k = 1:len
        temp = K(k,k)-cross(:,k)+mcsquare;
        [~,IX] = max(temp);
        IDX(k) = IX;
    end
end
