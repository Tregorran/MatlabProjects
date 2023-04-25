function result = basic_convolution(image, kernel)
    [imageHeight, imageWidth] = size(image);
    [kernelHeight, kernelWidth] = size(kernel);
    result = zeros(imageHeight, imageWidth);
    newkernel = zeros(kernelHeight, kernelWidth);
    
    %flip the kernel
    for i = 1: kernelHeight
        for j = 1: kernelWidth
            newkernel(kernelHeight+1-i, kernelWidth+1-j) = kernel(i,j);
        end
    end
    kernel = newkernel;
    
    for i_y = 1: 1: (imageWidth-(kernelWidth))
        for i_x = 1: 1: (imageHeight-(kernelHeight))
            accumulator = 0;
            for j_x = 1: kernelHeight
                 for j_y = 1: kernelWidth
                     accumulator = accumulator + (image(j_x + i_x ,j_y + i_y) * kernel(j_x,j_y));
                 end
            end
            result(i_x,i_y) = accumulator;
        end
    end
