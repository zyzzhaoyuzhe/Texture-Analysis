function basiscx = mkinhedgebasiscx(sigma, sep, curvsgn)

f = @nthdofg;

args2 = struct('sigma', sigma, 'n', 2);

bases = struct( ...
  'f', f, ...
  'args', args2, ...
  'balanced', true, ...
  'scale', sign(-curvsgn)*1, ...
  'offset', sign(-curvsgn)*sep ...
);

size = floor(6*sigma + 2*sep + 1);

bases = normalizereduction(normalizebasis(bases, size), size);

basiscx.bases = bases;
basiscx.size = size;
basiscx.combf = @combnone;
basiscx.combtype = '';