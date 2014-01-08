function label = colordots(coordinate,dimension,embededspace,label,color)
coordinate = coordinate(:,dimension);
len = size(coordinate,1);
temp = embededspace(:,dimension);
for i = 1:len
    row_num = find(temp == coordinate(i));
    if isempty(row_num)
        display('empty');
        pause;
    elseif length(row_num)>1
        display('more than one point');
        pause;
    end
    label(row_num) = color;
end
end