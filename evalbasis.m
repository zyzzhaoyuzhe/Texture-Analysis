function result = evalbasis(basis, x)

x = x - basis.offset;
result = basis.scale*basis.f(x, basis.args);