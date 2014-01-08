function d = angmod(t, r)

d = mod(t, r);
d = (d ~= r/2).*(d - (d > r/2).*r) + (d == r/2).*(sign(t).*d);