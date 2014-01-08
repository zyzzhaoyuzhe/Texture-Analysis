function r = contpart(x, degree)

if isstruct(degree)
  degree = degree.degree;
end

fins = isfinite(degree);

invdegs = 1./degree;
x = x + invdegs/2;

if length(degree) == 1;
  if fins
    r = degree.*x.*(x >= 0 & x <= invdegs) + (x > invdegs);
  else
    r = (x == 0)*0.5 + (x > 0);
  end
  return;
end

finxs = x(fins);
infxs = x(~fins);
fininvdegs = invdegs(fins);

r = zeros(size(x));
r(~fins) = (infxs == 0)*0.5 + (infxs > 0);
r(fins) = ...
  degree(fins).*finxs.*(finxs >= 0 & finxs <= fininvdegs) + ...
  (finxs > fininvdegs);