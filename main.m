%--------------------------------------------------------------------%
%-----------Primera Entrega: Extracción de Características-----------%
%-----------------Procesamiento Digital de Imágenes 2----------------%
%--------------------------------------------------------------------%
%---------------------------------Por--------------------------------%
%--------------------Luisa Fernanda Gómez Buitrago-------------------%
%----------------------luisa.gomezb@udea.edu.co----------------------%
%--------------------------------------------------------------------%
%--------------------Luis Javier Zuluaga Betancur--------------------%
%---------------------javier.zuluaga@udea.edu.co---------------------%
%--------------------------------------------------------------------%
%--------------Dpto. de Electrónica y Telecomunicaciones-------------%
%-----------------------Facultad de Ingeniería-----------------------%
%----------------------------Julio de 2022---------------------------%
%--------------------------------------------------------------------%

%----------------------1. Inicializo el sistema----------------------%
clear all   % Limpiar variables
close all   % Cierra todas las ventanas, archivos y procesos abiertos
clc         % Limpia la ventana de comandos

%-----------------2. Carga de la carpeta de imágenes-----------------%

% Imágenes con tumor
brain_tumor_path = imageDatastore('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Brain_Tumor\*.*');

% Imágenes sin tumor
% brain_tumor_path = imageDatastore('D:\Users\Luis\Documents\MATLAB\tumor\Brain_Tumor_Data_Set\Healthy\*.*');

%Carga de las rutas de cada imagen
fullFileNames = vertcat(brain_tumor_path.Files);

%Carga de matrices de cada imagen
brain_tumor_images = readall(brain_tumor_path);

%%
for i = 1:1

    %----------------------3. Propiedades De Ventana---------------------%
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
    
    fontSize = 12;

    % Escoger imagen del dataset
    im = brain_tumor_images{i};
    subplot(231); imshow(im, []);title('Imagen original', 'FontSize', fontSize);axis('on', 'image');
    hp = impixelinfo();
    
    % Máscara e imagen con máscara
    [im_masked, my_mask] = mask_function(im);
    subplot(232); imshow(my_mask, []);title('Máscara', 'FontSize', fontSize);axis('on', 'image');
    hp = impixelinfo();

    % Imagen original en escala de grises con máscara
    im_gray = im2gray(im_masked);
    subplot(233); imshow(im_gray, []);title('Imagen en escala de grises con Máscara', 'FontSize', fontSize);axis('on', 'image');
    hp = impixelinfo();
    
    % Calcular 2 niveles de Umbral
    thresh = multithresh(im_gray,2);
    
    % Imagen binarizada
    maximum = max(thresh);
    im_binary = im_gray > maximum;
    
    % Poner etiquetas a las imágenes
    labeledImage = bwlabel(im_binary);
    
    % Segmentar la imagen en 2 niveles
    im_segmented = imquantize(im_gray,thresh);
    subplot(234);
    imshow(im_segmented, []);title('Imagen con dos niveles de gris', 'FontSize', fontSize);axis('on', 'image');
    
    % Redimensión de la imagen
    im_resized = imresize(im_gray,[125 125]);
    

    imageROI = ExtractBiggestBlob(im_masked);
    imageROI = imresize(imageROI,[125 125]);
    subplot(235);
    imshow(imageROI, []);title('Región de Posible Tumor', 'FontSize', fontSize);axis('on', 'image');

    [featureVector,hogVisualization] = extractHOGFeatures(im_resized);
    subplot(236);
    imshow(im_resized, []);title('Extracción con HOG', 'FontSize', fontSize);axis('on', 'image');
    hold on
    plot(hogVisualization);
    [folder, baseFileNameNoExt, ext] = fileparts(fullFileNames{i});
    writematrix(featureVector,strcat(folder,'\Features\',baseFileNameNoExt,'.csv'))

end

%--------------------------------------------------------------------%
%--------------------------Fin del Programa--------------------------%
%--------------------------------------------------------------------%