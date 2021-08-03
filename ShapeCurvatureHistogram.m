function [feature_vector,thetaXYEdgePixels,CurvEdgePixels,Gdir,BW,Igray] = ...
    ShapeCurvatureHistogram(image,sigma,threshold,windowSize,NumberOfBins,histnorm)

%%***********************************************************************%
%*                     Shape curvature histogram                        *%
%*          Creates a curvature histogram of shapes features.           *%
%*                                                                      *%
%* Code author: Preetham Manjunatha                                     *%
%* Github link: https://github.com/preethamam                           *%
%* Date: 08/02/2021                                                     *%
%************************************************************************%
%
%************************************************************************%
%
% Usage: [feature_vector,thetaXYEdgePixels,CurvEdgePixels,Gdir,BW,Igray] = ...
%        ShapeCurvatureHistogram(image,sigma,threshold,windowSize,NumberOfBins,histnorm)
%
% Inputs: image         - color / grayscale / binary image
%         sigma         - standard deviation of the canny edge detector (optional) 
%         threshold     - canny edge detector threshold | 2-element vector
%         windowSize    - sliding window size 
%         NumberOfBins  - number of histroam bins size
%         histnorm      - histogram normalization type (default: count)
% Outputs: feature_vector       - histogram of the curvature values
%          thetaXYEdgePixels    - orientation of pixels
%          CurvEdgePixels       - curvature of edge pixels
%          Gdir                 - gradient direction
%          BW                   - binray image
%          Igray                - grayscale image
% 
% 
% Based on the paper:
% Gadermayr, Michael, Michael Liedlgruber, Andreas Uhl, and Andreas Vécsei.
% "Shape curvature histogram: A shape feature for celiac disease diagnosis." 
% In International MICCAI Workshop on Medical Computer Vision, pp. 175-184. 
% Springer, Cham, 2013.

% Convert to grayscale
if (size(image,3) > 2)
    Igray = rgb2gray(image);
else
    Igray = image;
end

% Step 1: Edge detection
BW = edge(Igray,'Canny',threshold, sigma);

% Step 2: Gradient directions
[Gmag,Gdir] = imgradient(Igray,'sobel'); %#ok<*ASGLU>
[Gx,Gy] = imgradientxy(Igray,'sobel');

% Step 3: Computation of orientation
thetaXY     = atan2(Gy,Gx);
thetaXYEdgePixels = BW .* thetaXY;

% Step 4: Computation of curvature
CurvXY = nlfilter(thetaXY, [windowSize(1) windowSize(2)], @curvXY);
CurvEdgePixels = BW .* CurvXY;

% Step 5: Generation of feature vector
C = CurvEdgePixels(:);
C = C(C~=0);
[counts,edges,bin] = histcounts(C,NumberOfBins,'Normalization',histnorm);
feature_vector = counts/numel(C);

% Sliding window function
function out = curvXY(inputMatrix)
        thetaMax = max(max(inputMatrix));
        thetaMin = min(min(inputMatrix));

        deltaXY = max(thetaMax,thetaMin) - min(thetaMax,thetaMin);

        if(deltaXY <= pi)
            out = deltaXY;
        elseif (deltaXY > pi)
            out = 2*pi - deltaXY;
        end
end
end


