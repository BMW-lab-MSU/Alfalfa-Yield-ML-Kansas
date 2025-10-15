function [RMSEtable] = RMSE_modelbased_pearsons(X,y,predictorNames,load_filename,dstcode)

% MRMR
[idx_MRMR,scores_MRMR] = findmrmr(X,y);

% pearsons
[idx, scores] = findpearson(X, y);

% visualize and compare
mrmr_vs_pearsons_ranking_visualize(predictorNames,idx_MRMR,scores_MRMR,idx,scores)

N = length(idx);
n_models = 3; % SVM, KNN, RF
RMSEtable = array2table(zeros(N,n_models+1),'VariableNames',["SVM","KNN","RF","Finalvalue"]);
load_filename
for n = 1:N
    rng("default")
    if mod(n,10) == 0
        n
    end
    tempX = X(:,idx(1:n)); % selected columns only
    [avg_rmse_data] = yieldKS_evaluate_features(tempX,y);
    RMSEtable{n,:} = [avg_rmse_data,mean(avg_rmse_data)];
end

% save error table
originalfilename = "RMSEinfo_pearsons";
savefilename = get_filenameext(originalfilename,load_filename,dstcode);
save(savefilename + ".mat","RMSEtable","predictorNames","scores","idx")
end
