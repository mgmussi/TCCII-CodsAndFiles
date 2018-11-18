function [linwav] = sepWav(data, time, sidx, tamjan, canais, frq_i, frq_s, shw, freqsum, answ)
    linha = 1;
    n_ch = sum(canais == 1);
    idx_ch = find(canais);
    fprintf('Tamanho dados: (%d, %d)\n', size(data));
    fprintf('Idx chave:\n');
    fprintf('%d, ', sidx);
    fprintf('\nTamanho sidx: (%d, %d)\n', size(sidx));
    fprintf('\n');
    
    %tamjan = tamanho da janela :: 500 -> wavelet [61,500] e [22,500];; 250 -> wavelet [51,250] e [22,250]
    step = 1*tamjan;   %deslocamento da janela
    wav_tot = zeros(22, tamjan, n_ch);
    
    %SET TEMPO FINAL
    if answ == 0
        ini_idx = find(data(:,1) >= time(sidx(1)), 1);
        ini_idx = ini_idx + 500; %Retirar primeiros 2 seg.
%         trl_idx = find(time(sidx(1):end) == sidx(2), 1);
        end_idx = find(data(:,1) >= time(sidx(1) + sidx(2)), 1);
%         fprintf('Initial Idx: %d - Time: %f\nFinal Idx: %d - Time: %f\nTime Range: %f\n',ini_idx, data(ini_idx,1), end_idx, data(end_idx,1), data(end_idx,1)-data(ini_idx,1));
        final = round(data(end_idx,1)-data(ini_idx,1))*250;
        sidx(2) = [];
    else
        final = 1000; %4s (corte dos 1s finais)
    end
    
    wavelet = [];
    waveleT = [];
    
    %PROCESSA AMOSTRAS EM SIDX (TRIGGERS)
    for i = 1:length(sidx)
        ini_idx = find(data(:,1) >= time(sidx(i)), 1);
        ini_idx = ini_idx + 250; %1s (corte dos 1s iniciais)
        for addon = tamjan+250:step:final
            end_idx = ini_idx + tamjan-1;
%             fprintf('.Processando de %d a %d - step: %d\n', ini_idx, end_idx, addon);
            srch = data(ini_idx:end_idx, :);
            ini_idx = ini_idx + step;
            
            meanval = mean(srch,1);
            cnt = 0;
            for k = idx_ch
                cnt = cnt + 1;
                %Retira Media
                srch(:,k+2) = srch(:,k+2) - meanval(k+2);

                [~, frq, hg] = wavplot(srch(:,k+2), 250);
                freq_fin_idx = find(frq<=frq_i, 1)-1;
                frq_ini_idx = find(frq<=frq_s, 1);
            
                if freqsum
                    wav_tot(:,:,cnt) = wav_tot(:,:,cnt) + hg(frq_ini_idx:freq_fin_idx,:);
                end
                wavelet = [wavelet; hg(frq_ini_idx:freq_fin_idx,:)];
                waveleT = [waveleT; hg];
    %             fprintf('Tamanho Wav 1: (%d, %d)\n',size(wavelet));
                clear hg frq;
            end            
            
            %%SAVE IN VOXEL
            linwav(:,:,1,linha) = wavelet;
            linha = linha + 1;
            
            if shw
                figure;
                subplot(1,2,1);
                image(wavelet);
                colormap(gray(240));
                title(sprintf('Wavelet Filtrado de %d a %dHz',frq_i,frq_s));
%                 colorbar;
                %MOSTRA CANAIS INDIVIDUAIS
%                 subplot(7,1,2);
%                 plot(srch(:,1), srch(:,3));
%                 subplot(7,1,3);
%                 plot(srch(:,1), srch(:,4));
%                 subplot(7,1,4);
%                 plot(srch(:,1), srch(:,5));
%                 subplot(7,1,5);
%                 plot(srch(:,1), srch(:,6));
%                 subplot(7,1,6);
%                 plot(srch(:,1), srch(:,7));
%                 subplot(7,1,7);
%                 plot(srch(:,1), srch(:,8));
                
                
                %MOSTRA WAVELET COM TODAS AS FREQS.
                subplot(1,2,2);
                image(waveleT);
                title('Wavelet sem Filtro');
                colormap(gray(240));
                suptitle(sprintf('De %d a %d - %.2fs',ini_idx-step, end_idx, (end_idx-ini_idx-step)/250));
%                 colorbar;

%                 switch answ
%                     case 0
%                         title(sprintf('Baseline %d', addon/tamjan));
%                     case 1
%                         title(sprintf('Mao Direita %d', addon/tamjan));
%                     case 2
%                         title(sprintf('Mao Esquerda %d', addon/tamjan));
%                 end 
            end
            
            wavelet = [];
            waveleT = [];
%             fprintf('>Tmnho: %.10f seg // %d amostras\n', (data(end_idx,1)-data(ini_idx,1)), length(srch));
%             csvwrite(strcat('R_MI_', num2str(exp, '%d'),'_',num2str(i, '%d'), '-', num2str(end_idx/250, '%d'),'.CSV') ,srch);
        end
    end
    if shw
        pause;
        close all;
    end
    %PLOT DA SOMA DE FREQS
    if freqsum
        figure;
        mmax = max(wav_tot(:));
        mmin = min(wav_tot(:));
        n = find(canais == 1);
        for i=1:n_ch
            subplot(2,3,i)
            imagesc((wav_tot(:,:,i)-mmin)/(mmax-mmin));
            switch n(i)
                case 1
                    title('F4');
                case 2
                    title('C4');
                case 3
                    title('P4');
                case 4
                    title('F3');
                case 5
                    title('C3');
                case 6
                    title('P3');
            end
        end
        colormap(jet(240));
%         colorbar;
        pause;
        close all;
    end
    
%%TO SAVE IN LINE
%wavelet = wavelet';
%linwav(LIN,:) = wavelet(:)';
end