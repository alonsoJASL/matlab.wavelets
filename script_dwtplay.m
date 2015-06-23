% script file : Wavelet playground
%
close all;
clc;

warning('off','all');

%fname_osx = strcat('~/Documents/propio/PhD/ISBI/ISBI_Challenge/',...
%    'ChallengeDataSets/Fluo-N2DH-GOWT1/01/t000.tif');
%I = imread(fname_osx);

fname = strcat('/media/jsolisl/DATA/ISBI_CELLTRACKING/2015/',...
    'ChallengeDatasets/Fluo-C2DL-MSC/01/t000.tif');
    wname = 'coif1';
X = imread(fname);
X = (X - mean(X(:)));
X = imfilter(X, fspecial('gaussian'));

% X contains the loaded image. 
% map contains the loaded colormap. 
%nbcol = size(map,1);

% Perform single-level decomposition 
% of X using db1. 
[cA1,cH1,cV1,cD1] = dwt2(X,wname);

% Images coding. 
% cod_X = wcodemat(X,nbcol); 
% cod_cA1 = wcodemat(cA1,nbcol); 
% cod_cH1 = wcodemat(cH1,nbcol); 
% cod_cV1 = wcodemat(cV1,nbcol); 
% cod_cD1 = wcodemat(cD1,nbcol); 
dec2d = [cA1,cH1;cV1,cD1];

figure, imagesc(abs(dec2d));

%% READ the image
clear all
close all
clc
fname = strcat('/media/jsolisl/DATA/ISBI_CELLTRACKING/2015/',...
    'ChallengeDatasets/Fluo-N2DH-GOWT1/01/t000.tif');
wname = 'sym1';
X = imread(fname);
% X = (X - mean(X(:)));
X = imfilter(X, fspecial('gaussian'));

[C,S] = wavedec2(X,3,wname);

%% TWEAK IT
%indx = randi([length(C)/(2^randi([5 15])) length(C)], 1, 1000);
indx = length(C)/2:length(C);
CC = C;
CC(indx) = max(C);

XX = waverec2(CC,S,wname);
figure;
subplot(1,2,1);
imagesc(abs(X));
colormap pink
title('Original Image');
subplot(1,2,2);
imagesc(abs(XX));
colormap pink
title('Waveleted!!');

%% 
f = [0 0 0; 0 1 0; 0 0 0] - fspecial('laplacian');
XX = imfilter(XX, f);
% lev = multithresh(XX,2);
lev = kapursegment(uint8(XX));
seg = imquantize(uint8(XX), lev);
rgb = label2rgb(seg);

figure, imagesc(rgb);

%% PRESENT ALL THE LEVELS
indx=1;
for i=1:S(1,1); for j=1:S(1,2); A1(j,i) = C(indx);
        indx=indx+1;end;end;
for i=1:S(2,1);for j=1:S(2,2); A2(j,i) = C(indx);
        indx=indx+1;end;end;
for i=1:S(2,1);for j=1:S(2,2); A3(j,i) = C(indx);indx=indx+1;end;end;
for i=1:S(2,1);for j=1:S(2,2); A4(j,i) = C(indx);indx=indx+1;end;end;
for i=1:S(3,1);for j=1:S(3,2); A5(j,i) = C(indx);indx=indx+1;end;end;
for i=1:S(3,1);for j=1:S(3,2); A6(j,i) = C(indx);indx=indx+1;end;end;
for i=1:S(3,1);for j=1:S(3,2); A7(j,i) = C(indx);indx=indx+1;end;end;
for i=1:S(4,1);for j=1:S(4,2); A8(j,i) = C(indx);indx=indx+1;end;end;
for i=1:S(4,1);for j=1:S(4,2); A9(j,i) = C(indx);indx=indx+1;end;end;
for i=1:S(4,1);for j=1:S(4,2); A10(j,i) = C(indx);indx=indx+1;end;end;

A8 = imfilter(A8, fspecial('prewitt')')-A8;
A9 = imfilter(A9, fspecial('prewitt'))-A9;
A10 = imfilter(A10, fspecial('gaussian'))-A10;
A = [[[A1 A2; A3 A4] A5; A6 A7] A8; A9 A10];

CC = C;
CC(end-length(A9(:))-length(A8(:))-length(A10(:))+1:end) = ...
    [A8(:)' A9(:)' A10(:)'];

XX = waverec2(CC,S,wname);
XX = imfilter(XX, fspecial('disk',4));
cmapsea = [0 1 1;0 0.01 0.81; 0 0 0];
cmapland = [0 0 0; 0.7 0.01 0; 0.8 0.8 0; 1 1 0.8];
figure
imagesc(XX); demcmap(XX, 256, cmapsea, cmapland);





