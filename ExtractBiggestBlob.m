function biggestBlob = ExtractBiggestBlob(binaryImage)
% fontSize = 12;

% Get the dimensions of the image.
% numberOfColorBands should be = 1.

% Display the original gray scale image.
% subplot(1, 2, 1);
% imshow(myImage, []);
% title('Imagen Original en Escala de Grises', 'FontSize', fontSize);
% 
% % Imagen en escala de grises
% im_gray = im2gray(myImage);
% 
% % Imagen con más contraste
% im_gray = imadjust(im_gray);
% 
% % Calcular 2 niveles de Umbral
% thresh = multithresh(im_gray,2);

% Imagen binarizada
% maximum = max(thresh);
% binaryImage = im_gray > maximum;

% Rellenar huecos
binaryImage = imfill(binaryImage, 'holes');
% subplot(1, 2, 3);imshow(binaryImage, []);title('Binary Image', 'FontSize', fontSize);

% Obtiene todas las propiedades del blob.  Sólo puede pasar en la imagen 
% original en la versión R2008a y posterior.
% [labeledImage, numberOfBlobs] = bwlabel(binaryImage);
% blobMeasurements = regionprops(labeledImage, 'area', 'Centroid');

% Obtener las áreas
% allAreas = [blobMeasurements.Area]; % No semicolon so it will print to the command window.
% menuOptions{1} = '0'; % Add option to extract no blobs.

% Mostrar las áreas en la imagen
% for k = 1 : numberOfBlobs           % Loop through all blobs.
% 	thisCentroid = [blobMeasurements(k).Centroid(1), blobMeasurements(k).Centroid(2)];
% 	message = sprintf('Area = %d', allAreas(k));
% 	text(thisCentroid(1), thisCentroid(2), message, 'Color', 'r');
% 	menuOptions{k+1} = sprintf('%d', k);
% end

% Número de .
numberToExtract = 1;

% Ask user if they want the smallest or largest blobs.
% sizeOption = 'Largest';

%---------------------------------------------------------------------------
% Extract the largest area using our custom function ExtractNLargestBlobs().
% This is the meat of the demo!
biggestBlob = ExtractNLargestBlobs(binaryImage, numberToExtract);
%---------------------------------------------------------------------------

% Display the image.
% subplot(1, 2, 2);
% imshow(biggestBlob, []); title('Región del Tumor', 'FontSize', fontSize);
% Make the number positive again.  We don't need it negative for smallest extraction anymore.
% numberToExtract = abs(numberToExtract);
% if numberToExtract == 1
% 	caption = sprintf('Extracted %s Blob', sizeOption);
% elseif numberToExtract > 1
% 	caption = sprintf('Extracted %d %s Blobs', numberToExtract, sizeOption);
% else % It's zero
% 	caption = sprintf('Extracted 0 Blobs.');
% end


function binaryImage = ExtractNLargestBlobs(binaryImage, numberToExtract)
try
	% Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
	[labeledImage, ~] = bwlabel(binaryImage);
%     labeledImage;
%     numberOfBlobs;
	blobMeasurements = regionprops(labeledImage, 'area');
	% Get all the areas
	allAreas = [blobMeasurements.Area];
	if numberToExtract > 0
		% For positive numbers, sort in order of largest to smallest.
		% Sort them.
		[~, sortIndexes] = sort(allAreas, 'descend');
	elseif numberToExtract < 0
		% For negative numbers, sort in order of smallest to largest.
		% Sort them.
		[~, sortIndexes] = sort(allAreas, 'ascend');
		% Need to negate numberToExtract so we can use it in sortIndexes later.
		numberToExtract = -numberToExtract;
	else
		% numberToExtract = 0.  Shouldn't happen.  Return no blobs.
		binaryImage = false(size(binaryImage));
		return;
	end
	% Extract the "numberToExtract" largest blob(a)s using ismember().
	biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
	% Convert from integer labeled image into binary (logical) image.
	binaryImage = biggestBlob > 0;
catch ME
	errorMessage = sprintf('Error in function ExtractNLargestBlobs().\n\nError Message:\n%s', ME.message);
	fprintf(1, '%s\n', errorMessage);
	uiwait(warndlg(errorMessage));
end
