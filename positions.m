clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear all;  % Erase all existing variables. Or clearvars if you want.
format long g;
format compact;
%% Carga de la carpeta con imágenes
fontSize = 12;
brain_tumor_path = imageDatastore('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\*.*');
brain_tumor_images = readall(brain_tumor_path);
%% Preprocesamiento y gráfica de las imágenes

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

% ==================== Preprocesamiento ====================

% Imagen de interés
im = brain_tumor_images{1};

% Imagen en escala de grises
im_gray = rgb2gray(im);
subplot(2, 3, 1); imshow(im_gray, []); title('Imagen En Escala de Grises', 'FontSize', fontSize, 'Interpreter', 'None');
axis('on', 'image');
hp = impixelinfo();

% Binarización de la imagen
im_binary01 = im_gray < 82;

% Extraer los bulbos más grandes, y así eliminar los más pequeños causados
% por ruido
im_binary01 = bwareafilt(im_binary01, 2);
subplot(2, 3, 2); imshow(im_binary01, []);title('Imagen Binarizada', 'FontSize', fontSize);
axis('on', 'image');

% Etiquetar la imagen para poder encontrar el bulbo requerido
labeledImage = bwlabel(im_binary01)

% Escoger la etiqueta del área ???
im_binary01 = labeledImage == 3;

% Rellenar huecos
im_mask = imfill(im_binary01, 'holes');
subplot(2, 3, 3); imshow(im_mask, []); title('Máscara sin cráneo', 'FontSize', fontSize, 'Interpreter', 'None'); axis('on', 'image');

% Aplicar máscara
im_gray(~im_mask) = 0; 
subplot(2, 3, 4);imshow(im_gray, []);title('Imagen con Máscara', 'FontSize', fontSize, 'Interpreter', 'None');axis('on', 'image');
hp = impixelinfo();

% Binarización 02
im_binary02 = im_gray > 86;

% Rellenar huecos
lettersMask = imfill(im_binary02, 'holes');
subplot(2, 3, 5); imshow(lettersMask, [])

% Tomar el bulbo más grande ????
lettersMask = bwareafilt(lettersMask, 1);

% Take convex hull
lettersMask = bwconvhull(lettersMask);
% Display the image.
subplot(2, 3, 6);
imshow(lettersMask, []);
title('Masked gray image', 'FontSize', fontSize, 'Interpreter', 'None');
axis('on', 'image');
hp = impixelinfo();

% Measure blobs
props = regionprops(lettersMask, 'Centroid', 'BoundingBox');
xy = props.Centroid

% Put a red cross at the centroid.
hold on;
plot(xy(1), xy(2), 'r+', 'MarkerSize', 30, 'LineWidth', 2);
% Put up a bounding box.
rectangle('Position', props.BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
% Update title
caption = sprintf('Centroid at x (column) = %.1f, y (row) = %.1f', xy(1), xy(2));
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');