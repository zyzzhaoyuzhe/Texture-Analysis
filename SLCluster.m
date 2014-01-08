function [C,L] = SLCluster(matrix,thr)
%% single-linkage hierachic clustering
nedge = size(matrix,1);
P = matrix;

D = diag(matrix);
D = repmat(D,1,nedge);
D = D';
P = P./D;
P = P-diag(diag(P));
% eleminate the special edge
temp = sum(P,2);
numrow = find(temp == (nedge-1));
P(numrow,:) = 0;

E = cell(nedge,1);
for i = 1:nedge
    E{i} = i;
end
G = 1:nedge;

C = 1:nedge;
C = C(:);
count = 0;

while count==0||L(end)>thr
    M = max(max(P));
    count = count+1;
    L(count) = M;
    [IX,IY] = find(P==M);
    IX = IX(1);
    IY = IY(1);
    if IX>IY
        C(E{IY}) = G(IX);
        g = G(IX);
    else
        C(E{IX}) = G(IY);
        g= G(IY);
    end
    RI = P(IX,:);
    RJ = P(IY,:);
    CI = P(:,IX);
    CJ = P(:,IY);
    Rmax = max(RI,RJ);
    Cmax = min(CI,CJ);
    Rmax([IX,IY]) = [];
    Cmax([IX,IY]) = [];
    Cmax = [Cmax;0];
    
    P([IX,IY],:) = [];
    P(:,[IX,IY]) = [];
    P(end+1,:) = Rmax;
    P(:,end+1) = Cmax;
    
    G([IX,IY]) = [];
    G(end+1) = g;
    
    E{end+1} = [E{IX},E{IY}];
    E([IX,IY]) = [];
end
temp = unique(C);
for i = 1:length(temp)
    C(C==temp(i)) = i;
end
end

