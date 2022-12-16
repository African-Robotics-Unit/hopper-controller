len = 50;
X = linspace(-0.4,0.4,len);
Y = linspace(-0.4,0,len);

Z = zeros(len,len);

for i = 1:len
    for j = 1:len
        x = X(i);
        y = Y(j);
        try
            [thetaR,thetaL] = inv_cartesian(x,y);
%             F = transpose(J_polar(lf,lt,thetaL,thetaR)) * [-50;0];
%             Z(j,i) = F(1);
%             Z(j,i) = det(transpose(J_polar(lf,lt,thetaL,thetaR)));
            F = inv(transpose(J_polar(thetaL,thetaR))) * [-12;12];
            Z(j,i) = -F(1);
        catch
            Z(j,i) = nan;
        end
    end
end
contour(X,Y,Z, 'Fill','on','LevelStep',10)
zlim([0 300])
caxis([0 300])
c = colorbar;
c.Label.String = 'Radial Force (N)';
pbaspect([0.5 1])