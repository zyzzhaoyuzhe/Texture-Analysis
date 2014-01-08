function partpnts = computeinitoppartpnts(sigma, n)

resolution = 400;
fullrange = 20;
halfrange = fullrange/2;

partialsums = zeros(1, resolution);

sum = 0;
for i = 1:resolution
  sum = sum + nthdofg(fullrange*(i - 1)/resolution - halfrange, 0, sigma);
  partialsums(i) = sum;
end
partialsums = partialsums/sum;

partpnts = zeros(n - 1, 1);

parti = 1;
target = parti/n;
for i = 1:resolution - 1
  if partialsums(i) <= target && partialsums(i + 1) > target
    x0 = fullrange*(i - 0.5)/resolution - halfrange;
    x1 = fullrange*(i + 0.5)/resolution - halfrange;
    y0 = partialsums(i) - target;
    y1 = partialsums(i + 1) - target;

    partpnts(parti) = (x1*y0 - x0*y1)/(y0 - y1);

    if parti >= n - 1
      break;
    end

    parti = parti + 1;
    target = parti/n;
  end
end
