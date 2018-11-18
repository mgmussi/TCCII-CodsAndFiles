function [reducted] = redInterpCub(wavelets, tamanho)
%REDINTERPCUB funcao para reducao cubica de uma matriz ou um voxel. 
%       [reducted] = redInterpCub(wavelets, tamanho)
%As entradas para esta funcao devem ser:
% - 'wavelets'  matriz ou voxel com tamanhos [M,N]
% - 'tamanho'   vetor [J,K] em que J<= M e K<= N
    len_vox = size(wavelets, 4);
    tam_vox = [size(wavelets,1), size(wavelets,2)];
    
    if sum(tamanho > tam_vox)
        if tamanho(1) > size(wavelets,1)
            errMsg = sprintf('Reducao pretendida na dimensao 1 (%d) eh maior que matriz de entrada (%d)', tamanho(1), tam_vox(1));
        elseif tamanho(2) > size(wavelets,2)
            errMsg = sprintf('Reducao pretendida na dimensao 2 (%d) eh maior que matriz de entrada (%d)', tamanho(2), tam_vox(2));
        elseif tamanho(2) > size(wavelets,2)
            errMsg = sprintf('Reducao pretendida nas dimensoes (%d, %d) sao incompativeis com matriz de entrada (%d, %d)', tamanho, tam_vox);
        end
        error(errMsg);
    end
    
    for j = 1:len_vox
        reducted(:,:,1,j) = imresize(wavelets(:,:,1,j), tamanho, 'cubic');
    end
end