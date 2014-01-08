function [grating] = buildgrating(orientation, period, phase, sigma, ...
    xwidth, ywidth, gamma)
orientation = wrapTo2Pi(orientation);
if (nargin < 6)
    ywidth = xwidth;
    gamma = .5;
end
if (nargin < 7)
    gamma = 1;
end
[x,y] = meshgrid(-xwidth:xwidth, -ywidth:ywidth);
olddims = size(x);
% if ((orientation < pi/4) || ((orientation > 3*pi/4) && (orientation < 5*pi/4)) ...
%         || (orientation > 7*pi/4))
%     d = 1/cos(orientation)*x;
% else
%     d = 1/sin(orientation)*y;
% end
r = [cos(orientation) sin(orientation); -sin(orientation) cos(orientation)]*[x(:) y(:)]';
xp = reshape(r(1,:), olddims);
yp = reshape(r(2,:), olddims);
grating = .5*sin(xp*2*pi/period + phase).*exp(-(xp.^2 + gamma*yp.^2)/(2*sigma^2));