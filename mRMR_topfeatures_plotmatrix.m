clear all
close all
clc

%% all districts dataset
load_filename = "yielddataset_kansas_monthly_total_1981_2018_0mm.xlsx";
str_text = "all-districts";

% define mRMR-ranked best feature size (previously calculated from
% forward feature selection process)
nfeatures = 12;

% Call plotmatrix funtion
plotmatrix_mRMR(load_filename,str_text,nfeatures)

%% irrigation districts dataset
load_filename = "yielddataset_irrigationdst_kansas_monthly_total_1981_2018_0mm.xlsx";
str_text = "irrigation districts";

% define mRMR-ranked best feature size (previously calculated from
% forward feature selection process)
nfeatures = 10;

% Call plotmatrix funtion
plotmatrix_mRMR(load_filename,str_text,nfeatures)

%% rainfed districts dataset
load_filename = "yielddataset_rainfeddst_kansas_monthly_total_1981_2018_0mm.xlsx";
str_text = "rainfed districts";

% define mRMR-ranked best feature size (previously calculated from
% forward feature selection process)
nfeatures = 10;

% Call plotmatrix funtion
plotmatrix_mRMR(load_filename,str_text,nfeatures)

%% define the function

function plotmatrix_mRMR(load_filename,str_text,nfeatures)

%% PLOTMATRIX of the mRMR-ranked top features

% prepare data - separate predictors, target, etc
[T,target_var,predictorNames,X,y] = loadmRMRdata(load_filename);

% MRMR
[idx,scores] = findmrmr(X,y);

% Take top-12 MRMR predictors
top_idx = idx(1:nfeatures);

% adjust to table column idx
col_idx = [1, top_idx+1];
T_top = T(:,col_idx);

% plot matrix
fighandle = figure("Units","inches","OuterPosition",[0 0 12 10]);
[S,AX,BigAx,H,HAx] = plotmatrix(T_top{:,:});


labels = T_top.Properties.VariableNames; % use table's column names
n = numel(labels);


% Row labels (first col)
for i = 1:n
    ylabel(AX(i,1), strrep(labels{i},'_',' '), 'FontWeight','normal','FontSize',8, 'Rotation',0);
end

title_txt = "Pairwise relationship between the yield and mRMR top " +string(nfeatures) + " features: " + str_text;
title(title_txt)

% save
savefilename = strrep(title_txt,":","");
savefig(fighandle,savefilename)
saveas(fighandle,[savefilename + ".png"])


%% Correlation table (Pearson's r and p-value)
varNames = predictorNames(top_idx); % get predictor names
r_vals = zeros(nfeatures,1);
p_vals = zeros(nfeatures,1);

for i = 1:nfeatures
    x = X(:,top_idx(i));
    [R,P] = corr(y, x, 'Type','Pearson','Rows','complete');
    r_vals(i) = R;
    p_vals(i) = P;
end

CorrTable = table(varNames', r_vals, p_vals, ...
    'VariableNames', {'Variable','Pearson_r','p_value'});

% save correlation results as CSV
csv_filename = "mRMR top " + string(nfeatures) + " features " + str_text + "_correlations.csv";
writetable(CorrTable, csv_filename)


end
