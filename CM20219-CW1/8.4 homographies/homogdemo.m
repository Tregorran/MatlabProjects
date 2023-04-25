close all;
clear all;

% Read in two photos of the library.
left  = im2double(imread('parade1.bmp'));
right = im2double(imread('parade2.bmp'));

% Draw the left image.
figure(1);
image(left);
axis equal;
axis off;
title('Left image');
hold on;

% Draw the right image.
figure(2);
image(right);
axis equal;
axis off;
title('Right image');
hold on;

% Get 4 points on the left image.
figure(1);
[x, y] = ginput(4);
leftpts = [x'; y'];
% Plot left points on the left image.
figure(1)
plot(leftpts(1,:), leftpts(2,:), 'rx');

% Get 4 points on the right image.
figure(2);
[x, y] = ginput(4);
rightpts = [x'; y'];
% Plot the right points on the right image
figure(2)
plot(rightpts(1,:), rightpts(2,:), 'gx');

% Make leftpts and rightpts (clicked points) homogeneous.
leftpts(3,:) = 1;
rightpts(3,:) = 1;

%% TODO: compute the homography between the left and right points.
H = calchomography(leftpts,rightpts);
save mymatrix H;

%% TODO: have user click on left image, and plot their click. Then estimate
%        point in right image using the homography and draw that point.
figure(1);
image(left);
axis equal;
axis off;
title('Left image');
hold on;

figure(2);
image(right);
axis equal;
axis off;
title('Right image');
hold on;

% Get 4 points on the left image.
figure(1);
[x, y] = ginput(4);
leftpts = [x'; y'];
% Plot left points on the left image.
figure(1)
plot(leftpts(1,:), leftpts(2,:), 'rx');

leftpts(3,1) = 1;
leftpts(3,2) = 1;
leftpts(3,3) = 1;
leftpts(3,4) = 1;

result = H*leftpts;

result(1,:) = result(1,:)./result(3,:);
result(2,:) = result(2,:)./result(3,:);
result = result(1:2,:);

rightpts = result;

figure(2);
plot(rightpts(1,:), rightpts(2,:), 'rx');