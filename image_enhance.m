function enhanced_im = image_enhance(src, reduceFactor)
% IMAGE_ENHANCE takes document image as an argument and returns the enhanced image.
%    works by solving the following Poisson's equation with conjugate gradient descent:
%    argmin_J{k_1 * \sum_{x,y}{\left \| J(x,y) - 255  \right \|^2} + k_2 * \sum_{x,y}{\left \| \nabla J(x,y) - \nabla I(x,y) \right \|^2}}.
%    calculations are performed in downsampled image by factor of reduceFactor.
srcVec = src(:);
im = double(src) ;
for rc1 = 1:reduceFactor
% reduce image
    im = impyramid(im, 'reduce');
%im = impyramid(im, 'reduce');
end

epsilon_init = 1.012;
initial_Gain = rand(size(im,1), size(im,2), 1) * 2 * epsilon_init - epsilon_init;
epsilon_init = 144.5 ;
initial_Offset = rand(size(im,1), size(im,2), 1) * 2 * epsilon_init - epsilon_init;

initial_GO = [initial_Gain(:) ; initial_Offset(:) ];
%  Set options for fmincg
options = optimset('GradObj', 'on', 'MaxIter', 20);
imVec = im(:);  
%  Run fminunc to obtain the optimal Gain and Offset parameters
%  This function will return Gain_Offset and the cost 
[Gain_Offset] = ...
	fmincg(@(t)(costFunctionIE(t, imVec, size(im), 1.5, 1.5, 0.0008)), initial_GO, options);

m = size(Gain_Offset, 1);
Gain = Gain_Offset(1 : m/2);
Offset = Gain_Offset(m/2 + 1 : m);

Gain_im = reshape(Gain, size(im));
Offset_im = reshape(Offset, size(im));

for rc = 1:reduceFactor
    Gain_im = impyramid(Gain_im, 'expand');
    Gain_im = padarray(Gain_im,[1 1],'replicate','post');
    %imresize uses bicubic interpolation.
    %Offset_im = imresize(Offset_im, 2);
    Offset_im = impyramid(Offset_im, 'expand');
    Offset_im = padarray(Offset_im,[1 1],'replicate','post');
end

Gain = Gain_im(:);
Offset = Offset_im(:);
% J(x,y) = I(x,y) * Gain(x,y) + Offset(x,y)
enhanced_im = (double(srcVec) .* Gain + Offset) ;
end