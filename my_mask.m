% function [im_cropped] = my_mask(im)
close all
clc

im = imread('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\Cancer (901).JPG');

% Máscara elíptica
X_size = size(im,2);
Y_size = size(im,1);
X_center = X_size/2;
Y_center = Y_size/2;

% if X_size==180
%     if Y_size==218
%         X_radius = X_center - 1.8*X_center;
%         Y_radius = Y_center - 1.6*Y_center;
%     end
% end
% 
% if X_size==189
%     if Y_size==173
%         X_radius = X_center - 1.7*X_center;
%         Y_radius = Y_center - 1.99*Y_center;
%     end
% end
% 
% if X_size==200
%     if Y_size==210
%         X_radius = X_center - 1.7*X_center;
%         Y_radius = Y_center - 1.7*Y_center;
%     end
% end
% 
% if X_size==201
%     if Y_size==251
%         X_radius = X_center - 1.89*X_center;
%         Y_radius = Y_center - 1.7*Y_center;
%     end
% end
% 
% if X_size==204
%     if Y_size==247
%         X_radius = X_center - 1.89*X_center;
%         Y_radius = Y_center - 1.7*Y_center;
%     end
% end
% 
% if X_size==204|205|209
%     if Y_size==251|243|246|212
%         X_radius = X_center - 1.75*X_center;
%         Y_radius = Y_center - 1.75*Y_center;
%     end
% end
% 
% if X_size==211
%     if Y_size==239
%         X_radius = X_center - 1.7*X_center;
%         Y_radius = Y_center - 1.77*Y_center;
%     end
% end
% 
%  if X_size==213
%     if Y_size==236
%         X_radius = X_center - 1.84*X_center;
%         Y_radius = Y_center - 1.77*Y_center;
%     end
% end
% 
% 
% if X_size==213|225
%     if Y_size==237|225
%         X_radius = X_center - 1.78*X_center;
%         Y_radius = Y_center - 1.77*Y_center;
%     end
% end
% 
% 
% if X_size==215
%     if Y_size==233
%         X_radius = X_center - 1.7*X_center;
%         Y_radius = Y_center - 1.7*Y_center;
%     end
% end
% 
% 
% if X_size==223
%     if Y_size==303
%         X_radius = X_center - 1.85*X_center;
%         Y_radius = Y_center - 1.7*Y_center;
%     end
% end
% 
% 
% 
% if X_size==225|232|240|241|248|249|250|254
%     if Y_size==225|309|300|286|338|269|294|325
%         X_radius = X_center - 1.9*X_center;
%         Y_radius = Y_center - 1.8*Y_center;
%     end
% end
% 
% if X_size==256
%     if Y_size==256
%         X_radius = X_center - 1.8*X_center;
%         Y_radius = Y_center - 1.8*Y_center;
%     end
% end
% 
% 
% if X_size==260|263|264|270|271|272|273
%     if Y_size==331|300|366|316|307|277|331|350|355|318
%         X_radius = X_center - 1.88*X_center;
%         Y_radius = Y_center - 1.8*Y_center;
%     end
% end
% 
% 
% if X_size==273
%     if Y_size==342|351
%         X_radius = X_center - 1.88*X_center;
%         Y_radius = Y_center - 1.8*Y_center;
%     end
% end
% 
% 
% if X_size==278
%     if Y_size==324|351
%         X_radius = X_center - 1.88*X_center;
%         Y_radius = Y_center - 1.8*Y_center;
%     end
% end
% 
% if X_size==279
%     if Y_size==344
%         X_radius = X_center - 1.88*X_center;
%         Y_radius = Y_center - 1.9*Y_center;
%     end
% end
% if X_size==283
%     if Y_size==295
%         X_radius = X_center - 1.7*X_center;
%         Y_radius = Y_center - 1.9*Y_center;
%     end
% end
% if X_size==283
%     if Y_size==338
%         X_radius = X_center - 1.7*X_center;
%         Y_radius = Y_center - 1.9*Y_center;
%     end
% end
% 
% 
% 
% if X_size==283
%     if Y_size==357
%         X_radius = X_center - 1.9*X_center;
%         Y_radius = Y_center - 1.9*Y_center;
%     end
% end
% 
% if X_size==287
%     if Y_size==348
%         X_radius = X_center - 1.84*X_center;
%         Y_radius = Y_center - 1.9*Y_center;
%     end
% end
% 
% if X_size==288
%     if Y_size==340
%         X_radius = X_center - 1.84*X_center;
%         Y_radius = Y_center - 1.9*Y_center;
%     end
% end
% 
% if X_size==289
%     if Y_size==300
%         X_radius = X_center - 1.7*X_center;
%         Y_radius = Y_center - 1.7*Y_center;
%     end
% end
% 
% if X_size==291
%     if Y_size==340
%         X_radius = X_center - 1.86*X_center;
%         Y_radius = Y_center - 1.7*Y_center;
%     end
% end
% 
% if X_size==292
%     if Y_size==349
%         X_radius = X_center - 1.86*X_center;
%         Y_radius = Y_center - 1.85*Y_center;
%     end
% end
% 
% if X_size==293
%     if Y_size==337
%         X_radius = X_center - 1.8*X_center;
%         Y_radius = Y_center - 1.85*Y_center;
%     end
% end
% 
% if X_size==294
%     if Y_size==355
%         X_radius = X_center - 1.8*X_center;
%         Y_radius = Y_center - 1.85*Y_center;
%     end
% end
% 
% if X_size==297
%     if Y_size==348
%         X_radius = X_center - 1.8*X_center;
%         Y_radius = Y_center - 1.85*Y_center;
%     end
% end
% 
% if X_size==300
%     if Y_size==336
%         X_radius = X_center - 1.8*X_center;
%         Y_radius = Y_center - 1.7*Y_center;
%     end
% end
% 
% if X_size==300
%     if Y_size==347
%         X_radius = X_center - 1.8*X_center;
%         Y_radius = Y_center - 1.8*Y_center;
%     end
% end

if X_size==300
    if Y_size==349
        X_radius = X_center - 1.84*X_center;
        Y_radius = Y_center - 1.85*Y_center;
    end
end
[col,row] = meshgrid(1:X_size, 1:Y_size);
mask = ((row - Y_center).^2 ./ Y_radius^2) + ((col - X_center).^2 ./ X_radius^2) <= 1;
mask = uint8(mask);
im_cropped = im .* mask;

% figure(1); imshow(im_cropped)

ExtractBiggestBlob(im_cropped);


% end