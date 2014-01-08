function output = nonmaxsuppression(patch,direction)
% Local non-maxima suppression

output = patch;
patchsize = size(patch,1);

% Local non-maxima suppression
orthdirection = direction+pi/2;
if orthdirection == 0
    for x = 1:patchsize
        mask = discreteline(patchsize,[x,1],orthdirection);
        temp = output.*mask;
        maximum = max(max(temp));
        temp(temp<maximum) = 0;
        output = output.*(1-mask)+temp;
    end
else
    for y = 1:patchsize
        mask = discreteline(patchsize,[1,y],orthdirection);
        temp = output.*mask;
        maximum = max(max(temp));
        temp(temp<maximum) = 0;
        output = output.*(1-mask)+temp;
    end
end
end
