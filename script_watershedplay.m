% script file
%
clear all
close all
clc

OSX = true; % true if I'm working on a mac
if OSX == false
    fname = strcat('/media/jsolisl/DATA/ISBI_CELLTRACKING/2015/',...
        'ChallengeDatasets/DIC-C2DH-HeLa/01/t000.tif');
else
%     fname = strcat('~/Documents/propio/PhD/ISBI/ISBI_Challenge/',...
%         'ChallengeDataSets/Fluo-N2DH-GOWT1/01/t000.tif');
fname = 'images/t000.tif';
end
%
I= imread(fname);
X = imfilter(I, fspecial('disk'));

%[A, s] = waveletAnalysis(X);

hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(X), hy, 'replicate');
Ix = imfilter(double(X), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
figure
imagesc(gradmag)
title('Gradient magnitude (gradmag)');

L = watershed(gradmag);
Lrgb = label2rgb(L);
figure, imagesc(Lrgb);
title('Watershed transform of gradient magnitude (Lrgb)');

se = strel('disk', 20);
Io = imopen(X, se);
figure
imagesc(Io)
title('Opening (Io)');

Ie = imerode(X, se);
Iobr = imreconstruct(Ie, X);
figure
imagesc(Iobr);
title('Opening-by-reconstruction (Iobr)');

Ioc = imclose(Io, se);
figure
imagesc(Ioc);
title('Opening-closing (Ioc)');

Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
figure
imagesc(Iobrcbr);
title('Opening-closing by reconstruction (Iobrcbr)');

fgm = imregionalmax(Iobrcbr);
figure
imagesc(fgm);
title('Regional maxima of opening-closing by reconstruction (fgm)')

%
subplot(1,2,1)
imagesc(I);
subplot(1,2,2)
imagesc(bwlabeln(fgm));

