%% FILE2DATASET
% ----- FLAGS de TRIGGERS ----
% OVTK_StimulationId_ExperimentStart    = 0x8001 = 32769
% OVTK_StimulationId_BaselineStart      = 0x8007 = 32775 <<<
% OVTK_StimulationId_Beep               = 0x8202 = 33282
% OVTK_StimulationId_BaselineStop       = 0x8008 = 32776 <<<
% OVTK_GDF_Start_Of_Trial               = 0x0300 = 768
%>OVTK_GDF_Left                         = 0x0301 = 769   <<<
%>OVTK_GDF_Right                        = 0x0302 = 770   <<<
% OVTK_GDF_Cross_On_Screen              = 0x0312 = 786
% OVTK_GDF_Feedback_Continuous          = 0x030D = 781   <<<
%>OVTK_GDF_End_Of_Trial                 = 0x0320 = 800
% OVTK_GDF_End_Of_Session               = 0x03F2 = 1010
% OVTK_StimulationId_Train              = 0x8201 = 33281
% OVTK_StimulationId_ExperimentStop     = 0x8002 = 32770

%% VERDADE
% 0 - Baseline
% 1 - Braco Direito
% 2 - Braco Esquerdo
%% INICIALIZACAO
train_vox = [];
train_truevox = [];
train_lbl = [];
val_vox = [];
val_truevox = [];
val_lbl = [];
logicPrint = {'false', 'true'};

%RESUMO OPCOES
fprintf('---OPCOES SELECIONADAS---\n');
fprintf('# %d Individuos:\t\t| ', sum(use_indiv == 1));
fprintf('%s | ', name_individuos{find(use_indiv)});
fprintf('\n');
switch opt_tr
    case 1
        fprintf('# %% de Treinamento:\t%.3f%%\n', tr_per*100);
    case 2
        fprintf('# %d Indiv. Treinamento: | ', sum(tr_indiv == 1));
        fprintf('%s | ', name_individuos{find(tr_indiv)});
        fprintf('\n');
    case 3
        fprintf('Utilizando arquivos ''_M_''\n');
end
fprintf('# %d Canais:\t\t| ', sum(canais == 1));
fprintf('%s | ', name_ch{find(canais)});
fprintf('\n');
fprintf('# Baseline:\t\t%s\n', logicPrint{baseline+1});

fprintf('# Frequencias de Corte:\t[%2.2f, %2.2f]\n', fin, fou);
fprintf('# Tamanho Janela:\t%2.2fs\n', tamanhoJanela/250);
fprintf('# Tamanho Corte W:\t%2.2fs\n', tamanhoCorte/250);
fprintf('# Reducao de Img.:\t(%d x %d)\n', [red_size]);
fprintf('# ----- #\n# ----- #\n-\n-\n');
% pause;

%% TRATAMENTO DE ARQUIVOS
files = dir('coletas/*.csv');
% files = dir('I5-6-MI-UnFilter[2018.11.03-16.10.54].csv');
for k = 1:2:size(files,1)
    clear chann chann2 r_idx l_idx bli_idx ble_idx d e;
    fprintf('--Arquivo %s:\n', files(k).name);
    %% Seleciona Arquivos
    indiv = files(k).name(2);
    if ~use_indiv(str2num(indiv))
        fprintf('Pulando individuo %2.d\n-----\n', str2num(indiv));
        continue
    end
    if opt_tr ~= 3 && strcmp(files(k).name(4), 'M')
        fprintf('Pulando ensaio ''M'' de individuo %2.d\n-----\n', str2num(indiv));
        continue
    end
    a = readtable(files(k).name, 'Delimiter', ',');
    %% Info Canais
    chann = table2array(a(:,1:13)); %c = cellfun(@str2num,chann);
    %APLICA FILTRO
    chann2 = Filters(chann);
