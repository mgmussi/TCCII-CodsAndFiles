%% MAIN PROGRAM
clear all;
close all;
clc;
%% PARAMETROS PARA DATASET
%SELECIONA CANAIS
name_ch = {'F4', 'C4', 'P4', 'F3', 'C3', 'P3'};
canais = [1, 1, 1, 1, 1, 1]; %['F4', 'C4', 'P4', 'F3', 'C3', 'P3']

%SELECIONA INDIVIDUOS
name_individuos = {'I1', 'I2', 'I3', 'I4', 'I5', 'I6'}; %Eu, Luciano, Felipe, Vigano, Profa., Nicolau
use_indiv = [1, 0, 0, 1, 1, 1]; %[I1, I2, I3, I4, I5, I6];

%OPCOES DE BANCO TREINAMENTO
opt_tr = 2;                         %1-Usa tr_per; 2-Usa tr_indiv; 3-Usa arquivos 'M' p/ validacao
tr_indiv =  [1, 0, 0, 1, 1, 1];     %tr_indiv valido apenas se ind_ind = false
tr_per = 2/3;                       %tr_per valido apenas se ind_ind = true

%SELECIONA SE HA BASELINE
baseline = true;
if baseline
    n_class = 3;
else
    n_class = 2;
end

%OPCOES DE FREQ. DE CORTE
fin = 4;    %Frequencia de interesse 1
fou = 35;   %Frequencia de interesse 2

%OPCOES DE JANELA DE ANALISE
tamanhoJanela = 750;    %tamanho janela para computar Wavelet (250 = 1seg)
tamanhoCorte = 750;     %tamanho secao da Wavelet ja computada 
%OBS.: tamanhoCorte =< tamanhoJanela

%OPCAO DE TRANSFORMADA
transformada = 1;   %wavelet = 1 \\ STFT = 0

%OPCOES DE REDUCAO DE IMAGEM WAVELET
ptsFrCanal = 10; %if 35Hz - 10
ptsTempo = 32;
red_size = [ptsFrCanal*6, (tamanhoCorte/125)*ptsTempo]; %[6 canais com x pts., 32 pts. a cada 0.5 segundos]

% fid = fopen('ResultsFilt750_Indiv-Indiv_Freq4-35_Baseline.txt','w+');
h = 1;
for t = find(use_indiv == 1)
    tr_indiv = use_indiv;
    tr_indiv(t) = 0;

    run('files2dataset.m');
    fprintf(fid, '__________\n');
    fprintf(fid, 'Dataset Treinamento:\t{');
    fprintf(fid, '%d, ',size(train{1})); fprintf(fid, '\b\b}\n');
    fprintf(fid, 'Dataset Validacao:\t{');
    fprintf(fid, '%d, ',size(validation{1})); fprintf(fid, '\b\b}\n');
    fprintf(fid, '----------\n\n');
    

    for g = 1:5
        fprintf('\n>>RODAR REDE NEURAL<<\n');
        if transformada
            run('Rede_Neural_Wav.m');
        else
            run('Rede_Neural_STFT.m');
        end
        %% DESEMPENHO FINAL
        YPred = classify(net, validation{1});
        YTest = validation{2};
    %     plotconfusion(YTest, YPred);
        [TP(g,:,h), TN(g,:,h), FP(g,:,h), FN(g,:,h), ACC(g,h), PRE(g,h), SNS(g,h), SPE(g,h), FSC(g,h)]...
            = desempFinal(YPred, YTest, n_class);
        
        fprintf(fid,'It.#%d Ind.%d:\n',g,t);
        fprintf(fid,'Acuracia:\t%.3f%%\n', ACC(g,h)*100);
        fprintf(fid,'Sensibilidade:\t%.3f%%\n', SNS(g,h)*100);
        fprintf(fid,'Precisao:\t%.3f%%\n', PRE(g,h)*100);
        fprintf(fid,'Especificidade:\t%.3f%%\n', SPE(g,h)*100);
        fprintf(fid,'F-Score:\t%.3f%%\n', FSC(g,h)*100);
        fprintf(fid, '\n');
    end
    start = 3-n_class;
    
    fprintf(fid, '\n--------\n');
    fprintf(fid, '::INDIVIDUO %d::\n', t);
    j = 1;
    fprintf(fid, 'C.:\t');
    for i = start:2 fprintf(fid, '%d\t\t\t',j-1); j = j+1; end
    fprintf(fid, '\n');
    
    j = 1;
    fprintf(fid, 'TP:\t');
    for i = start:2 meanNstd(TP(:,j,h)./numel(YPred),1,fid); fprintf(fid, '\t'); j = j+1; end
    fprintf(fid, '\n');
    
    j = 1;
    fprintf(fid, 'TN:\t');
    for i = start:2 meanNstd(TN(:,j,h)./numel(YPred),1,fid); fprintf(fid, '\t'); j = j+1; end
    fprintf(fid, '\n'); 
    
    j = 1;
    fprintf(fid, 'FP:\t');
    for i = start:2 meanNstd(FP(:,j,h)./numel(YPred),1,fid); fprintf(fid, '\t'); j = j+1; end
    fprintf(fid, '\n');
    
    j = 1;
    fprintf(fid, 'FN:\t');
    for i = start:2 meanNstd(FN(:,j,h)./numel(YPred),1,fid); fprintf(fid, '\t'); j = j+1; end
    fprintf(fid, '\n\n');
    
    fprintf(fid, 'ACC:\t'); meanNstd(ACC(:,h),1,fid); fprintf(fid, '\n');
    fprintf(fid, 'SNS:\t'); meanNstd(SNS(:,h),1,fid); fprintf(fid, '\n');
    fprintf(fid, 'PRE:\t'); meanNstd(PRE(:,h),1,fid); fprintf(fid, '\n');
    fprintf(fid, 'SPE:\t'); meanNstd(SPE(:,h),1,fid); fprintf(fid, '\n');
    fprintf(fid, 'FSC:\t'); meanNstd(FSC(:,h),1,fid); fprintf(fid, '\n');
    
    fprintf(fid, '--------\n\n\n');
    h = h+1;
end
fclose(fid);
