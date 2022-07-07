% function [im_cropped] = my_mask(im)
close all
im = imread('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\Cancer (2400).jpg');
% Máscara elíptica
X_size = size(im,2);
Y_size = size(im,1);
X_center = X_size/2;
Y_center = Y_size/2;

if X_size>=175 || X_size<=273
    if Y_size==167
        X_radius = X_center - 1.7*X_center;
        Y_radius = Y_center - 1.8*Y_center;
    end
end

if X_size==178
    if Y_size==249
        X_radius = X_center - 1.6*X_center;
        Y_radius = Y_center - 1.6*Y_center;
    end
end

if X_size==180
    if Y_size==218
        X_radius = X_center - 1.8*X_center;
        Y_radius = Y_center - 1.6*Y_center;
    end
end

if X_size==189
    if Y_size==173
        X_radius = X_center - 1.7*X_center;
        Y_radius = Y_center - 1.99*Y_center;
    end
end

if X_size==200
    if Y_size==210
        X_radius = X_center - 1.7*X_center;
        Y_radius = Y_center - 1.7*Y_center;
    end
end

if X_size==200
    if Y_size==235
        X_radius = X_center - 1.89*X_center;
        Y_radius = Y_center - 1.7*Y_center;
    end
end

if X_size==201
    if Y_size==251
        X_radius = X_center - 1.89*X_center;
        Y_radius = Y_center - 1.7*Y_center;
    end
end

if X_size==204
    if Y_size==245
        X_radius = X_center - 1.89*X_center;
        Y_radius = Y_center - 1.7*Y_center;
    end
end

if X_size==204
    if Y_size==247
        X_radius = X_center - 1.7*X_center;
        Y_radius = Y_center - 1.7*Y_center;
    end
end


if X_size==512
    if Y_size==512
        X_radius = X_center - 1.6*X_center;
        Y_radius = Y_center - 1.7*Y_center;
    end
end

[col,row] = meshgrid(1:X_size, 1:Y_size);
mask = ((row - Y_center).^2 ./ Y_radius^2) + ((col - X_center).^2 ./ X_radius^2) <= 1;
mask = uint8(mask);
im_cropped = im .* mask;

% figure(1); imshow(im_cropped)

ExtractBiggestBlob(im_cropped);


% end