%     %Filtro Pre-enfase >> Dica do Adami
%     alp = 0.5;
%     %Recebe msms tempos
%     chann2(:,1:2) = chann(:,1:2);
%     for i = 2:size(chann,1)
%        chann2(i,3:10) =  chann(i,3:10) - alp*chann(i-1,3:10);
%     end
    %% Tratamento de Triggers
    [e, d] = separaTrigger(a);

    %% Encontra Seccoes de MI
    r_idx = find(d(:) == 770);
    l_idx = find(d(:) == 769);
    bli_idx = find(d(:) == 32775);
    ble_idx = find(d(:) == 32776);

     %% Separa Baseline
    if baseline
        answ = 0;
        if transformada
            [lin_w] = sepWav(chann2, e, [bli_idx, ble_idx], tamanhoJanela,...
                                          canais, fin, fou, false, false, answ);
            trw_w = ones(1, size(lin_w,4)) * answ;
            id_w = ones(1, size(lin_w,4)) * str2num(indiv);
            [lin, trw, id] = wavlet_split(lin_w, trw_w, id_w, tamanhoCorte);
            [lin] = redInterpCub(lin, red_size);
        else
            [lin] = sepSTFT(chann2, e, [bli_idx, ble_idx], tamanhoJanela,...
                                          canais, fin, fou, false, false, answ);
            trw = ones(1, size(lin,4)) * answ;
            id = ones(1, size(lin,4)) * str2num(indiv);
            [lin] = redInterpCub(lin, [7*6,size(lin,2)]);
        end
        
        switch opt_tr
            case 1
                %training
                tr_idx = randperm(size(lin,4), round(tr_per * size(lin,4)));
                train_vox = cat(4, train_vox, lin(:,:,:,tr_idx));
                train_truevox = [train_truevox; trw(tr_idx)'];
                train_lbl = [train_lbl; id(tr_idx)'];
                %validation
                val_idx = setdiff(1:size(lin,4), tr_idx);
                val_vox = cat(4, val_vox, lin(:,:,:, val_idx));
                val_truevox =[val_truevox; trw(val_idx)'];
                val_lbl = [val_lbl; id(val_idx)'];
            case 2
                if tr_indiv(str2num(indiv))
                    train_vox = cat(4,train_vox,lin);
                    train_truevox = [train_truevox; trw'];
                    train_lbl = [train_lbl; id'];
                else
                    val_vox = cat(4,val_vox,lin);
                    val_truevox =[val_truevox; trw'];
                    val_lbl = [val_lbl; id'];
                end
            case 3
                if strcmp(files(k).name(4), 'M')
                    val_vox = cat(4,val_vox,lin);
                    val_truevox =[val_truevox; trw'];
                    val_lbl = [val_lbl; id'];                    
                else
                    train_vox = cat(4,train_vox,lin);
                    train_truevox = [train_truevox; trw'];
                    train_lbl = [train_lbl; id'];
                end
        end
    end
    %% Separa Mao Dir
    answ = 1;
    if transformada
        [lin_w] = sepWav(chann2, e, r_idx, tamanhoJanela,...
                                          canais, fin, fou, false, false, answ);
        trw_w = ones(1, size(lin_w,4)) * answ;
        id_w = ones(1, size(lin_w,4)) * str2num(indiv);
        [lin, trw, id] = wavlet_split(lin_w, trw_w, id_w, tamanhoCorte);
        [lin] = redInterpCub(lin, red_size);
    else
        [lin] = sepSTFT(chann2, e, r_idx, tamanhoJanela,...
                                      canais, fin, fou, false, false, answ);
        trw = ones(1, size(lin,4)) * answ;
        id = ones(1, size(lin,4)) * str2num(indiv);
        [lin] = redInterpCub(lin, [7*6,size(lin,2)]);
    end
    
    switch opt_tr
        case 1
            %training
            tr_idx = randperm(size(lin,4), round(tr_per * size(lin,4)));
            train_vox = cat(4, train_vox, lin(:,:,:,tr_idx));
            train_truevox = [train_truevox; trw(tr_idx)'];
            train_lbl = [train_lbl; id(tr_idx)'];
            %validation
            val_idx = setdiff(1:size(lin,4), tr_idx);
            val_vox = cat(4, val_vox, lin(:,:,:, val_idx));
            val_truevox =[val_truevox; trw(val_idx)'];
            val_lbl = [val_lbl; id(val_idx)'];
        case 2
            if tr_indiv(str2num(indiv))
                train_vox = cat(4,train_vox,lin);
                train_truevox = [train_truevox; trw'];
                train_lbl = [train_lbl; id'];
            else
                val_vox = cat(4,val_vox,lin);
                val_truevox =[val_truevox; trw'];
                val_lbl = [val_lbl; id'];
            end
        case 3
            if strcmp(files(k).name(4), 'M')
                val_vox = cat(4,val_vox,lin);
                val_truevox =[val_truevox; trw'];
                val_lbl = [val_lbl; id'];                    
            else
                train_vox = cat(4,train_vox,lin);
                train_truevox = [train_truevox; trw'];
                train_lbl = [train_lbl; id'];
            end
    end
    %% Separa Mao Esq
    answ = 2;
    if transformada
        [lin_w] = sepWav(chann2, e, l_idx, tamanhoJanela,...
                                          canais, fin, fou, false, false, answ);
        trw_w = ones(1, size(lin_w,4)) * answ;
        id_w = ones(1, size(lin_w,4)) * str2num(indiv);
        [lin, trw, id] = wavlet_split(lin_w, trw_w, id_w, tamanhoCorte);
        [lin] = redInterpCub(lin, red_size);
    else
        [lin] = sepSTFT(chann2, e, l_idx, tamanhoJanela,...
                                      canais, fin, fou, false, false, answ);
        trw = ones(1, size(lin,4)) * answ;
        id = ones(1, size(lin,4)) * str2num(indiv);
        [lin] = redInterpCub(lin, [7*6,size(lin,2)]);
    end
    
    switch opt_tr
        case 1
            %training
            tr_idx = randperm(size(lin,4), round(tr_per * size(lin,4)));
            train_vox = cat(4, train_vox, lin(:,:,:,tr_idx));
            train_truevox = [train_truevox; trw(tr_idx)'];
            train_lbl = [train_lbl; id(tr_idx)'];
            %validation
            val_idx = setdiff(1:size(lin,4), tr_idx);
            val_vox = cat(4, val_vox, lin(:,:,:, val_idx));
            val_truevox =[val_truevox; trw(val_idx)'];
            val_lbl = [val_lbl; id(val_idx)'];
        case 2
            if tr_indiv(str2num(indiv))
                train_vox = cat(4,train_vox,lin);
                train_truevox = [train_truevox; trw'];
                train_lbl = [train_lbl; id'];
            else
                val_vox = cat(4,val_vox,lin);
                val_truevox =[val_truevox; trw'];
                val_lbl = [val_lbl; id'];
            end
        case 3
            if strcmp(files(k).name(4), 'M')
                val_vox = cat(4,val_vox,lin);
                val_truevox =[val_truevox; trw'];
                val_lbl = [val_lbl; id'];                    
            else
                train_vox = cat(4,train_vox,lin);
                train_truevox = [train_truevox; trw'];
                train_lbl = [train_lbl; id'];
            end
    end
end
fprintf('\n\n...DONE\n\n>>Tamanho Sets:\n.Treinamento: (%d, %d)\n.Teste      : (%d, %d)\nSaving...', size(train_truevox), size(val_truevox));
%% NORMALIZAR WAVS APOS FORMAR MATRIZ
% minlin = min(train_vox(:));
% train_vox = train_vox - minlin;
% maxlin = max(train_vox(:));
% train_vox = train_vox/maxlin;
% 
% minlin = min(val_vox(:));
% val_vox = val_vox - minlin;
% maxlin = max(val_vox(:));
% val_vox = val_vox/maxlin;

allin = cat(4,train_vox, val_vox);

minlin = min(allin(:));
train_vox = train_vox - minlin;
val_vox = val_vox-minlin;
allin = allin-minlin;

maxlin = max(allin(:));
train_vox = train_vox/maxlin;
val_vox = val_vox/maxlin;
%% SALVA ARQUIVO PARA RN
validation = {val_vox, categorical(val_truevox)};%, categorical(val_lbl)};
train = {train_vox, categorical(train_truevox)};%, categorical(train_lbl)};

% save('data.mat', 'train', 'validation');
fprintf('\n.Complete.\n');