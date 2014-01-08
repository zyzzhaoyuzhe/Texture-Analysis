function r = llorn(ms, dim, degree, adapt)

if nargin > 3 && adapt
    maxs = max(ms, [], dim);
    degree = degree./maxs;
    repsize = ones(1, dim);
    repsize(dim) = size(ms, dim);
    if dim == 1
        repsize(2) = 1;
    end
    cps = contpart(-ms, repmat(degree, repsize));
    product = repmat(prod(cps, dim), repsize);
    r = sum(ms.*(product + 1 - cps), dim);
else
    repsize = ones(1, dim);
    repsize(dim) = size(ms, dim);
    cps = contpart(-ms, degree);
    product = repmat(prod(cps, dim), repsize);
    r = sum(ms.*(product + 1 - cps), dim);
end