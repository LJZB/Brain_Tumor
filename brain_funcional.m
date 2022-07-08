%%
% INICIO
%% FILTRADO TUMOR

% im = brain_tumor_images{2};
im = imread('D:\UdeA\2022-1\PDI-II\ML\archive (1)\Brain Tumor Data Set\Brain Tumor Data Set\Brain Tumor\Cancer (2).jpg');
figure;
subplot(3, 3, 1),imshow(im);title('Original');

grey = im2gray(im);
subplot(3, 3, 2), imshow(grey);title('Grises');
hist = imhist(grey,256);
% figure, image(hist);title('Histograma');
subplot(3, 3, 3), imhist(grey);
%% UMBRALIZACIÓN - Histograma (manual)

black=grey>100;
% black=grey>155;
subplot(3, 3, 4), imshow(black);title('Aumentar Grises');
%% UMBRALIZACIÓN

%Calcular 2 niveles de Umbral
thresh = multithresh(grey,2)
%Segmentar la imagen en 3 niveles
seg_I = imquantize(grey,thresh);
subplot(3, 3, 5), imshow(seg_I,[]);title('Segmentación Grises');

maximo = max(thresh)
black=grey>maximo;
subplot(3, 3, 6), imshow(black);title('Aumentar Grises automático');
white=grey<maximo;
subplot(3, 3, 7), imshow(white);title('Disminuir Grises automático');

%imagen segmentada en una imagen en color - Visualización regiones
%etiquetadas
RGB = label2rgb(seg_I); 	 
subplot(3, 3, 8); imshow(RGB); title('RGB Imagen Segmentada');
% RGB2 = label2rgb(seg_I,'spring','c','shuffle');
% figure; imshow(RGB2); title('RGB Segmented Image');
%%
%Rojo-> límite de los objetos - Verde-> límite de los huecos
im_threshold = black;

[B,L,N,A] = bwboundaries(im_threshold,'noholes');
subplot(3, 3, 9); imshow(im_threshold,[]); hold on;
k=1;
stat = regionprops(im_threshold,'Centroid', 'MajorAxisLength','MinorAxisLength','Extrema');
b = B{k};
c = stat(k).Centroid;
yBoundary = b(:,2);
xBoundary = b(:,1);
cy = c(:,2);
cx = c(:,1);
% plot(B{k}(:,2),B{k}(:,1),'LineWidth',18)
% text(mean(B{k}(:,2)),mean(B{k}(:,1)),num2str(k));
plot(yBoundary, xBoundary, 'g', 'linewidth', 2);
%% CREAR MÁSCARA DEL CONTORNO
x = size(im_threshold,1);
y = size(im_threshold,2);
mask = poly2mask(yBoundary, xBoundary, x, y);
figure; 
subplot(2, 2, 1);imshow(im_threshold); title('im _ threshold');hold on;
plot(yBoundary, xBoundary,'r','LineWidth',3)
subplot(2, 2, 2);imshow(mask); title('Mask', 'FontSize',10);

im_thresholdd = uint8(im_threshold);
maskk = uint8(mask);
im_cropped = im .* maskk;
subplot(2, 2, 3);imshow(im_cropped); title('im _ cropped', 'FontSize',10);
%%
% FIN
