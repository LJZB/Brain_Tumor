clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
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
% ====================================================================
im = brain_tumor_images{2};

% Imagen en gris
im_gray = im2gray(im);

% Imagen original
subplot(2, 3, 1);imshow(im, []); title('Imagen original', 'FontSize', fontSize, 'Interpreter', 'None');axis('on', 'image');
hp = impixelinfo();


% subplot(2, 3, 2); imhist(im_gray); grid on; title('Histogram of Image', 'FontSize', fontSize, 'Interpreter', 'None');

% Imagen Binarizada
binaryImage = im_gray < 82;

% Extract only the two largest blobs.  This will take the major ones and ignore small noise blobs.
binaryImage = bwareafilt(binaryImage, 2);
subplot(2, 3, 2);imshow(binaryImage, []);title('Extracción de Bulbos', 'FontSize', fontSize, 'Interpreter', 'None');axis('on', 'image');

% Poner etiquetas a las imágenes para tomar la de más a la derecha
labeledImage = bwlabel(binaryImage);

% Tomar la de más a la derecha. Tendrá la etiqueta 2
binaryImage = labeledImage == 2;

% Llenar los huecos
binaryImage = imfill(binaryImage, 'holes');
subplot(2, 3, 3);imshow(binaryImage, []);title('Máscara', 'FontSize', fontSize, 'Interpreter', 'None');axis('on', 'image');

% Aplicar la máscara 
im_gray(~binaryImage) = 0;
subplot(2, 3, 4);imshow(im_gray, []);title('Masked gray image', 'FontSize', fontSize, 'Interpreter', 'None');axis('on', 'image');
hp = impixelinfo();

%%
% Get a new binary image of just the letters
lettersMask = im_gray > 86;

% Fill holes
lettersMask = imfill(lettersMask, 'holes');

% Take largest blob only.
lettersMask = bwareafilt(lettersMask, 1);

% Take convex hull
lettersMask = bwconvhull(lettersMask);

% Display the image.
subplot(2, 3, 5);
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