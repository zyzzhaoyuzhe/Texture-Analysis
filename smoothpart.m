%%% args must have field degree

function r = smoothpart(x, degree)

if isstruct(degree)
  degree = degree.degree;
end

fins = isfinite(degree);

r = zeros(size(x));

if length(degree) == 1;
  if fins
    x = degree.*x;
    p = (x >= 0.5);
    q = (x > -0.5 & x < 0.5);
    temp = f(0.5 + x);
    r = p + (temp./(temp + f(0.5 - x))).*q;
  else
    r = (x == 0)*0.5 + (x > 0);
  end
  return;
end

infxs = x(~fins);
r(~fins) = (infxs == 0)*0.5 + (infxs > 0);

finxs = degree(fins).*x(fins);
p = (finxs >= 0.5);
q = (finxs > -0.5 & finxs < 0.5);
temp = f(0.5 + finxs);
r(fins) = p + (temp./(temp + f(0.5 - finxs))).*q;

function r = f(x)

r = exp(-1./x);
r(~isfinite(r)) = 0;