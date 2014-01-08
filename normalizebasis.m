function basis = normalizebasis(basis, ksize)

halfsize = floor(ksize/2);
evalpoints = -halfsize:halfsize;

vals = evalbasis(basis, evalpoints);
pos = sum(vals(vals > 0));
if basis.balanced
  basis.scale = basis.scale/pos;
else
  neg = sum(vals(vals < 0));
  basis.scale = basis.scale/(pos + neg);
end