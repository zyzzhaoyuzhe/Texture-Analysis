function Savesparse(image_edgemap,filename)
    N = size(image_edgemap);
    output = cell(N);
    for i = 1:N
        temp = image_edgemap{i};
        s = size(temp,1);
        temp = orisuppression(temp);
        temp = reshape(temp,s,[]);
        temp = sparse(temp);
        output{i} = temp;
    end
    image_edgemap = output;
    save(filename,'image_edgemap','-v7.3');
end