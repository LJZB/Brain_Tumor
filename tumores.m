% Imágenes de Tumores Cerebrales
clear all, close all, clc

%Carga de la carpeta con imágenes
brain_tumor_path = imageDatastore('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\*.*');
brain_tumor_images = readall(brain_tumor_path);
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

%Imagen de máscara
im_threshold = uint8(im_threshold);
im_mask = im_adjusted .* im_threshold;
subplot(3,3,6)
imshow(im_mask);
title('Imagen de Máscara', 'FontSize',10);

impixelinfo;
%% Preprocesamiento: Filtrado
num_iter = 10;
delta_t = 1/7;
kappa = 15;
option = 2;
% Se utiliza la función anisodiff que realiza una difusión anisotrópica
% mediante la convolución con matrices de diferencias finitas
im_anisodiff = anisodiff(im,num_iter,delta_t,kappa,option);
im_anisodiff = uint8(im_anisodiff);
im_anisodiff=imresize(im_anisodiff,[256,256]);
if size(im_anisodiff,3)>1
    im_anisodiff=rgb2gray(im_anisodiff);
end
im_anisodiff = uint8(im_anisodiff);
figure;
imshow(im_anisodiff);
title('Imagen Filtrada','FontSize',10);
%% Preprocesamiento: Umbralización
im_binary = imbinarize(im_anisodiff,'adaptive','ForegroundPolarity','dark','Sensitivity',0.67);
T = graythresh(im)
imshow(im_binary)

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