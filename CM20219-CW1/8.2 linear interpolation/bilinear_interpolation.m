clear all;
close all;

source = im2double(imread('mona.jpg'));
target = zeros(size(source));

T = [1 0 -size(source, 2) / 2; 0 1 -size(source, 1) / 2; 0 0 1];
t = pi / 5;
R = [cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1];
S = [5 0 0; 0 5 0; 0 0 1];

% The warping transformation (rotation + scale about an arbitrary point).
M = inv(T) * R * S * T;

% The forward mapping loop: iterate over every source pixel.
for y = 1:size(target, 1)
    for x = 1:size(target, 2)

        % Transform source pixel location (round to pixel grid).
        p = [x; y; 1];
        q = inv(M) * p;
        u = q(1);%x
        v = q(2);%y
        uR = round(q(1) / q(3));%x
        vR = round(q(2) / q(3));%y

        % Check if target pixel falls inside the source domain. 
        if (u > 0 && v > 0 && u <= size(source, 2) && v <= size(source, 1)) 
        
            %linear interpolation
            bottomV = floor(v);
            bottomU = floor(u);

            topV = ceil(v);
            topU = ceil(u);

            f1 = source(bottomV, bottomU, :);
            f2 = source(bottomV, topU, :);
            f3 = source(topV, bottomU, :);
            f4 = source(topV, topU, :);

            alpha = u - bottomU;
            beta = v - bottomV;

            f12 = (1-alpha)*f1 + alpha*f2;
            f34 = (1-alpha)*f3 + alpha*f4;
            f1234 = (1-beta)*f12 + beta*f34;

            target(y, x, :) = f1234;
        end
        
    end
end

imshow([source target]);