function [R,eC] = channelEnergy(s, X, opt)
% Part of the Porter 96 implementation
%
% SEE ALSO waveletAnalysis.m
%
fields = fieldnames(s);
if nargin == 2
    opt = 1;
end
        eC = zeros(numel(X), length(fields)+1);
        eC(:,1) = X(:);
        [M, N] = size(X);
switch opt
    case 1 % Normal interpolation.
        for k=1:length(fields)
            [m, n] = size(s.(fields{k}));
            [xx, yy] = meshgrid(1:M/m:M, 1:N/n:N);
            [x,y] = meshgrid(1:M, 1:N);
            Ak = interp2(xx,yy, s.(fields{k}), x,y);
            Ak(isnan(Ak)) = 0;
            eC(:,k+1) = abs(Ak(:));
        end
    case 2 % expanding of matrices
        for k=1:length(fields)
            [m, n] = size(s.(fields{k}));
            [xx, yy] = meshgrid(1:M/m:M, 1:N/n:N);
            [x,y] = meshgrid(1:M, 1:N);
            Ak = interp2(xx,yy, s.(fields{k}), x,y);
            Ak(isnan(Ak)) = 0;
            eC(:,k+1) = abs(Ak(:));
        end
    otherwise
        help channelEnergy
        R = [];
        eC = [];
        return
end
% compute ratio R = (eC(1)+eC(2)+eC(3)+eC(4))/(eC(5)+eC(6)+eC(7))
R = (eC(:,2)+eC(:,3)+eC(:,4)+eC(:,5))./(1+eC(:,6)+eC(:,7)+eC(:,8));
