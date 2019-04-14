% Demo for document image enhancement (please see README.md first).

img = imread('D:/path/to/your/imagefile');
hsv_img = rgb2hsv(img);
% Extract hsv color channels.
orig_imH = hsv_img(:,:,1); % Hue channel
orig_imS = hsv_img(:,:,2); % Saturation channel
orig_imV = hsv_img(:,:,3); % Value channel

% Extract color channels.
imR = img(:,:,1); % Red channel
imG = img(:,:,2); % Green channel
imB = img(:,:,3); % Blue channel

%calculate enhanged channels
enhImR = image_enhance(imR, 5 );
enhImG = image_enhance(imG, 5 );
enhImB = image_enhance(imB, 5 );

%rehape enhanged channels
enhImR = reshape(enhImR, size(imR));
enhImG = reshape(enhImG, size(imG));
enhImB = reshape(enhImB, size(imB));

enhImg =  cat(3, enhImR, enhImG, enhImB) ;
%imshow(img );
meanPix = mean(enhImg(:));
maxPix = max(enhImg(:));
minPix = min(enhImg(:));
stdPix = std(enhImg(:));
normalized_enhanced_img = uint8( ( (enhImg - meanPix  ) ./ (stdPix ) ) * 255.0  );

%enhImg = im2uint8(enhImg);
%imshow( normalized_enhanced_img );
enhImg_uchar8 = uint8(enhImg );
%imshow( enhImg_uchar8 );

enhGray = rgb2gray(enhImg_uchar8);
%text threshold value. 
textThreshVal = 232;
% get text ids. We will replace original HSV values of the text areas.
replaceIds = enhGray < textThreshVal;

hsv_enhanced_img = rgb2hsv(enhImg_uchar8);
hue_img = hsv_enhanced_img(:,:,1);
satur_img = hsv_enhanced_img(:,:,2);
val_img = hsv_enhanced_img(:,:,3);

%replace original HSV values of the text areas
hue_img (replaceIds) = orig_imH(replaceIds) ;
satur_img (replaceIds) = orig_imS(replaceIds);
val_img(replaceIds) = orig_imV(replaceIds) ;

hsv_enhanced_img = cat(3, hue_img, satur_img, val_img);
% convert it back to RGB
enhImg = hsv2rgb(hsv_enhanced_img);

%display the resulting image
imshowpair(img,(uint8(enhImg * 255 )),'montage')