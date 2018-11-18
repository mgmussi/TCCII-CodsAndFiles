%% GRAPH A1
%% MEDIAS
[h,p] = ttest([42.838 46.260 44.384 40.388],...
              [46.330 47.678 39.239 44.706], 'Alpha', 0.05);
p/2
%% INDIVID
[h,p] = ttest([42.346 43.799 42.682 41.117 44.246],...
              [44.444 47.138 48.822 43.771 47.475], 'Alpha', 0.05);
p/2
[h,p] = ttest([44.601 46.479 46.322 45.540 48.357],...
              [47.867 45.498 53.081 44.550 47.678], 'Alpha', 0.05);
p/2
[h,p] = ttest([41.848 43.116 45.290 47.826 43.841],...
              [39.674 39.130 36.957 42.935 37.500], 'Alpha', 0.05);
p/2
[h,p] = ttest([40.388 39.153 41.799 41.446 39.153],...
              [42.781 44.920 47.594 43.850 44.385], 'Alpha', 0.05);
p/2
%% TODOS OS RESULTADOS
[h,p] = ttest([42.346 43.799 42.682 41.117 44.246...
               44.601 46.479 46.322 45.540 48.357...
               41.848 43.116 45.290 47.826 43.841...
               40.388 39.153 41.799 41.446 39.153],...
              [44.444 47.138 48.822 43.771 47.475...
               47.867 45.498 53.081 44.550 47.678...
               39.674 39.130 36.957 42.935 37.500...
               42.781 44.920 47.594 43.850 44.385], 'Alpha', 0.05);
p/2




%% GRAPH A2 
%% MEDIAS
[h,p] = ttest([50.667 52.852 49.958 50.083],...
              [50.923 50.111 46.000 53.000], 'Alpha', 0.05); 
p/2
%% INDIV
[h,p] = ttest([49.744 51.923 50.256 51.026 50.385],...
              [51.154 46.923 52.308 50.769 53.462], 'Alpha', 0.05);
p/2
[h,p] = ttest([50.185 50.185 55.370 54.444 54.074],...
              [49.444 53.889 48.889 47.222 51.111], 'Alpha', 0.05);
p/2
[h,p] = ttest([49.375 50.208 52.500 49.792 47.917],...
              [45.000 43.125 50.000 48.125 43.750], 'Alpha', 0.05);
p/2
[h,p] = ttest([48.333 51.875 48.958 50.625 50.625],...
              [42.500 53.750 55.625 58.125 55.000], 'Alpha', 0.05);
p/2
%% TODOS OS RESULTADOS
[h,p] = ttest([49.744 51.923 50.256 51.026 50.385...
               50.185 50.185 55.370 54.444 54.074...
               49.375 50.208 52.500 49.792 47.917...
               48.333 51.875 48.958 50.625 50.625],...
              [51.154 46.923 52.308 50.769 53.462...
               49.444 53.889 48.889 47.222 51.111...
               45.000 43.125 50.000 48.125 43.750...
               42.500 53.750 55.625 58.125 55.000], 'Alpha', 0.05);
p/2



%% GRAPH B1
%% MEDIAS
[h,p] = ttest([45.503 44.206 44.565 40.000],...
              [39.579 57.059 47.586 46.230], 'Alpha', 0.05); 
p/2          
%% INDIVID
[h,p] = ttest([46.309 44.966 45.638 43.960 46.644],...
              [33.684 41.053 45.263 40.000 37.895], 'Alpha', 0.05);
p/2
[h,p] = ttest([44.860 44.860 40.187 43.458 47.664],...
              [55.882 64.706 55.882 55.882 52.941], 'Alpha', 0.05);
p/2
[h,p] = ttest([47.283 40.761 46.196 47.283 41.304],...
              [50.000 55.172 41.379 44.828 46.552], 'Alpha', 0.05);
p/2
[h,p] = ttest([38.947 37.895 42.105 42.105 38.947],...
              [37.705 49.180 44.262 44.262 55.738], 'Alpha', 0.05);
p/2
%% TODOS OS RESULTADOS
[h,p] = ttest([49.615 51.538 47.308 50.769 50.769...
               56.111 59.444 53.333 51.111 55.556...
               57.500 54.375 52.500 48.750 50.625...
               52.500 51.875 47.500 49.375 53.125],...
              [45.238 46.429 53.571 48.810 45.238...
               56.897 51.724 56.897 48.276 58.621...
               46.154 53.846 57.692 53.846 50.000...
               50.000 51.923 57.692 63.462 44.231], 'Alpha', 0.05);
p/2



%% GRAPH B2
%% MEDIAS
[h,p] = ttest([50.000 55.111 52.750 50.875],...
              [47.857 54.483 52.308 53.462], 'Alpha', 0.05);
p/2       
%% INDIVID
[h,p] = ttest([49.615 51.538 47.308 50.769 50.769],...
              [45.238 46.429 53.571 48.810 45.238], 'Alpha', 0.05);
p/2
[h,p] = ttest([56.111 59.444 53.333 51.111 55.556],...
              [56.897 51.724 56.897 48.276 58.621], 'Alpha', 0.05);
p/2
[h,p] = ttest([57.5 54.375 52.5 48.75 50.625],...
              [46.154 53.846 57.692 53.846 50], 'Alpha', 0.05);
p/2
[h,p] = ttest([52.5 51.875 47.5 49.375 53.125],...
              [50 51.923 57.692 63.462 44.231], 'Alpha', 0.05);
p/2
%% TODOS OS RES RESULTADOS
[h,p] = ttest([46.309 44.966 45.638 43.960 46.644...
               44.860 44.860 40.187 43.458 47.664...
               47.283 40.761 46.196 47.283 41.304...
               38.947 37.895 42.105 42.105 38.947],...
              [33.684 41.053 45.263 40.000 37.895...
               55.882 64.706 55.882 55.882 52.941...
               50.000 55.172 41.379 44.828 46.552...
               37.705 49.180 44.262 44.262 55.738], 'Alpha', 0.05);
p/2



%% GRAPH C1
[h,p] = ttest([43.002 44.695 41.761 43.792 44.470],...
              [48.936 48.582 49.291 49.291 51.418], 'Alpha', 0.05);
p/2



%% GRAPH C2
[h,p] = ttest([53.947 51.316 52.763 53.533 49.605],...
              [53.659 51.626 51.626 47.967 50.813], 'Alpha', 0.05);
p/2



%% GRAPH D1
[h,p] = ttest([43.515 45.051 44.539 40.956 44.027],...
              [35.567 40.722 51.546 45.361 37.629], 'Alpha', 0.05);
p/2



%% GRAPH D2
[h,p] = ttest([54.375 50.208 53.125 53.542 47.917],...
              [51.250 45.625 39.375 45.625 53.750], 'Alpha', 0.05);
p/2


