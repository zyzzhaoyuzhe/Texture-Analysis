function [IDX,C,U] = SPCluster(matrix,numclusters)
%% Spectral Clustering II
% P is the original affinity matrix, P is supposed to be SPD. This cluster
% is by random walk on the graph
nrow = size(matrix,1);

temp = sum(matrix,1);
temp = repmat(temp,nrow,1);
matrix = matrix./temp;
[U,D] = eig(matrix);
k = 4;
U = U(:,2:k);
[IDX,C] = kmeans(U,numclusters,'replicates',10);
end
