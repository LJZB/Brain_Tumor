% Imágenes de Tumores Cerebrales
clear all, close all, clc

%Carga de la carpeta con imágenes
brain_tumor_path=imageDatastore('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\*.*');
brain_tumor_images = readall(brain_tumor_path);
%% Preprocesamiento
% Transformar a escala de grises
im = brain_tumor_images{1};
im_gray = rgb2gray(im);
figure
imshow(im_gray);

% Filtrado de la imagen
im_filtered=medfilt2(im_gray);
figure
imshow(im_filtered);

%Erosion? Se necesita eliminar lo más posible el borde del cerebro
%% Detección de características
%Brisk
figure
points = detectBRISKFeatures(im_filtered);
imshow(im_filtered);
hold on;
title('Brisk')
plot(points.selectStrongest(50));

%Fast
figure
points = detectFASTFeatures(im_filtered);
imshow(im_filtered);
hold on;
title('Fast')
plot(points.selectStrongest(50));

%Harris
figure
points = detectHarrisFeatures(im_filtered);
imshow(im_filtered);
hold on;
title('Harris')
plot(points.selectStrongest(50));

%Kaze
figure
points = detectKAZEFeatures(im_filtered);
imshow(im_filtered);
hold on;
title('Kaze')
plot(points.selectStrongest(50));

%MinEigen
figure
points = detectMinEigenFeatures(im_filtered);
imshow(im_filtered);
hold on;
title('MinEigen')
plot(points.selectStrongest(90));

%MSER
figure
regions = detectMSERFeatures(im_filtered);
imshow(im_filtered);
hold on;
title('MSER')
plot(regions,'showPixelList',true,'showEllipses',false);

%% Extracción de características
[caracteristicas, puntos_validos] = extractHOGFeatures(I, mis_puntos);