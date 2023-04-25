image = im2double(imread('cameraman.tif'));
kernel = ones(5) / 25;
filtered = extended_convolution(image, kernel);
reference = imfilter(image, kernel, 'replicate', 'conv');
difference = 0.5 + 10 * (filtered - reference);
ssd = sum((filtered(:) - reference(:)) .^ 2);
subplot(231); imshow(filtered); title("Extended convolution" + newline + "(ones(5) / 25)");
subplot(232); imshow(reference); title("Reference result" + newline + "(ones(5) / 25)");
subplot(233); imshow(difference); title(sprintf('Difference (SSD=%.1f)',ssd));


kernel = [-1 0 1];
filtered = extended_convolution(image, kernel);
reference = imfilter(image, kernel, 'replicate', 'conv');
difference = 0.5 + 10 * (filtered - reference);
ssd = sum((filtered(:) - reference(:)) .^ 2);
subplot(234); imshow(filtered); title("Extended convolution" + newline + "([-1 0 1])");
subplot(235); imshow(reference); title("Reference result" + newline + "([-1 0 1])");
subplot(236); imshow(difference); title(sprintf('Difference (SSD=%.1f)',ssd));
