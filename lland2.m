function r = lland2(m1, m2, degree, adapt)

if nargin > 3 && adapt
    maxs = max(m1, m2);
    degree = degree./maxs;
end

cpx = contpart(m1, degree);
cpy = contpart(m2, degree);
r = m1.*(1 - cpx.*(1 - cpy)) + m2.*(1 - cpy.*(1 - cpx));