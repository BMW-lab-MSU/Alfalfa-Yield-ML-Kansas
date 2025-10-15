function mrmr_vs_pearsons_ranking_visualize(predictornames,idx_MRMR,scores_MRMR,idx_P,scores_P)

N = 10; % number of top features to display

% MRMR top N
topIdxMRMR = idx_MRMR(1:N);
topNamesMRMR = predictornames(topIdxMRMR);
topScoresMRMR = scores_MRMR(topIdxMRMR);

% Pearson top N
topIdxP = idx_P(1:N);
topNamesP = predictornames(topIdxP);
topScoresP = scores_P(topIdxP);

fig = figure("Units","inches","OuterPosition",[0,0,6,8]);
tiledlayout(2,1)

nexttile
bar(topScoresMRMR);
set(gca, 'XTickLabel', strrep(topNamesMRMR,'_','\_'), 'XTickLabelRotation', 45);
title("Top " + string(N) + " Features (MRMR)");
ylabel('Normalized Score');

nexttile
bar(topScoresP);
set(gca, 'XTickLabel', strrep(topNamesP,'_','\_'), 'XTickLabelRotation', 45);
title("Top " + string(N) + " Features (Pearson)");
ylabel('Normalized Score');


% save %%%%%%%%(uncomment the lines below if you want to save the figure)
% filename = "top" + string(N) + "features_mRMR_pearsons";
% savefig(filename)
% saveas(fig,[filename + ".png"])

end