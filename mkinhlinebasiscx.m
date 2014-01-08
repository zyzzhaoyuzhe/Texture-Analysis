function basiscx = mkinhlinebasiscx(sigma, sep, curvsgn)

f = @nthdofg;

args1 = struct('sigma', sigma, 'n', 1);

bases = struct( ...
  'f', f, ...
  'args', args1, ...
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