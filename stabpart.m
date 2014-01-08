function r = stabpart(x, n, partpnts, parti, stabilizer, degree, sigma)

if isstruct(n)
  partpnts = n.partpnts;
  parti = n.parti;
  sigma = n.sigma;
  degree = n.degree;
  stabilizer = n.stabilizer;
  n = n.n;
end

degree = degree*sigma;

r = nthdofg(x, 0, sigma);

if parti == 1
  r = r.*smoothpart(partpnts(parti) - x, 1/degree);
elseif parti == n
  r = r.*smoothpart(x - partpnts(parti - 1), 1/degree);
else
  left = smoothpart(x - partpnts(parti - 1), 1/degree);
  right = smoothpart(partpnts(parti) - x, 1/degree);
  r = r.*(left + right - 1);
end

if stabilizer > 0
  if parti == n/2
    r = r + stabilizer*sigma*nthdofg(x, 1, sigma);
  elseif parti == n/2 + 1
    r = r - stabilizer*sigma*nthdofg(x, 1, sigma);
  end
end
