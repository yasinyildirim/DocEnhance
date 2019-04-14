function [J, costGrad] = costFunctionIE(Gain_Offset, srcVec, srcSize, k1, k2, lambda)
%COSTFUNCTIONIE Calculates the cost function.
%  
m = size(Gain_Offset, 1);
Gain = Gain_Offset(1:m/2);
Offset = Gain_Offset(m/2 + 1:m);

maxVal = 255.0;

P = double(srcVec) .* Gain + Offset;

diffP = ( (P - maxVal) .^ 2 );
J1 = ( sum( diffP(:) ) );

grad = gradientIM( (reshape(srcVec, srcSize)), 'central');
grad = grad(:) .* (1/8);

grad_P = gradientIM( (reshape(P, srcSize)), 'central');
grad_P = grad_P(:) .* (1/8);

gradDiffP = ( (grad_P - grad) .^ 2 ); 
%display image for debugging
%imshow( uint8(reshape(gradDiffP, srcSize)) );
J2 = ( sum( gradDiffP(:) ) );

J3_reg = lambda .* ( ( sum(Gain .^2) + sum(Offset .^2) ) );

J = ( k1 .* J1 + k2 .* J2 + J3_reg ) ./ ((m/2));

gradJ1_Offset = 2 .* (P - maxVal) ;
gradJ2_Offset = 2 .* (grad_P - grad);
gradJ3_reg_Offset = 2 .* lambda .* Offset;
gradJ1_Gain = 2 .* (P - maxVal) .* double(srcVec);

gradJ2_Gain = 2 .* (grad_P - grad) .* ( double(grad)  ) ;
gradJ3_reg_Gain = 2 .* lambda .* Gain;

costGrad_Gain = ( k1 .* gradJ1_Gain + k2 .* gradJ2_Gain + gradJ3_reg_Gain )  ./ (m/2);
costGrad_Offset = ( k1 .* gradJ1_Offset + k2 .* gradJ2_Offset + gradJ3_reg_Offset )  ./ (m/2);

costGrad = [costGrad_Gain ; costGrad_Offset];

end

