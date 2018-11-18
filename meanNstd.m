function meanNstd(vect,opt,fid)
    if opt == 1
        fprintf(fid, '%6.3f%%+-%6.3f%%', mean(vect)*100, std(vect)*100);
    else
        fprintf('%6.3f%%+-%.3f%%', mean(vect)*100, std(vect)*100);
    end
end