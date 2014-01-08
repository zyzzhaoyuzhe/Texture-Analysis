function plotkprof(opfam, ktest, degree, adapt, ndivs)

range = 0.5;
divsize = range/ndivs;

excresps = zeros(1, ndivs + 1);
inhresps = zeros(1, ndivs + 1);

kin = opfam.kin;
abski = abs(ktest - opfam.params.nabsks) + 1;
ispos = ktest > opfam.params.nabsks;

imsize = 41;
crow = ceil(imsize/2);
ccol = ceil(imsize/2);

for i = 1:ndivs + 1
  k = -range/2 + (i - 1)*divsize;
  if strcmpi(opfam.params.type, 'edge')
    image = drawktest('edge', 0, k, 1 - 2*(k < 0), 2, imsize, 'default');
  else
    image = drawktest('line', 0, k, 0, 2, imsize, 'default');
  end
  
  if ktest == opfam.params.nabsks
    excresp = execopset(image, kin(1).exc, degree, adapt);
  else
    excresp = execopset(image, kin(1,abski).exc, degree, adapt);
    if ispos
      inhresp = execopset(image, kin(1,abski).poskinh, degree, adapt);
    else
      inhresp = execopset(image, kin(1,abski).negkinh, degree, adapt);
    end
    
    inhresps(i) = inhresp(crow,ccol);
  end

  excresps(i) = excresp(crow,ccol);
end

totresps = halfrect(excresps) - halfrect(inhresps);

xdata = -range/2:divsize:range/2;

plot(xdata, totresps);
hold on;
plot(xdata, excresps, 'LineStyle', '--');
plot(xdata, inhresps, 'LineStyle', ':');
xlim([-.25 .25]);
ylim([0 3]);
grid on;
hold off;