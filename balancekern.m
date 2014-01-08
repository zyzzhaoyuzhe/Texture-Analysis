function kern = balancekern(kern, norm)

if nargin < 2
  norm = false;
end

possum = sum(kern(kern > 0));
negsum = -sum(kern(kern < 0));

if norm && possum > 0
  kern(kern > 0) = norm*kern(kern > 0)/possum;
end

if negsum > 0
  if norm
    kern(kern < 0) = norm*kern(kern < 0)/negsum;
  else
    kern(kern < 0) = kern(kern < 0)*possum/negsum;
  end
end