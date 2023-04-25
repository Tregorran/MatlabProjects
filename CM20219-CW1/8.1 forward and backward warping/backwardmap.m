clear all;
close all;

source = im2double(imread('mona.jpg'));
target = zeros(size(source));

T = [1 0 -size(source, 2) / 2; 0 1 -size(source, 1) / 2; 0 0 1];
t = pi / 5;
R = [cos(t) -sin(t) 200; sin(t) cos(t) 200; 0 0 1];
S = [3 0 0; 0 3 0; 0 0 1];

% The warping transformation (rotation + scale about an arbitrary point).
M = inv(T) * R * S * T;

% The forward mapping loop: iterate over every source pixel.
for y = 1:size(target, 1)
    for x = 1:size(target, 2)

        % Transform source pixel location (round to pixel grid).
        p = [x; y; 1];
        q = inv(M) * p;
        u = round(q(1) / q(3));%x
        v = round(q(2) / q(3));%y
       
        % Check if target pixel falls inside the image domain. 
        if (u > 0 && v > 0 && u <= size(source, 2) && v <= size(source, 1)) 
            % Sample the target pixel colour from the source pixel.   
            target(y, x, :) = source(v, u, :);
        end
        
    end
end

imshow([source target]);