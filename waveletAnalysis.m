function [sA, stA] = waveletAnalysis(X, n, wname)
%           WAVELET ANALYSIS
% 
% Wavelet Analysis function that performs wavedec2 of level n on image X.
% By default, n=3.
%

% checking...
switch nargin
    case 1
        N = 3;
        Wname = 'sym1';
    case 2
        N = n;
        Wname = 'sym1';
    case 3
        N = n;
        Wname = wname;
end

if N < 1
    help waveletAnalysis
    disp(N);
    sA = [];
    return;
end

[C,S] = wavedec2(X, N, Wname);
% generate the various levels of the image
indx = 1;
A = zeros(S(end,:));
if nargout > 1
    stA = struct;
    count2 = 1;
end
for k=1:length(S(:,1))-1
    if k==1
        count =1;
        Indx = 1:S(1,1);
        Jndx = 1:S(1,2);
    else 
        count = 3;
        Indx = 1:S(k,1);
        Jndx = 1:S(k,2);
    end
    aux = zeros(S(k,:));
    for r = 1:count
                
        for i=1:S(k,1)
            for j=1:S(k,2)
                aux(i,j) = C(indx);
                indx = indx + 1;
            end
        end
        if nargout > 1
            str = strcat('A',num2str(count2));
            stA.(str) = aux;
            count2 = count2 + 1;
        end
        if count==1
            try
            A(Indx,Jndx) = aux;
            catch
                disp('oops');
            end
            
        else
            switch r
                case 1
                    A(Indx+S(k,1),Jndx) = aux;
                case 2 
                    A(Indx,Jndx+S(k,2)) = aux;
                case 3
                    Indx = Indx + S(k,1);
                    Jndx = Jndx + S(k,2);
                    A(Indx,Jndx) = aux;
            end
        end
    end
end
sA = A;
    

    