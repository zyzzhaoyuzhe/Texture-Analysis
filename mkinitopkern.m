function kernel = mkinitopkern(dir, bn, bt, ksize)

cosr = cos(dir);
sinr = sin(dir);

halfksize = floor(ksize/2);
[xs, ys] = meshgrid(-halfksize:halfksize, -halfksize:halfksize);

kernel = evalbasis(bt, cosr*xs - sinr*ys).*evalbasis(bn, sinr*xs + cosr*ys);