function [thetaR,thetaL] = inv_cartesian(x,y)
%INVERSE_CARTESIAN Summary of this function goes here
%   Converts a cartesian coordinate to required motor angles

% constants
lf = 0.146; lt = 0.25;
w = 0.1; % lengths

% inverse cartesian
c.R = sqrt((x-0.5*w)^2 + y^2);
c.L = sqrt((x+0.5*w)^2 + y^2);

alpha.R = real(acos((w^2+c.R^2-c.L^2)/(2*w*c.R)));
alpha.L = real(acos((w^2+c.L^2-c.R^2)/(2*w*c.L)));

assert(((0<alpha.R & alpha.R<pi) & (0<alpha.L & alpha.L<pi)), 'alpha angle out of bounds')

beta.R = real(acos((c.R^2+lf^2-lt^2)/(2*c.R*lf)));
beta.L = real(acos((c.L^2+lf^2-lt^2)/(2*c.L*lf)));

assert(((0.26<beta.R & beta.R<2*pi) & (0.26<beta.L & beta.L<2*pi)), 'knee angle out of bounds')

thetaR = -pi + alpha.R + beta.R;
thetaL = 2*pi - alpha.L - beta.L;

% check if valid
[x_actual,y_actual] = fwd_cartesian(lf,lt,thetaL,thetaR);

assert(((abs(x_actual-x) < 1e-9) & (abs(y_actual-y) < 1e-9)), "forward and inverse solutions don't match")

end

