function r = nthdofg(x, n, s, normarea)

if (isstruct(n))
  s = n.sigma;
  n = n.n;
end

if nargin < 4
  normarea = true;
end

switch n
  case 0
    r = gaussian(x, s, normarea);
  case 1
    r = -gaussian(x, s, normarea).*x./(s.*s);
  case 2
    s2 = s.*s;
    r = gaussian(x, s, normarea).*(x.*x - s2)./(s2.*s2);
  case 3
    s2 = s.*s;
    r = gaussian(x, s, normarea).*x.*(3*s2 - x.*x)./(s2.^3);
  case 4
    x2 = x.*x;
    s2 = s.*s;
    s4 = s2.*s2;
    r = gaussian(x, s, normarea).*(3*s4 - 6*s2.*x2 + x2.*x2)./(s4.*s4);
  otherwise
    error('n > 4 not supported.');
end