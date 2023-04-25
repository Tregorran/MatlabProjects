clear all;
close all;

source = im2double(imread('parade1.bmp'));
target = im2double(imread('parade2.bmp'));
rightImage = target;

load mymatrix;
M = H;

[imageHeight, imageWidth, imageDepth] = size(source);

newLeft = zeros(imageHeight, imageWidth, 3);

% The forward mapping loop: iterate over every source pixel.
for y = 1:size(target, 1)
    for x = 1:size(target, 2)

        % Transform source pixel location (round to pixel grid).
        p = [x; y; 1];
        q = inv(M) * p;
        u = round(q(1) / q(3));
        v = round(q(2) / q(3));
             
        
        % Check if target pixel falls inside the image domain. 
        if (u > 0 && v > 0 && u <= size(source, 2) && v <= size(source, 1)) 
            % Sample the target pixel colour from the source pixel.   
            target(y, x, :) = source(v, u, :);
            newLeft(y,x, :) = source(v, u, :);
        end
        
    end
end

subplot(221); imshow(source); title('Left image');
subplot(222); imshow(newLeft); title('New left image');
subplot(223); imshow(rightImage); title('Right image');
subplot(224); imshow(target); title('New image');