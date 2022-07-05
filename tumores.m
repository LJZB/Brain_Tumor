% Imágenes de Tumores Cerebrales
clear all, close all, clc

%Carga de la carpeta con imágenes
brain_tumor_path=imageDatastore('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\*.*');
brain_tumor_images = readall(brain_tumor_path);

%% Vista previa de imagen
% Transformar a escala de grises
I = brain_tumor_images{1};
I = rgb2gray(I);

%% Morfología
% Otsu Binarization for segmentation
level = graythresh(I);
img = im2bw(I,0.26);
figure, imshow(img);title('Otsu Thresholded Image');
%%
I = medfilt2(I);
figure
imshow(I);
se = strel('line',11,90);
I = imdilate(I,se);
figure
imshow(I);
%% Detección de características
mis_puntos = detectSIFTFeatures(I,"EdgeThreshold",10);
imshow(I);
hold on;
plot(mis_puntos.selectStrongest(50));

%% Extracción de características
[caracteristicas, puntos_validos] = extractHOGFeatures(I, mis_puntos);