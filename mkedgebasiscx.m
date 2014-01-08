function basiscx = mkedgebasiscx(sigma, sep)

f = @nthdofg;

args1 = struct('sigma', sigma, 'n', 1);
args2 = struct('sigma', sigma, 'n', 2);
args3 = struct('sigma', sigma, 'n', 4);

bases = [
  struct('f', f, 'args', args1, 'balanced', true, 'scale', 1, 'offset', 0);
	struct('f', f, 'args', args2, 'balanced', true, 'scale', 1, 'offset', sep);
	struct('f', f, 'args', args2, 'balanced', true, 'scale', -1, 'offset', -sep);
	struct('f', f, 'args', args3, 'balanced', true, 'scale', -1, 'offset', sep);
	struct('f', f, 'args', args3, 'balanced', true, 'scale', 1, 'offset', -sep)
];

size = floor(6*sigma + 2*sep + 1);

bases = ([
  normalizebasis(bases(1), size);
  normalizebasis(bases(2), size);
  normalizebasis(bases(3), size);
  normalizebasis(bases(4), size/sqrt(2));
  normalizebasis(bases(5), size/sqrt(2));
]);

bases = normalizereduction(bases, size);

basiscx.bases = bases;
basiscx.size = size;
basiscx.combf = @combnormal;
basiscx.combtype = 'lland';