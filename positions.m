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

% Imagen de interés
im = brain_tumor_images{1};

% Imagen en escala de grises
im_gray = rgb2gray(im);
subplot(2, 3, 1);
imshow(im_gray, []);
title('Imagen En Escala de Grises', 'FontSize', fontSize, 'Interpreter', 'None');
axis('on', 'image');
hp = impixelinfo();

% Histograma de intensidad
subplot(2, 3, 2);
imhist(im_gray);
grid on;
title('Histograma', 'FontSize', fontSize, 'Interpreter', 'None');

% Propiedades de la ventana
% % Agrandar la figura
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'PDI2 - Gómez_Zuluaga', 'NumberTitle', 'Off')
drawnow;

%%
% Binarize the image
binaryImage = grayImage < 82;
% Extract only the two largest blobs.  This will take the major ones and ignore small noise blobs.
binaryImage = bwareafilt(binaryImage, 2);
% Display the image.
subplot(2, 3, 3);
imshow(binaryImage, []);
title('Two main blobs', 'FontSize', fontSize, 'Interpreter', 'None');
axis('on', 'image');
% Label the image so we can take the rightmost one.
labeledImage = bwlabel(binaryImage);
% Take the right most one.  It will have the label 2.
binaryImage = labeledImage == 2;
% Fill holes
binaryImage = imfill(binaryImage, 'holes');
% Display the image.
subplot(2, 3, 4);
imshow(binaryImage, []);
title('Rightmost Blob', 'FontSize', fontSize, 'Interpreter', 'None');
axis('on', 'image');
% Use it to zero out the other parts of the image.
grayImage(~binaryImage) = 0;
% Display the image.
subplot(2, 3, 5);
imshow(grayImage, []);
title('Masked gray image', 'FontSize', fontSize, 'Interpreter', 'None');
axis('on', 'image');
hp = impixelinfo();
% Get a new binary image of just the letters
lettersMask = grayImage > 86;
% Fill holes
lettersMask = imfill(lettersMask, 'holes');
% Take largest blob only.
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