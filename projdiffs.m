function [xyd td kd transd] = projdiffs(xi, yi, ti, ki, xj, yj, tj, kj, npis)

rotxj = cos(ti).*(xj - xi) + sin(ti).*(yj - yi);
rotyj = cos(ti).*(yj - yi) - sin(ti).*(xj - xi);
rottj = tj - ti;

if kj == 0
  td = angmod(rottj, 2*pi);
  transd = cos(rottj).*rotxj + sin(rottj).*rotyj;
  
  projx = rotxj - cos(rottj)*transd;
  projy = rotyj - sin(rottj)*transd;
else
  rotxjc = rotxj - sin(rottj)./kj;
  rotyjc = rotyj + cos(rottj)./kj;
  angle = atan2(-rotyjc, -rotxjc);
  
  r = abs(1./kj);
  projx = rotxjc + r.*cos(angle);
  projy = rotyjc + r.*sin(angle);
  
  angle = angle + sign(kj).*pi/2;
  td = angmod(angle, 2*pi);
  phi = angmod(angle - rottj, 2*pi);
  transd = -phi./kj;
end

projysigns = sign(projy) + (projy == 0);
xyd = projysigns.*sqrt(projx.^2 + projy.^2);

if npis == 1
  flip = abs(td) > pi/2;
  td(flip) = td(flip) - sign(td(flip))*pi;
  kj = kj.*(~flip - flip);
  transd = transd.*(~flip - flip);
end

kd = kj - ki;