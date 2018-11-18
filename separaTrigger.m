function [e, d] = separaTrigger(a)
    %% Triggers
    event = table2array(a(:,14));
    event_ = event(~cellfun('isempty', event));
    j = 1;
    for i = 1:size(event_,1)
        if ~isempty(regexp(event_{i},':', 'once'))
            sidx = regexp(event_{i},':');
            n = 1;
            for k = 1:size(sidx,2)
                d(j) = str2num(event_{i}(n:sidx(k)-1));
                n = sidx(k)+1;
                j = j+1;
            end
            d(j) = str2num(event_{i}(sidx(k)+1:end));
            j = j+1;
        else
            d(j) = str2num(event_{i});
            j = j+1;
        end
    end
    d = d';
    %% Tempo dos Triggers
    time = table2array(a(:,15));
    time_ = time(~cellfun('isempty', time));
    j = 1;
    for i = 1:size(time_,1)
        if ~isempty(regexp(event_{i},':', 'once'))
            sidx = regexp(time_{i},':', 'once');
            e(j) = str2num(time_{i}(1:sidx-1));
            j = j+1;
            e(j) = str2num(time_{i}(sidx+1:end));
            j = j+1;
        else
            e(j) = str2num(time_{i});
            j = j+1;
        end
    end
    e = e';
end