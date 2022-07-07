% Imágenes de Tumores Cerebrales
clear all, close all, clc

% Carga de la carpeta con imágenes
brain_tumor_path = imageDatastore('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\*.*');
brain_tumor_images = readall(brain_tumor_path);
fontSize = 12;
%% 

% ==================== Propiedades de la ventana ====================
% Agrandar la figura
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

% Quitar el menú de la ventana.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');

% Agregar un título a la ventana.
set(gcf, 'Name', ...
    'Procesamiento Digital de Imágenes 2: Luisa Fernanda Gómez Buitrago - Luis Javier Zuluaga Betancur', ...
    'NumberTitle', ...
    'Off')
drawnow;
% ====================================================================

% Escoger imagen del dataset
im = brain_tumor_images{1};

% Imagen original en escala de grises
try
    im_gray = rgb2gray(im);
catch
    im_gray = im2gray(im);
end
subplot(2, 3, 1); imshow(im_gray, []);title('Imagen original en escala de grises', 'FontSize', fontSize);axis('on', 'image');
hp = impixelinfo();

% Calcular 2 niveles de Umbral
thresh = multithresh(im_gray,2);

% Imagen binarizada
maximum = max(thresh);
im_binary = im_gray > maximum;
subplot(2, 3, 2);imshow(im_binary, []);title('Imagen binarizada', 'FontSize', fontSize);axis('on', 'image');



% =====================FUNCIONA PARA ALGUNAS IMÁGENES ==================
% Poner etiquetas a las imágenes para tomar la de más a la derecha
labeledImage = bwlabel(im_binary);

% Tomar la de más a la derecha. Tendrá la etiqueta 2
im_binary = labeledImage == 1;

% Llenar los huecos
im_binary = imfill(im_binary, 'holes');
subplot(2, 3, 3);imshow(im_binary, []);title('Máscara', 'FontSize', fontSize);axis('on', 'image');


% Aplicar la máscara 
im_gray(~im_binary) = 0;
subplot(2, 3, 4);imshow(im_gray, []);title('Imagen con máscara', 'FontSize', fontSize');axis('on', 'image');


% Segmentar la imagen en 2 niveles
im_segmented = imquantize(im_gray,thresh);
subplot(2, 3, 5);
imshow(im_segmented, []);title('Imagen Segmentada en escala de grises', 'FontSize', fontSize);

%%
% Escoger imagen del dataset
close all
im = imread('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\Cancer (928).jpg');
% im = brain_tumor_images{550}; %50, 1
% figure; imshow(im)

im_adjust = im2gray(im);
% im_adjust = imadjust(im_adjust,[0.5 1],[]);
im_adjust = imadjust(im_adjust);


% Pre-generar una Máscara elíptica
X_size = size(im,2);
Y_size = size(im,1);
X_center = X_size/2;
Y_center = Y_size/2;
X_radius = X_center - 1.6*X_center;
Y_radius = Y_center - 1.6*Y_center;

[col,row] = meshgrid(1:X_size, 1:Y_size);
mask = ((row - Y_center).^2 ./ Y_radius^2) + ((col - X_center).^2 ./ X_radius^2) <= 1;
mask = uint8(mask);
im_cropped = im_adjust .* mask;
figure; imshow(im_cropped)

ExtractBiggestBlob(im_cropped);