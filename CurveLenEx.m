function output = CurveLenEx(embedspace,IDX,C)
numcluster = size(C,1);
output = 0;
for i = 1:numcluster
    dots = embedspace(IDX==i,:);
    center = C(i,:);
    inner = dots*center';
    output = output+sum(inner);
end
