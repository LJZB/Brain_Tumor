% Imágenes de Tumores Cerebrales
clear all, close all, clc

%Carga de la carpeta con imágenes
brain_tumor_path = imageDatastore('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\*.*');
brain_tumor_images = readall(brain_tumor_path);
%% Carga de una imagen de muestra
im = brain_tumor_images{2};
% figure; imshow(im); title('Imagen original')

% Preprocesamiento 

%Imagen en Gris
try
    im_gray = rgb2gray(im);
catch
    im_gray = im2gray(im);
end
figure; imshow(im_gray); title('Imagen en Gris', 'FontSize',10);

%Imagen ajustada en 
im_adjusted = imadjust(im_gray,[0.09 0.56],[]);
% figure; imshow(im_adjusted); title('Imagen ajustada', 'FontSize',10);

%Imagen Filtrada
im_filtered = medfilt2(im_adjusted);
% figure; imshow(im_filtered); title('Imagen Filtrada', 'FontSize',10);

%Imagen Umbralizada
im_threshold = im_filtered <= 110;
% figure; imshow(im_threshold); title('Imagen Umbralizada', 'FontSize',10);

% Dilatar 01
se = strel('square',5)
im_dilated01 = imdilate(im_threshold,se);
% figure; imshow(im_dilate); title('Imagen dilatada', 'FontSize',10);

% Hallando la mayor área
im_area = not(im_dilated01);
im_area = im_area - bwareafilt(im_area, 1, 'largest');
% figure; imshow(im_area); title('Imagen sin áreas grandes', 'FontSize',10);

% Erosionar 01
se = strel('square',8)
im_eroded01 = imerode(im_area,se);
% figure; imshow(im_eroded01); title('Imagen dilatada', 'FontSize',10);

% Dilatar 02
se = strel('square',16)
im_dilated02 = imdilate(im_eroded01,se);
figure; imshow(im_dilated02); title('Imagen dilatada', 'FontSize',10);

%% Búsqueda de centroide principal
[labeledImage, numberOfBlobs] = bwlabel(im_dilated);
blobMeasurements = regionprops(labeledImage, 'area', 'Centroid');
maximum_area_id = find([blobMeasurements.Area]==max([blobMeasurements.Area]));
my_centroid = blobMeasurements(maximum_area_id).Centroid;


%% Generación de Máscara basada en centroide


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