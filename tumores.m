% Imágenes de Tumores Cerebrales
clear all, close all, clc

%Carga de la carpeta con imágenes
brain_tumor_path = imageDatastore('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\*.*');
brain_tumor_images = readall(brain_tumor_path);
%%
im = brain_tumor_images{1};
figure
imshow(im)

im_gray = rgb2gray(im);
im_binary = imbinarize(im_gray,'adaptive','Sensitivity',0.45);
im_mediafilter = medfilt2(im_binary,[5,5]);
se_filter = strel('disk', 2);
im_strel = imclose(im_mediafilter,se_filter);
figure
imshow(im_strel)

% Pre-generar una Máscara elíptica
X_size = size(im,2);
Y_size = size(im,1);
X_center = X_size/2;
Y_center = Y_size/2;
X_radius = X_center - 40;
Y_radius = Y_center - 50;

% Crear índices para un plano cartesiano
[col,row] = meshgrid(1:X_size, 1:Y_size);

% Genera los índices para una elipse, rellena el interior con píxeles
% blancos



%%
%Imagen Original
im = brain_tumor_images{1};
subplot(3,3,1)
imshow(im);
title('Imagen original', 'FontSize',10);

%Imagen en Gris
im_gray = rgb2gray(im);
subplot(3,3,2)
imshow(im_gray);
title('Imagen en Gris', 'FontSize',10);

%Imagen ajustada
im_adjusted = imadjust(im_gray,[0.3 0.6],[]);
subplot(3,3,3)
imshow(im_adjusted);
title('Imagen ajustada', 'FontSize',10);

%Imagen Filtrada
se = strel('disk',40);
%im_filtered = imtophat(im_adjusted,se);
im_filtered = medfilt2(im_adjusted);
subplot(3,3,4)
imshow(im_filtered);
title('Imagen Filtrada', 'FontSize',10);

%Imagen Umbralizada
im_threshold = im_filtered <= 110;
subplot(3,3,5)
imshow(im_threshold);
title('Imagen Umbralizada', 'FontSize',10);

%Imagen de complemento
im_complement = bitcmp(im);
subplot(3,3,6)
imshow(im_complement)
title('Imagen de Complemento', 'FontSize',10);

%Imagen con filtro tophat
se = strel('disk',30);
im_tophat = imtophat(im_complement,se);
subplot(3,3,7)
imshow(im_tophat)
title('Imagen con Tophat', 'FontSize',10);

%Imagen de máscara
im_threshold = uint8(im_threshold);
im_mask = im_filtered + im_tophat;
subplot(3,3,8)
imshow(im_mask);
title('Imagen de Máscara', 'FontSize',10);

impixelinfo;

%% Detección de características
my_image = rgb2gray(im_tophat);
%Brisk
figure
points = detectBRISKFeatures(my_image);
imshow(my_image);
hold on;
title('Brisk')
plot(points.selectStrongest(50));

%Fast
figure
points = detectFASTFeatures(my_image);
imshow(my_image);
hold on;
title('Fast')
plot(points.selectStrongest(50));

%Harris
figure
points = detectHarrisFeatures(my_image);
imshow(my_image);
hold on;
title('Harris')
plot(points.selectStrongest(50));

%Kaze
figure
points = detectKAZEFeatures(my_image);
imshow(my_image);
hold on;
title('Kaze')
plot(points.selectStrongest(50));

%MinEigen
figure
points = detectMinEigenFeatures(my_image);
imshow(my_image);
hold on;
title('MinEigen')
plot(points.selectStrongest(90));

%MSER
figure
regions = detectMSERFeatures(my_image);
imshow(my_image);
hold on;
title('MSER')
plot(regions,'showPixelList',true,'showEllipses',false);

%% Extracción de características
[caracteristicas, puntos_validos] = extractHOGFeatures(I, mis_puntos);