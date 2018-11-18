function [wav_split, true_split, id_split] = wavlet_split(wav_mat, true_mat, id_mat, n)
    wav_split = [];
    cont = 1;
    if n == size(wav_mat, 2)
        warning(sprintf('''n'' eh igual ao tamanho temporal de ''wav_mat''\nNao ha necessidade de recorte.\n'));
        wav_split = wav_mat;
        true_split = true_mat;
        id_split = id_mat;
        return 
    end
    for i = 1:size(wav_mat,4)
        for k = 0:n:size(wav_mat,2)-n
            wav_split(:,:,1,cont) = wav_mat(:, k+1:k+n, 1, i);
            true_split(1,cont) = true_mat(1,i);
            id_split(1,cont) = id_mat(1,i);
            cont = cont + 1;
        end
    end
end