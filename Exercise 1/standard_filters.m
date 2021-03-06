function [X] = standard_filters(I, filters, side, sigma)
%% =========== Part 1: Standard Filters =============
%  taking as parameters:
%the image I
%a cell array F of strings
% the side a of the square used as kernel (used for �mean� and �std�)
% a standard deviation s (used for �gaussian� and �LoG�)
% returns the cell array X giving the feature responses for the filters specified in the cell array F.

X = {};

rows = size(I,1);
columns = size(I,2);
fcount = size(filters,2);

for f = 1:fcount
    if strcmp(filters(f),'straight derivatives')
        DeltaRow(1,:) = (I(1+1, :))./2;    
        for i = 2:rows-1
            DeltaRow(i,:) = (I(i+1, :)- I(i-1, :))./2;    
        end
        DeltaRow(rows,:) = (-I(rows-1, :))./2;    
        
        DeltaColumn(:,1) = (I(:,1+1))./2;    
        for j = 2:columns-1
            DeltaColumn(:,j) = (I(:,j+1)- I(:,j-1))./2; 
        end
        DeltaColumn(:,columns) = (I(:,columns-1))./2; 
        
        Delta = {};
        Delta = [Delta;[DeltaRow;DeltaColumn]];
        X = [X;Delta];
        imshow(DeltaRow);
        imshow(DeltaColumn);

    elseif strcmp(filters(f),'diagonal derivatives')
        
        DeltaDiagRow(1,columns) = 0;
        DeltaDiagRow(rows,1) = 0;
        DeltaDiagRow(1,1) = (I(1+1, 1+1))./2;
        DeltaDiagRow(rows,columns) = (-I(rows-1, columns-1))./2;
        
        for j = 2:columns-1
            DeltaDiagRow(1,j) = (I(1+1, j+1))./2;
            DeltaDiagRow(rows,j) = (-I(rows-1, j-1))./2;
        end
            
        for i = 2:rows-1
            for j = 2:columns-1
                DeltaDiagRow(i,j) = (I(i+1, j+1)- I(i-1, j-1))./2;
            end
        end   
        
        DeltaDiagColumn(1,1) = 0;
        DeltaDiagColumn(rows,columns) = 0;
        DeltaDiagColumn(1,columns) = (I(1+1, columns-1))./2;
        DeltaDiagColumn(rows,1) = (-I(rows-1, 1+1))./2;
        
        for j = 2:columns-1
            DeltaDiagColumn(1,j) = (I(1+1, j-1))./2;
            DeltaDiagColumn(rows,j) = (-I(rows-1, j+1))./2;
        end
        
        for i = 2:rows-1
            for j = 2:columns-1
                DeltaDiagColumn(i,j) = (I(i+1, j-1)- I(i-1, j+1))./2;
            end
        end  
        
        DeltaDiag = {};
        DeltaDiag = [DeltaDiag;[DeltaDiagRow;DeltaDiagColumn]];
        X = [X;DeltaDiag];
        
        imshow(DeltaDiagRow);
        imshow(DeltaDiagColumn);
        
    elseif strcmp(filters(f),'mean')
        
        % Use the Matlab function colfilt  processes the image A by rearranging each side-by-side block of I into a column of a temporary matrix, and then applying the function mean to this matrix.
        % The function colfilt zero-pads A, if necessary and saves memory. 
        meanVal = colfilt(I,[side side],'sliding',@mean);
        meanImage = mat2gray(meanVal);
        X = [X;meanVal];        
        imshow(meanImage);

    elseif strcmp(filters(f),'std')
        
        stdVal = colfilt(double(I),[side side],'sliding',@std);
        stdValImage = mat2gray(stdVal);
        X = [X;stdVal];
        imshow(stdValImage);
        
    elseif strcmp(filters(f),'gaussian')
        
        hsize = 6*sigma + 1;
        K = fspecial('gaussian', floor(hsize), sigma);
        crossCorelationProduct = imfilter(I,K,'replicate','same');
        crossCorelationProductImage = mat2gray(crossCorelationProduct);
        imshow(crossCorelationProductImage);
        X = [X;crossCorelationProduct];
        imshow(crossCorelationProduct);
        
    elseif strcmp(filters(f),'LoG')
        
        hsize = 6*sigma + 1;
        K = fspecial('log', floor(hsize), sigma);
        crossCorelationProduct = imfilter(I,K,'replicate','same');
        X = [X;crossCorelationProduct];
        imshow(crossCorelationProduct);
        
    elseif strcmp(filters(f),'all')
        
        hsize = side;
        K = fspecial('average', hsize);
        crossCorelationProduct = imfilter(I,K,'replicate','same');
        X = [X;crossCorelationProduct];
        imshow(crossCorelationProduct);
       
        radius = (side-1)/2;
        K = fspecial('disk', radius);
        crossCorelationProduct = imfilter(I,K,'replicate','same');
        X = [X;crossCorelationProduct];
        imshow(crossCorelationProduct);
        
        hsize = 6*sigma + 1;
        K = fspecial('gaussian', floor(hsize), sigma);
        crossCorelationProduct = imfilter(I,K,'replicate','same');
        X = [X;crossCorelationProduct];
        imshow(crossCorelationProduct);
        
        K = fspecial('laplacian');
        crossCorelationProduct = imfilter(I,K,'replicate','same');
        X = [X;crossCorelationProduct];
        imshow(crossCorelationProduct);
        
        K = fspecial('log', floor(hsize), sigma);
        crossCorelationProduct = imfilter(I,K,'replicate','same');
        X = [X;crossCorelationProduct];
        imshow(crossCorelationProduct);
        
        K = fspecial('motion');
        crossCorelationProduct = imfilter(I,K,'replicate','same');
        X = [X;crossCorelationProduct];
        imshow(crossCorelationProduct);
        
        K = fspecial('prewitt');
        crossCorelationProduct = imfilter(I,K,'replicate','same');
        X = [X;crossCorelationProduct];
        imshow(crossCorelationProduct);
        
        K = fspecial('sobel');
        crossCorelationProduct = imfilter(I,K,'replicate','same');
        X = [X;crossCorelationProduct];
        imshow(crossCorelationProduct);
        
    end
end

end
