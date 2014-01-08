function bts = mkstabbasiscx(combtype, sigma, n, degree, stabilizer)

partpnts = computeinitoppartpnts(sigma, n);

bases = repmat( ...
  struct('f', @stabpart, 'balanced', false, 'offset', 0, 'scale', 1), n, 1 ...
);

size = floor(6*sigma + 1);

for i = 1:n
  bases(i).args = struct( ...
    'sigma', sigma, 'n', n, 'degree', degree, ...
    'stabilizer', stabilizer, 'partpnts', partpnts, 'parti', i ...
  );
  bases(i) = normalizebasis(bases(i), size);
end


bts.bases = bases;
bts.size = size;
bts.combf = @combtangential;
bts.combtype = combtype;