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
im_gray = im2gray(im);
subplot(2, 3, 1);
imshow(im_gray, []);title('Imagen original en escala de grises', 'FontSize', fontSize, 'Interpreter', 'None');
axis('on', 'image');hp = impixelinfo();

% Calcular 2 niveles de Umbral
 thresh = multithresh(im_gray,2);

% Imagen binarizada
maximo = max(thresh);
im_binary = im_gray < maximo;
subplot(2, 3, 2);imshow(im_binary, []);title('Imagen binarizada', 'FontSize', fontSize, 'Interpreter', 'None');axis('on', 'image');

% Poner etiquetas a las imágenes para tomar la de más a la derecha
labeledImage = bwlabel(im_binary);

% Tomar la de más a la derecha. Tendrá la etiqueta 2
im_binary = labeledImage == 2;

% Llenar los huecos
im_binary = imfill(im_binary, 'holes');
subplot(2, 3, 3);imshow(im_binary, []);title('Máscara', 'FontSize', fontSize, 'Interpreter', 'None');axis('on', 'image');

% Aplicar la máscara 
im_gray(~im_binary) = 0;
subplot(2, 3, 4);imshow(im_gray, []);title('Masked gray image', 'FontSize', fontSize, 'Interpreter', 'None');axis('on', 'image');
hp = impixelinfo();

% Segmentar la imagen en 2 niveles
im_segmented = imquantize(im_gray,thresh);
subplot(2, 3, 5);
imshow(im_segmented, []);title('Imagen Segmentada en escala de grises', 'FontSize', fontSize, 'Interpreter', 'None');

%%
% Extract only the two largest blobs.  This will take the major ones and ignore small noise blobs.
binaryImage_area = bwareafilt(not(im_binary), 2);
subplot(2, 3, 5);
imshow(binaryImage_area, []);title('Two main blobs', 'FontSize', fontSize, 'Interpreter', 'None');axis('on', 'image');

% Label the image so we can take the rightmost one.
labeledImage = bwlabel(binaryImage_area);

% Take the right most one.  It will have the label 2.
binaryImage_area = labeledImage == 2;

% Fill holes
binaryImage_area = imfill(binaryImage_area, 'holes');

% Display the image.
subplot(2, 3, 6);
imshow(binaryImage_area, []);title('Rightmost Blob', 'FontSize', fontSize, 'Interpreter', 'None');axis('on', 'image');