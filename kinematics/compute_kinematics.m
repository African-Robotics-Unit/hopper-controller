% constants
w = 0.1; % hip spacing
lf = 0.125; lt = 0.250; % link lengths

% Foot/Ankle Kinematics
% ball foot
% la.x = 0.030; la.y = 0.0;
% hybrid
 la.x = 0.080; la.y = 0.110;
% la.x = 0.080; la.y = 0.116;
% j foot
% la.x = 0.098; la.y = 0.112;
% c foot
% la.x = 0.110; la.y = 0.055;

% forward cartesian
syms thetaL thetaR
hip.l.x = -0.5*w; hip.r.x = 0.5*w;
hip.l.y = 0; hip.r.y = 0;
knee.l.x = hip.l.x + lf*cos(thetaL);
knee.l.y = hip.l.y + lf*sin(thetaL);
knee.r.x = hip.r.x + lf*cos(thetaR);
knee.r.y = hip.r.y + lf*sin(thetaR);
R2 = (knee.r.x - knee.l.x)^2 + (knee.r.y - knee.l.y)^2;
ankle.x = 0.5*(knee.r.x + knee.l.x) - 0.5*sqrt(4*lt^2/R2-1)*(knee.l.y - knee.r.y);
ankle.y = 0.5*(knee.r.y + knee.l.y) - 0.5*sqrt(4*lt^2/R2-1)*(knee.r.x - knee.l.x);
alpha = atan2(real(ankle.y-knee.r.y), real(ankle.x-knee.r.x));
foot.x = ankle.x + la.x*cos(alpha) + la.y*cos(alpha+(pi/2));
foot.y = ankle.y + la.x*sin(alpha) + la.y*sin(alpha+(pi/2));

ankle.r = sqrt(ankle.x^2 + ankle.y^2);
ankle.phi = atan2(ankle.y, ankle.x);

matlabFunction(foot.x, foot.y, 'File', 'fwd_cartesian');

% forward polar
foot.r = sqrt(foot.x^2 + foot.y^2); % to keep legs in similar configuration
foot.phi = atan2(foot.y, foot.x);
matlabFunction(foot.r, foot.phi,'File','fwd_polar');

% polar jacobian
J = jacobian([ankle.r, ankle.phi], [thetaL,thetaR]);
matlabFunction(real(J),'File','J_polar');

% cartesian jacobian
J = jacobian([ankle.x, ankle.y], [thetaL,thetaR]);
matlabFunction(real(J),'File','J_cartesian');

% test plot
thetaL = -pi;
thetaR = 0;

rightLeg.x = [hip.r.x, knee.r.x, ankle.x, foot.x];
rightLeg.y = [hip.r.y, knee.r.y, ankle.y, foot.y];
leftLeg.x = [hip.l.x, knee.l.x, ankle.x];
leftLeg.y = [hip.l.y, knee.l.y, ankle.y];

plot(eval(rightLeg.x), eval(rightLeg.y))
hold on
plot(eval(leftLeg.x), eval(leftLeg.y))
hold off
daspect([1 1 1])
