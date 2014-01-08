function r = gaussian(x, s, normarea)

if normarea
  r = exp(-x.*x./(2*s.^2))./(sqrt(2*pi).*s);
else
  r = exp(-x.*x./(2*s.^2));
end