%% Start parameters
%--------------------------------------------------------------------------
clear; close all; clc;
Start = tic;

%% Inputs
% Read image
I = imread('marsh_0.jpg');
sigma = 1.41;
threshold = [];
windowSize = [3 3];
NumberOfBins  = 8;
histnorm = 'count';

% Shape Curvature Histogram (SCH) function callback
[feature_vector,thetaXYEdgePixels,CurvEdgePixels,Gdir,BW, Igray] = ...
    ShapeCurvatureHistogram(I,sigma,threshold,windowSize,NumberOfBins,histnorm);

% Superpose the image and edges
Isuperpose = imoverlay(Igray, BW, [0 0 0]);

%% Show paper like figure
figure;
ax1 = subplot(2,3,1); imshow(Igray); title('Original image')
ax2 = subplot(2,3,2); imshow(BW);    title('Edge map')
ax3 = subplot(2,3,3); imshow(Isuperpose);  title('Superimposed edges')
ax4 = subplot(2,3,4); imagesc(Gdir); colormap(ax4,jet); title('Gradient directions'); axis equal; axis tight; axis off;
ax5 = subplot(2,3,5); imagesc(thetaXYEdgePixels); colormap(ax5,jet); title('Orientations'); axis equal; axis tight; axis off;
ax6 = subplot(2,3,6); imagesc(CurvEdgePixels); colormap(ax6,jet); title('Curvature map'); axis equal; axis tight; axis off;
linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'xy')

%% End parameters
%--------------------------------------------------------------------------
Runtime = toc(Start);
