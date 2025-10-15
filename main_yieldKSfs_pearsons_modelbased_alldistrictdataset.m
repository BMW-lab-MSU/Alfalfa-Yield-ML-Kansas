clear all
close all
clc
%%
% all districts dataset
load_filename = "yielddataset_kansas_monthly_total_1981_2018_0mm.xlsx";
dstcode = NaN;

% prepare data for mRMR
[T,target_var,predictorNames,X,y] = loadmRMRdata(load_filename);
height(T)
% perform mRMR and evaluate RMSE with 4 models
RMSEtable_all = RMSE_modelbased_pearsons(X,y,predictorNames,load_filename,dstcode);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% shortcut: load all RMSEtable files
files = dir(".\RMSEinfo_pearsons*.mat");
best_n_features_array = [];
for i = 1:length(files)
    load_filename = files(i).name;
    load(load_filename)
    % get dst
    pat =" district " + digitsPattern(1) + "0";
    dstcode = NaN;
    if contains(load_filename,pat)
        dstcode = extractBetween(load_filename,"district ",".mat");
        dstcode = str2double(dstcode);
    end
    % plot RMSE scores
    [best_n_features] = plotfeature_eval_pearsons(RMSEtable,load_filename,dstcode);
    best_n_features_array = [best_n_features_array; best_n_features];
end

% savedata
save("best_n_features_all_dataset_pearsons.mat","best_n_features_array")


