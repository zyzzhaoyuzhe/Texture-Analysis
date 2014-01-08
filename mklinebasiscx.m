function basiscx = mklinebasiscx(sigma, sep)

f = @nthdofg;

args1 = struct('sigma', sigma, 'n', 1);
args2 = struct('sigma', sigma/sqrt(2), 'n', 3);

bases = [
  struct('f', f, 'args', args1, 'balanced', true, 'scale', 1, 'offset', sep);
  struct('f', f, 'args', args1, 'balanced', true, 'scale', -1, 'offset', -sep);
  struct('f', f, 'args', args2, 'balanced', true, 'scale', -1, 'offset', sep);
  struct('f', f, 'args', args2, 'balanced', true, 'scale', 1, 'offset', -sep)
];

size = floor(6*sigma + 2*sep + 1);

bases = normalizereduction([
  normalizebasis(bases(1), size);
  normalizebasis(bases(2), size);
  normalizebasis(bases(3), size);
  normalizebasis(bases(4), size);
], size);

basiscx.bases = bases;
basiscx.size = size;
basiscx.combf = @combnormal;
basiscx.combtype = 'lland';