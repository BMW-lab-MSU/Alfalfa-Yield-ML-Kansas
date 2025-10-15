clear all
close all
clc
%%
% all districts dataset
load_filename = "yielddataset_kansas_monthly_total_1981_2018_0mm.xlsx";
dstcode = NaN;

% prepare data: separate predictors, target, etc.
[T,target_var,predictorNames,X,y] = loadmRMRdata(load_filename);

% define correlation type
corr_txt = "Pearson";
[Rp,P] = corr(T{:,:},'Type',corr_txt);

% plot
% predictorplot(Rp,predictorNames,corr_txt);
targetplot(Rp,predictorNames,corr_txt)

% save
Tp = array2table(Rp(2:end, 2:end), 'VariableNames', predictorNames, 'RowNames', predictorNames);
writetable(Tp, corr_txt + "Matrix_allpredictors.csv", "WriteRowNames",true)

Tp_y = array2table(Rp(2:end,1), 'VariableNames', "yield", 'RowNames', predictorNames);
writetable(Tp_y, corr_txt + "Matrix_yield.csv", "WriteRowNames",true)


corr_txt = "Spearman";
[Rs,P] = corr(T{:,:},'Type',corr_txt);

% plot
% predictorplot(Rs,predictorNames,corr_txt);
targetplot(Rs,predictorNames,corr_txt)

% save
Ts = array2table(Rs(2:end, 2:end), 'VariableNames', predictorNames, 'RowNames', predictorNames);
writetable(Ts, corr_txt + "Matrix_allpredictors.csv", "WriteRowNames",true)

Ts_y = array2table(Rs(2:end,1), 'VariableNames', "yield", 'RowNames', predictorNames);
writetable(Ts_y, corr_txt + "Matrix_yield.csv", "WriteRowNames",true)





%% compare Rp and Rs
% check how much values are same

% Suppose Rp and Rs are square correlation matrices
n = size(Rp,1);

% Logical mask for off-diagonal entries
mask = ~eye(n);

% Extract only off-diagonal values
Rp_off = Rp(mask);
Rs_off = Rs(mask);

% Create a mask of valid (non-NaN) entries
validMask = ~isnan(Rp_off) & ~isnan(Rs_off);

% Select only valid values
Rp_valid = Rp_off(validMask);
Rs_valid = Rs_off(validMask);

% Now you can compute differences or correlations
diff = abs(Rp_valid - Rs_valid);
meanDiff = mean(diff);
maxDiff  = max(diff);

fprintf('Mean absolute difference (non-NaN): %.4f\n', meanDiff);
fprintf('Maximum absolute difference (non-NaN): %.4f\n', maxDiff);

% Optional: correlation between Rp and Rs (non-NaN)
rho_corr = corr(Rp_valid, Rs_valid, 'Type', 'Pearson');
fprintf('Correlation between Pearson and Spearman (non-NaN): %.4f\n', rho_corr);

fprintf('Rp: mean=%.4f, median=%.4f, min=%.4f, max=%.4f\n', ...
        mean(Rp_valid), median(Rp_valid), min(Rp_valid), max(Rp_valid));
fprintf('Rs: mean=%.4f, median=%.4f, min=%.4f, max=%.4f\n', ...
        mean(Rs_valid), median(Rs_valid), min(Rs_valid), max(Rs_valid));


%% target only
Rp_y = Rp(2:end,1);
Rs_y = Rs(2:end,1);


% Create a mask of valid (non-NaN) entries
validMask = ~isnan(Rp_y) & ~isnan(Rs_y);

% Select only valid values
Rp_valid = Rp_off(validMask);
Rs_valid = Rs_off(validMask);

% Now you can compute differences or correlations
diff = abs(Rp_valid - Rs_valid);
meanDiff = mean(diff);
maxDiff  = max(diff);

fprintf('Mean absolute difference (non-NaN): %.4f\n', meanDiff);
fprintf('Maximum absolute difference (non-NaN): %.4f\n', maxDiff);

% Optional: correlation between Rp and Rs (non-NaN)
rho_corr = corr(Rp_valid, Rs_valid, 'Type', 'Pearson');
fprintf('Correlation between Pearson and Spearman (non-NaN): %.4f\n', rho_corr);

fprintf('Rp_y: mean=%.4f, median=%.4f, min=%.4f, max=%.4f\n', ...
        mean(Rp_valid), median(Rp_valid), min(Rp_valid), max(Rp_valid));
fprintf('Rs_y: mean=%.4f, median=%.4f, min=%.4f, max=%.4f\n', ...
        mean(Rs_valid), median(Rs_valid), min(Rs_valid), max(Rs_valid));


% Take absolute correlation values (strongest correlation = highest |r|)
[~, idxRp] = maxk(abs(Rp_y), 10);   % indices of top 10 Pearson
[~, idxRs] = maxk(abs(Rs_y), 10);   % indices of top 10 Spearman

% Extract names and values
TopRp = table(predictorNames(idxRp)', Rp_y(idxRp), ...
    'VariableNames', {'Feature','PearsonR'});
TopRs = table(predictorNames(idxRs)', Rs_y(idxRs), ...
    'VariableNames', {'Feature','SpearmanR'});

% Display
disp('Top 10 features by Pearson correlation:')
disp(TopRp)

disp('Top 10 features by Spearman correlation:')
disp(TopRs)

% Optionally, save to CSV
writetable(TopRp,'Top10_Pearson.csv');
writetable(TopRs,'Top10_Spearman.csv');


%% plot all predictors
function predictorplot(R,predictorNames,corr_txt)
Rpred = abs(R(2:end,2:end));
% Rpred = tril(Rpred);
Rpred(abs(Rpred) < 0.1) = NaN;
% figure("Units","inches","OuterPosition",[0 0 13 15])
figure("Units","inches","OuterPosition",[0 0 18 16])
h = imagesc(Rpred);
C = sky(9);
set(h, 'AlphaData', ~isnan(Rpred))
colormap(C)
set(gca, 'Color', [1, 1, 1])
xticks(1:length(predictorNames))
xticklabels(strrep(predictorNames,"_"," "))
xtickangle(90)
yticks(1:length(predictorNames))
yticklabels(strrep(predictorNames,"_"," "))
% colorbar('Location','southoutside')
colorbar
clim([0.1 1])
set(gca,'FontSize',8)
titletext = corr_txt + " KS all-districts predictors";
% title(titletext)
% save figure
savefilename = titletext
saveas(gcf,[savefilename + ".png"])
savefig(savefilename)
savefig(savefilename)
end

%% plot target

function targetplot(R,predictorNames,corr_txt)
Ry = R(2:end,1);

currentfig = figure("Units","inches","OuterPosition",[0 0 15 5])
h = bar(Ry);
ylim([-0.6 0.6])
xticks(1:length(predictorNames))
xticklabels(strrep(predictorNames,"_"," "))
xtickangle(90)
ylabel([corr_txt + " correlation"; "coefficients for yield"])

[maxPred_val,maxPred_ind] = max(Ry);
maxPred_name = predictorNames{maxPred_ind};

[minPred_val,minPred_ind] = min(Ry);
minPred_name = predictorNames{minPred_ind};

% save figure
savefilename = corr_txt +" yield";
saveas(gcf,[savefilename + ".png"])
savefig(savefilename)
savefig(savefilename)
end