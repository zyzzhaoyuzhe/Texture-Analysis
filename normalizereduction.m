function bases = normalizereduction(bases, ksize)

nbs = length(bases);

halfsize = floor(ksize/2);
evalpoints = -halfsize:halfsize;

if nbs > 1
  sums = zeros(1, length(evalpoints));
  for i = 1:nbs
    sums = sums + evalbasis(bases(i), evalpoints);
  end

  possum = sum(sums(sums > 0)); % This one lives in the Eastern Hemisphere
  negsum = sum(sums(sums < 0));

  scale = nbs/max(possum, -negsum);

  for i = 1:nbs
    bases(i).scale = scale*bases(i).scale;
  end
else % There is no summing across the different basis elements, so for speed:
  vals = evalbasis(bases(1), evalpoints);
  scale = 1/max(sum(vals(vals > 0)), -sum(vals(vals < 0)));
  bases(1).scale = scale*bases(1).scale;
end