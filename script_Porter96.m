% Script file: Segmentation of textures through feature spaces and wavelets
% Based on 1996 Porter et. al.
%

% READ the image
close all
clc
fname = strcat('/media/jsolisl/DATA/ISBI_CELLTRACKING/2015/',...
     'ChallengeDatasets/Fluo-N2DH-GOWT1/01/t000.tif');
%fname = strcat('/media/jsolisl/DATA/MACROPHAGES/pair1.tif');

wname = 'sym1';
numClusters = 3;
filt = fspecial('laplacian',0.5);
pasall = [0 0 0;0 1 0;0 0 0];
Xoriginal = imread(fname);

if size(Xoriginal,3)>1
    Xoriginal = rgb2gray(Xoriginal);
end
%%
Y = imfilter(Xoriginal,pasall);
X = imfilter(Xoriginal,pasall);
X = (X - mean(X(:)));

% full decomposition on A, each submatrix on s (i.e s.A1, s.A2, ..., s.A10)
tic
[A, s] = waveletAnalysis(X);
fields = fieldnames(s);

% compute ratio R = (eC(1)+eC(2)+eC(3)+eC(4))/(eC(5)+eC(6)+eC(7))
[R, eC] = channelEnergy(s,X);
[M, C] = kmeans(eC(:,2:end), numClusters, 'EmptyAction', 'singleton');

[m,n] = size(X);
seg = zeros(m,n);
idx = 1;

for i=1:m
    for j=1:n
        seg(j,i) = M(idx);
        idx = idx + 1;
    end
end
Portertime = toc;

% computing Otsu's solution for comparison.
tic
lev = multithresh(Y,2);
segOtsu = imquantize(Y,lev);
rgb = label2rgb(segOtsu);
otsutime = toc;
%
subplot(1,3,1);
imagesc(Xoriginal);
title('Original Image');
subplot(1,3,2);
imagesc(seg);
title('Segmented with Porter"s');
subplot(1,3,3)
imagesc(rgb);
title('Segmented with Otsu"s');



