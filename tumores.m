% Imágenes de Tumores Cerebrales
clear all, close all, clc

%Carga de la carpeta con imágenes
brain_tumor_path = imageDatastore('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\*.*');
brain_tumor_images = readall(brain_tumor_path);
%% Pre-procesamiento
im = brain_tumor_images{1};
figure; imshow(im); title('Imagen original');
% Pre-generar una Máscara elíptica
% X_size = size(im,2);
% Y_size = size(im,1);
% X_center = X_size/2;
% Y_center = Y_size/2;
% X_radius = X_center - 0;
% Y_radius = Y_center - 0;

% Crear índices para un plano cartesiano
% [col,row] = meshgrid(1:X_size, 1:Y_size);

% Genera los índices para una elipse, rellena el interior con píxeles
% blancos
% mask = ((row - Y_center).^2 ./ Y_radius^2) + ((col - X_center).^2 ./ X_radius^2) <= 1;
%%
close all
% Imagen original
% figure; imshow(im); title('Imagen original')

% Imagen recortada
% mask = uint8(mask);
% im_cropped = im .* mask;
% figure; imshow(im_cropped); title('Imagen recortada')

%%

%Imagen en Gris
im_gray = rgb2gray(im);
% figure; imshow(im_gray); title('Imagen en Gris', 'FontSize',10);

%Imagen Filtrada
im_filtered = medfilt2(im_gray);
% figure; imshow(im_filtered); title('Imagen Filtrada', 'FontSize',10);

%Imagen ajustada en 
% im_adjusted = imadjust(im_gray,[0.09 0.56],[]);
% figure; imshow(im_adjusted); title('Imagen ajustada', 'FontSize',10);

% Imagen binarizada
im_binary = imbinarize(im_filtered,'adaptive','ForegroundPolarity','bright','Sensitivity',0.4);
figure; imshow(im_binary); title('Binary Version of Image');



%Imagen Umbralizada
im_threshold = im_filtered <= 110;
% figure; imshow(im_threshold); title('Imagen Umbralizada', 'FontSize',10);


% Dilatar
se = strel('square',5)
im_dilate = imdilate(im_threshold,se);
figure; imshow(im_dilate); title('Imagen dilatada', 'FontSize',10);

% Hallando la mayor área
im_area = not(im_dilate);
im_area = im_area - bwareafilt(im_area, 1, 'largest');
figure; imshow(im_area); title('Imagen Restada1', 'FontSize',10);

% Dilatar
se = strel('square',3)
im_dilated = imdilate(im_area,se);
figure; imshow(im_dilated); title('Imagen dilatada', 'FontSize',10);

%% Búsqueda de centroide principal
[labeledImage, numberOfBlobs] = bwlabel(im_dilated);
blobMeasurements = regionprops(labeledImage, 'area', 'Centroid');
maximum_area_id = find([blobMeasurements.Area]==max([blobMeasurements.Area]));
my_centroid = blobMeasurements(maximum_area_id).Centroid;

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