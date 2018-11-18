function [TP, TN, FP, FN, ACC,PRE, SNS, SPE, FSC] = desempFinal(pred, real, n_class)
    true_idx = find(pred == real);
    false_idx = find(pred ~= real);
    start = 3-n_class;
    
    j = 1;
    for i = start:2
       TP(j) = length(find(pred(true_idx) == num2str(i))); %ok
       TN(j) = length(union( find(pred(true_idx) ~= num2str(i)), find(pred(false_idx) ~= num2str(i)) )); 
       FP(j) = length(find( pred(false_idx) == num2str(i) ));
       FN(j) = length(intersect( find(pred(false_idx) ~= num2str(i)), find(real == num2str(i)) ));
       
       precisao(j) = TP(j)/( TP(j)+FP(j) );
       sensibilidade(j) = TP(j)/( TP(j)+FN(j) );
       especificidade(j) = TN(j)/( TN(j)+FP(j) );
       
       j = j+1;
    end
    ACC = sum(pred == real)/numel(real);
    PRE = mean(precisao);
    SNS = mean(sensibilidade);
    SPE = mean(especificidade);
    FSC = 2*(PRE*SNS)/(PRE+SNS);