close all;
clear all;

% 2D polygon for Earth: square of 2 by 2 units, in homogeneous coordinates.
earth = [-1 1 1 -1 -1; -1 -1 1 1 -1; 1 1 1 1 1];

% Another 2D polygon for the Moon, made by scaling the earth to 1/4 size
S = [0.25 0 0; 0 0.25 0; 0 0 1];
moon = S * earth;

bS = [0.25 0 0; 0 0.25 0; 0 0 1];
bmoon = bS * earth;

bMoonOrigin = [1 0 0; 0 1 0; 0 0 1];

cS = [0.15 0 0; 0 0.15 0; 0 0 1];
cmoon = cS * earth;

% Set up axes for plotting our animation.
figure;
hold on;
axis equal;
axis([-6 6 -6 6]);


for a = 0:0.01:2 * pi

	% Moon will spin 5 times as fast as the Earth.
	a_moon = 5 * 2*a;
    b_moon = 2 * a;
    c_moon = 1 * a;

	% Rotation matrix for Earth.
	R_earth = [cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1];

	% Rotation matrix for the Moon.
	R_moon = [cos(a_moon) -sin(a_moon) 0; sin(a_moon) cos(a_moon) 0; 0 0 1];
    bR_moon = [cos(b_moon) -sin(b_moon) 0; sin(b_moon) cos(b_moon) 0; 0 0 1];
    cR_moon = [cos(c_moon * 5) -sin(c_moon * 5) 0; sin(c_moon * 5) cos(c_moon * 5) 0; 0 0 1];
    
	% Translation matrix to move the Moon away from Earth
    % (it orbits at a distance of 5 units).
	T_moon = [1 0 5; 0 1 0; 0 0 1];
    bT_moon = [1 0 3; 0 1 0; 0 0 1];
    cT_moon = [1 0 1; 0 1 0; 0 0 1];
    bMoonOrigin = cR_moon;
    bMoonOrigin(1,3) = bT_moon(1,3);
    bMoonOrigin(2,3) = bT_moon(2,3);
    
	% Rotate the Earth.
	p_earth = R_earth * earth;

	% Rotate the moon, then move it 5 units away from the origin.
	p_moon = T_moon * R_moon * moon;
    bp_moon = bT_moon * bR_moon * bmoon;
    cp_moon = cT_moon * cR_moon * cmoon;
    
	% Place the moon in the Earth's reference frame (which is R).    
	p_moon = R_earth^2 * p_moon;
    bp_moon = R_earth * bp_moon;    
    cp_moon = bMoonOrigin * cp_moon;
    cp_moon = R_earth * cp_moon;
  
    
    
	% Draw the earth in blue and the moon in black.
	cla;
	plot(p_earth(1,:), p_earth(2,:), 'b', 'LineWidth', 2);
	plot(p_moon(1,:),  p_moon(2,:),  'k', 'LineWidth', 2);
    plot(bp_moon(1,:),  bp_moon(2,:),  'r', 'LineWidth', 2);
    plot(cp_moon(1,:),  cp_moon(2,:),  'g', 'LineWidth', 2);
	drawnow;

end
