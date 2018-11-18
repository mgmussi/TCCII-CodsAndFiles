function [t, frq, tmp2] = wavplot(seq, fr)
    [cfs,frq] = cwt(seq, 'amor', fr);
    numcol = 240;
    
    tmp1 = abs(cfs);
    t1 = size(tmp1,2);
    tmp1 = tmp1';
    minv = min(tmp1);
    tmp1 = (tmp1-minv(ones(1,t1),:));
    
    maxv = max(tmp1);
    maxvArray = maxv(ones(1,t1),:);
    indx = maxvArray < eps;
    tmp1 = numcol*(tmp1./maxvArray);
    tmp2 = 1+fix(tmp1);
    tmp2(indx) = 1;
    tmp2 = tmp2';
    
    t = 0:length(seq)-1;
%     image(tmp2);
%     pcolor(t,frq,tmp2);
%     shading interp;
%     ylabel('Frequency');
%     xlabel('Time');
%     title('Transformada de Wavelet');
%     colormap(pink(numcol));
%     colorbar;
end