close all
% im = imread('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\Cancer (1581).jpg');
im = imread('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\Cancer (6).jpg');
% figure; imshow(im)

im = im2gray(im);
% im_adjust = imadjust(im,[0.5 1],[]);
im_adjust = imadjust(im);
figure; imshow(im_adjust)
