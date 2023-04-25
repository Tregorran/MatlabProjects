clear all;
close all;

image = im2double(imread('window.jpg'));
k = [474.53 0 405.96; 0 474.53 217.81; 0 0 1];
ldc = [-0.27194 0.11517 -0.029859];

fx = k(1,1);
fy = k(2,2);
px = k(1,3);
py = k(2,3);
k1 = ldc(1,1);
k2 = ldc(1,2);
k3 = ldc(1,3);

[imageHeight, imageWidth, imageDepth] = size(image);

newImage = zeros(imageHeight, imageWidth, 3);
%scan through pixels of the image
for v = 1: imageHeight
    for u = 1: imageWidth
        x = (u - px)/fx;
        y = (v - py)/fy;
        r2 = (x*x) + (y*y);
        newX = x * (1 + k1*r2 + k2*r2*r2 + k3*r2*r2*r2);
        newY = y * (1 + k1*r2 + k2*r2*r2 + k3*r2*r2*r2);
        newU = newX*fx + px;
        newV = newY*fy + py;
                
        bottomV = floor(newV);
        bottomU = floor(newU);
        
        topV = ceil(newV);
        topU = ceil(newU);
        
        f1 = image(bottomV, bottomU, :);
        f2 = image(bottomV, topU, :);
        f3 = image(topV, bottomU, :);
        f4 = image(topV, topU, :);
        
        alpha = newU - bottomU;
        beta = newV - bottomV;
        
        f12 = (1-alpha)*f1 + alpha*f2;
        f34 = (1-alpha)*f3 + alpha*f4;
        f1234 = (1-beta)*f12 + beta*f34;
        
        newImage(v,u, :) = f1234;
    end
end
imshow(newImage);