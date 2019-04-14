function grad = gradientIM(src, method)
% calculates image gradient
%  First filters image and then computes the gradient using the given method.

src2 = medfilt2(src);
src2 = medfilt2(src2);
src2 = medfilt2(src2);
src2 = medfilt2(src2);
[Gx,Gy] = imgradientxy(src2, method );
[Gmag, Gdir] = imgradient(Gx, Gy);
grad = Gmag ;
end

