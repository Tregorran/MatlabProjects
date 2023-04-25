image = im2double(imread('cameraman.tif'));
kernel = ones(5) / 25;
kernel2 = [-1, 0, 1];
filtered = basic_convolution(image, kernel);
filtered2 = basic_convolution(image, kernel2);
subplot(221); imshow(image); title('Input image');
subplot(222); imshow(filtered); title('Filtered image(ones(5) / 25)');
subplot(223); imshow(filtered2); title('Filtered image([-1, 0, 1])');