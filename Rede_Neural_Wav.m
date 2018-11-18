%% Rede Neural
tam = [size(train{1},1), size(train{1},2)];
saidas = size(countcats(train{2}),1);

layers = [
    imageInputLayer([tam, 1], 'Name', 'Entrada')                            %camada [60,64] * 1
%%     
    convolution2dLayer([tam(1), 5], 25, 'Name', 'Camada1') %[50, 61]       %camada [1,60] * 25
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer([1,2], 'Stride', 2)                                   %camada [1, 30] * 25
    
    convolution2dLayer([1, 15], 50, 'Name', 'Camada2')                     %camada [1, 16] * (25*25)
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer([1,2], 'Stride', 2)                                   %camada [1, 8] * 25
    
    convolution2dLayer([1, 2], 100, 'Name', 'Camada3')                     %camada [1, 7] * (25*25)
    batchNormalizationLayer
    reluLayer
%     maxPooling2dLayer([1,2], 'Stride', 2)                                   %camada [1,10] * (25*25)
%%
%     convolution2dLayer([3, tam(2)], 128, 'Name', 'Camada1')                 %camada [56 ,1] * 128
%     batchNormalizationLayer
%     reluLayer
%     maxPooling2dLayer([2,1], 'Stride', 2)                                   %camada [28, 1] * 25
%     
%     convolution2dLayer([5, 1], 256, 'Name', 'Camada2')                      %camada [10, 1] * (25*25)
%     batchNormalizationLayer
%     reluLayer
%     
%     convolution2dLayer([5, 1], 512, 'Name', 'Camada3')                      %camada [6, 1] * (25*25)
%     batchNormalizationLayer
%     reluLayer
%     maxPooling2dLayer([2,1], 'Stride', 2)                                   %camada [3,1] * (25*25)

%%     
%     convolution2dLayer([tam(1)/2+1, 51], 32, 'Name', 'Camada1') %[50, 61]     %camada [tam(1)/2, 200] * 32
%     batchNormalizationLayer
%     reluLayer
%     maxPooling2dLayer([2,2], 'Stride', 2)                                   %camada [22, 100] * 25
%     
%     convolution2dLayer([tam(1)/4, 51], 64, 'Name', 'Camada2')               %camada [1, 50] * 64
%     batchNormalizationLayer
%     reluLayer
%     maxPooling2dLayer([1,2], 'Stride', 2)                                   %camada [1,25] * 64
    
    fullyConnectedLayer(saidas, 'Name', 'Saida')
    softmaxLayer
    classificationLayer];

% idx = randperm(size(XTrain,4),1000); << Escolher amostras randomicamente
bach_size = round(0.1*size(train{2},1));

param_train = trainingOptions('sgdm',...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs', 100,...
    'MiniBatchSize', bach_size,...
    'Plots', 'training-progress',...
    'ValidationData', validation,...
    'ValidationFrequency', 10,...
    'ValidationPatience', 30,...
    'Shuffle', 'every-epoch',...
    'Momentum', 0.5,...
    'InitialLearnRate', 0.02,...
    'LearnRateSchedule', 'piecewise',...
    'LearnRateDropPeriod', 7,...
    'LearnRateDropFactor', 0.5);


net = trainNetwork(train{1},train{2},layers,param_train);