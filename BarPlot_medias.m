%% BAR PLOTS
%% Cross-Valid - Com Baseline
media=[42.838,46.330;
       46.260,47.678;
       44.384,39.239;
       40.388,44.706];

desvio=[01.238,02.137;
        01.389,03.311;
        02.292,02.350;
        01.241,01.798];   

lbls = [{'I1'}, {'I4'}, {'I5'}, {'I6'}];
chute = 1/3*100;
xline = 0:5;
axlim = [0.5,4.5,0,100];
yline = chute*ones(1,length(xline));
txt_title = 'Médias de Acurácia - Validação Cruzada com Baseline';
ctrs = 1:size(media,1);
cap = 12;

%% Cross-Valid - Sem Baseline
media=[50.667,50.923;
       52.852,50.111;
       49.958,46.000;
       50.083,53.000];

desvio=[00.838,02.472;
        02.480,02.528;
        01.663,02.951;
        01.425,06.082];   

lbls = [{'I1'}, {'I4'}, {'I5'}, {'I6'}];
chute = 1/2*100;
xline = 0:5;
axlim = [0.5,4.5,0,100];
yline = chute*ones(1,length(xline));
txt_title = 'Médias de Acurácia - Validação Cruzada sem Baseline';
ctrs = 1:size(media,1);
cap = 12;

%% Indiv - Com Baseline
media=[45.503,39.579;
       44.206,57.059;
       44.565,47.586;
       40.000,46.230];

desvio=[01.077,04.250;
        02.717,04.461;
        03.261,05.258;
        01.969,06.699];   

lbls = [{'I1'}, {'I4'}, {'I5'}, {'I6'}];
chute = 1/3*100;
xline = 0:5;
axlim = [0.5,4.5,0,100];
yline = chute*ones(1,length(xline));
txt_title = 'Médias de Acurácia - Avaliação Individual com Baseline';
ctrs = 1:size(media,1);
cap = 12;

%% Indiv - Sem Baseline
media=[50.000,47.857;
       55.111,54.483;
       52.750,52.308;
       50.875,53.462];

desvio=[01.654,03.511;
        03.128,04.328;
        03.383,04.385;
        02.363,07.373];

lbls = [{'I1'}, {'I4'}, {'I5'}, {'I6'}];
chute = 1/2*100;
xline = 0:5;
axlim = [0.5,4.5,0,100];
yline = chute*ones(1,length(xline));
txt_title = 'Médias de Acurácia - Avaliação Individual sem Baseline';
ctrs = 1:size(media,1);
cap = 12;

%% Holdout - Com Baseline
media=[43.544,49.504;
        0,0];

desvio=[01.196,01.110;
        0,0];

lbls = {'Media'};
chute = 1/3*100;
xline = 0:2;
axlim = [0.3,1.7,0,100];
yline = chute*ones(1,length(xline));
txt_title = 'Médias de Acurácia - Holdout com Baseline';
ctrs = 1:size(media,1);
cap = 20;

%% Holdout - Sem Baseline
media=[52.237,51.138;
        0,0];

desvio=[01.782,02.061;
        0,0];

lbls = {'Media'};
chute = 1/2*100;
xline = 0:2;
axlim = [0.3,1.7,0,100];
yline = chute*ones(1,length(xline));
txt_title = 'Médias de Acurácia - Avaliação Individual sem Baseline';
ctrs = 1:size(media,1);
cap = 20;
    
%% Session M - Com Baseline
media=[43.618,42.165;
        0,0];

desvio=[01.594,06.411;
        0,0];

lbls = {'Media'};
chute = 1/3*100;
xline = 0:2;
axlim = [0.3,1.7,0,100];
yline = chute*ones(1,length(xline));
txt_title = 'Médias de Acurácia - Com ensaios Motores com Baseline';
ctrs = 1:size(media,1);
cap = 20;

%% Session M - Sem Baseline
media=[51.833,47.125;
        0,0];

desvio=[02.694,05.601;
        0,0];

lbls = {'Media'};
chute = 1/2*100;
xline = 0:2;
axlim = [0.3,1.7,0,100];
yline = chute*ones(1,length(xline));
txt_title = 'Médias de Acurácia - Com ensaios Motores sem Baseline';
ctrs = 1:size(media,1);
cap = 20;

%% PLOT GRAFICO
data = media;
figure;
hBar = bar(ctrs, data,0.5);
for k1 = 1:size(media,2)
    ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
    ydt(k1,:) = hBar(k1).YData;
end
hold on
errorbar(ctr', ydt', desvio, '.k', 'Capsize', cap, 'LineWidth', 0.8)
set(hBar(1), 'FaceColor','g')
set(hBar(2), 'FaceColor','b')
title(txt_title);
set(gca,'XTickLabel',lbls');
ylabel('Acurácia - [%]');
xlabel('Indivíduos');
grid on
plt = plot(xline,yline,'--k');
legend([hBar(1), hBar(2), plt],{'Janela = 250 amostras','Janela = 750 amostras', 'Acaso'});
legend('boxoff');
axis(axlim)
hold off