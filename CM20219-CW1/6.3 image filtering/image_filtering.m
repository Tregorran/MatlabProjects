image = im2double(imread('cameraman.tif'));

horizontalKernel = [-1 0 1];
horizontal = image_filter(image, horizontalKernel);

verticalKernel = [1,0,-1;2,0,-2;1,0,-1];
vertical = image_filter(image, verticalKernel);

diagonalURKernel = [0,-1,-2; 1,0,-1; 2,1,0];
diagonalUR = image_filter(image, diagonalURKernel);

diagonalULKernel = [-2,-1,0; -1,0,1; 0,1,2];
diagonalUL = image_filter(image, diagonalULKernel);

diagonalDRKernel = [2,1,0;1,0,-1;0,-1,-2];
diagonalDR = image_filter(image, diagonalDRKernel);

diagonalDLKernel = [0,1,2;-1,0,1;-2,-1,0];
diagonalDL = image_filter(image, diagonalDLKernel);

sharpKernel = [0,-1,0;-1,5,-1;0,-1,0];
sharp = image_filter(image, sharpKernel);

guassianKernel = guassianEquation();
guassian = image_filter(image, guassianKernel);

subplot(331); imshow(image); title('Input image');
subplot(332); imshow(horizontal); title('Horizontal filter');
subplot(333); imshow(vertical); title('Vertical filter');
subplot(334); imshow(diagonalUR); title('DiagonalUR filter');
subplot(335); imshow(diagonalUL); title('DiagonalUL filter');
subplot(336); imshow(diagonalDR); title('DiagonalDR filter');
subplot(337); imshow(diagonalDL); title('DiagonalDL filter');
subplot(338); imshow(sharp); title('Unsharp masking filter');
subplot(339); imshow(guassian); title('Guassian filter');

function [kernel] = guassianEquation()
    sigma = 1;
    kernel = zeros(5);
    total = 0;
    for i = 1: 5
        for j = 1: 5
            leftEq = (1/(2*pi*sigma^2));
            rightEq = exp(-1*(((i^2) + (j^2))/(2*(sigma^2))));
            kernel(i,j) = leftEq * rightEq;
            total = total + kernel(i,j);
        end
    end
    kernel = kernel/total;
    
    %check that the kernel is normalised
    sum = 0;
    for x = 1: 5
        for y = 1: 5
            sum = sum + kernel(x,y);
        end
    end
    disp("Gaussian kernel: " + sum);
    
end

function [newImage, biggerImage] = image_filter(image, kernel)
   [imageHeight, imageWidth] = size(image);
    [kernelHeight, kernelWidth] = size(kernel);
    
    %used as a temp to crop image size
    otherImage = zeros(imageHeight+(kernelHeight-1), imageWidth+(kernelWidth-1));
    
    %bigger empty matrix created for image
    biggerImage = zeros(imageHeight+(kernelHeight-1), imageWidth+(kernelWidth-1));
    
    [biggerHeight, biggerWidth] = size(biggerImage);
    
    %put original image in the bigger empty image
    for i = 1: 1: imageWidth
        for j = 1: 1: imageHeight
            biggerImage(i+((kernelHeight-1)/2),j+((kernelWidth-1)/2)) = image(i,j);
        end
    end
    
    %replicate rows and columns edges into the black border
    
    %replicate top row
    for x = 1: imageWidth
        for y = 1: ((kernelHeight-1)/2)
            biggerImage(y,x+((kernelWidth-1)/2)) = image(1,x);
        end
    end
    
    %replicate left column
    for x = 1: ((kernelWidth-1)/2)
        for y = 1: imageHeight
            biggerImage(y+((kernelHeight-1)/2),x) = image(y,1);
        end
    end
    
    %replicate bottom
    for x = 1: imageWidth
        for y = biggerHeight-((kernelHeight-1)/2): biggerHeight
            biggerImage(y,x+((kernelWidth-1)/2)) = image(imageHeight,x);
        end
    end
    
    %replicate right
    for x = biggerWidth-((kernelWidth-1)/2): biggerWidth
        for y = 1: imageHeight
            biggerImage(y+((kernelHeight-1)/2),x) = image(y,imageWidth);
        end
    end
    
    %corners
    %top left
    for x = 1: ((kernelWidth-1)/2)
        for y = 1: ((kernelHeight-1)/2)
            biggerImage(y,x) = image(1,1);
        end
    end
    
    %top right
    for x = biggerWidth-((kernelWidth-1)/2): biggerWidth
        for y = 1: ((kernelHeight-1)/2)
            biggerImage(y,x) = image(1,imageWidth);
        end
    end
    
    %bottom left
    for x = 1: ((kernelWidth-1)/2)
        for y = biggerHeight-((kernelHeight-1)/2): biggerHeight
            biggerImage(y,x) = image(imageHeight,1);
        end
    end
    
    %bottom right
    for x = biggerWidth-((kernelWidth-1)/2): biggerWidth
        for y = biggerHeight-((kernelHeight-1)/2): biggerHeight
            biggerImage(y,x) = image(imageHeight,imageWidth);
        end
    end
    
    newkernel = zeros(kernelHeight,kernelWidth);

    %flip the kernel
    for i = 1: kernelHeight
        for j = 1: kernelWidth
            newkernel(kernelHeight+1-i, kernelWidth+1-j) = kernel(i,j);
        end
    end
    kernel = newkernel;
    
    %convolution
    for i_y = 0: 1: (biggerHeight-(kernelHeight))
        for i_x = 0: 1: (biggerWidth-(kernelWidth))
            accumulator = 0;
            for j_x = 1:kernelHeight
                 for j_y = 1:kernelWidth
                     accumulator = accumulator + (biggerImage(j_x + i_x ,j_y + i_y) * kernel(j_x,j_y));
                 end
            end
            otherImage(i_x+((kernelHeight+1)/2),i_y+((kernelWidth+1)/2)) = accumulator;
            newImage = otherImage(((kernelHeight+1)/2):imageHeight+((kernelHeight-1)/2), ((kernelWidth+1)/2):imageWidth+((kernelWidth-1)/2));
        end
    end
end