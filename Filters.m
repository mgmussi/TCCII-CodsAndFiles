function [chFilt2] = Filters(chann)
%% #SEMFILTRO
clear chFilt1 chFilt2
%% FILTRO NOTCH 59-61HZ
fs = 250;
fc = [59, 61];
[b,a] = butter(2,fc/(fs/2), 'stop');
chFilt2(:,1:2) = chann(:,1:2);
for i=1:6
    chFilt1(:,i) = filter(b,a,chann(:,i+2));
end
clear a b fc;

%% FILTRO BANDPASS 4-40Hz(?)
fc = [4, 40];
[b,a] = butter(2,fc/(fs/2),'bandpass');
for i=1:6
    chFilt2(:,i+2) = filter(b,a,chFilt1(:,i));
end