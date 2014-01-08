function partpnts = computecompatpartpnts(gjhist, ntancs)

partpnts = zeros(1, ntancs - 1);

ksize = length(gjhist);

partsum = zeros(1, ksize);
sum = 0;
for i = 1:ksize
  sum = sum + gjhist(i);
  partsum(i) = sum;
end
partsum = partsum/sum;

for i = 1:ntancs - 1
  target = i/ntancs;
  indx = find(partsum > target, 1);
  trans = indx - ceil(ksize/2);
  partpnts(i) = ...
    trans + 0.5 + ...
    (target - partsum(indx))/ ...
    (partsum(indx) - partsum(indx - 1));
end
