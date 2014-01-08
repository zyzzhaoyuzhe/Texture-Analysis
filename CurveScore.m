function output = CurveScore(matrix,IDX,C)
score = zeros(length(C),1);
for i = 1:length(C)
    vector = matrix(IDX==i,C(i));
    score(i) = sum(vector);
end
output = sum(score);
end