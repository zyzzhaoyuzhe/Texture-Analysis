function [gxy gth gk gtr] = ...
  gj(xyd, td, kd, transd, sxy, sth, sk, str)

gxy = gaussian(xyd, sxy, false);
gth = gaussian(td, sth, false);
gk = gaussian(kd, sk, false);
gtr = gaussian(transd, str, false);
