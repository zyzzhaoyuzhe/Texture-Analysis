function output = discreteline(patchsize,centerpoint,degree)
%%degree is ranging for [0,pi)
x0 = centerpoint(1);
y0 = centerpoint(2);
output = zeros(patchsize,patchsize);
output(x0,y0) = 1;
degree = mod(degree,pi);
if degree == pi/2
    output(1:patchsize,y0) = 1;
elseif degree == 0;
    output(x0,1:patchsize) = 1;
elseif degree>=1/4*pi && degree<=3/4*pi
    for x = 1:patchsize
        dx = x0-x;
        dy = dx/tan(degree);
        ycal = y0+dy;
        ycal = round(ycal);
        if ycal>=1 && ycal<=patchsize
            output(x,ycal) = 1;
        end
    end
else
    for y = 1:patchsize
        dy = y-y0;
        dx = dy*tan(degree);
        xcal = x0-dx;
        xcal = round(xcal);
        if xcal>=1 && xcal<=patchsize
            output(xcal,y) = 1;
        end
    end
end
end
