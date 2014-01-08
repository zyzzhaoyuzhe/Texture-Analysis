function output = InverseThirdOrderEmbed(coordinate,dimension,embededspace,edgepick)
coordinate = coordinate(:,dimension);
len = size(coordinate,1);
temp = embededspace(:,dimension);
temp1 = 1:(11*11*8);
temp1 = temp1(:);
index = temp1(edgepick == 1);
for i = 1:len
    row_num = find(temp == coordinate(i));
    if isempty(row_num)
        display('empty');
        pause;
    elseif length(row_num)>1
        display('more than one point');
        pause;
    end
    ori = ceil(index(row_num)/121);
    pos = mod(index(row_num),121);
    col = ceil(pos/11);
    row = mod(pos,11);
    output(i,:) = [row,col,ori];
end
end