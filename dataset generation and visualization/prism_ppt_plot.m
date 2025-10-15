clear all
close all
clc

%% Generate ppt_values.mat
% Load PRISM_data into table

path = "..\dataset\PRISM_1981_2018";
files = dir(fullfile(path,"*.csv"));

countyinfo = readtable("..\dataset\kansas_countyinfo.xlsx");
ag_dst = nonzeros(unique(countyinfo.AgDistrictCode));

for i = 1:length(files)

    % load data
    filename = files(i).name;
    fullfilename = fullfile(path,filename);
    t = readtable(fullfilename);
    t_vars = t.Properties.VariableNames;

    % extract years
    years = unique(year(t.Date));

    % find ag dst
    currentcounty = extractBefore(filename,".csv");
    dstcode = countyinfo{find(strcmpi(countyinfo.County,currentcounty)),"AgDistrictCode"};
    dstidx = find(ag_dst == dstcode);

    %% pptmin
    % if table does not exist, create it
    if ~exist('T_pptmin','var')
        T_pptmin = table(years);
        for j = 1:length(ag_dst)
            T_pptmin.(string(ag_dst(j))) = zeros(height(T_pptmin),1);
        end
        T_pptmin_flags = T_pptmin;
    end

    % get min temp data
    pptminvaridx = find(contains(t_vars,'ppt'));
    for j = 1:length(years)
        currentyear = years(j);
        pptmin_year_idx = find(contains(string(t.Date),string(currentyear)));
        pptmin_val = min(t{pptmin_year_idx,pptminvaridx});

        % append data

        % if first file, append tmin_val directly. Else, compare
        row = find(contains(string(T_pptmin.years),string(currentyear)));
        col = find(contains(T_pptmin.Properties.VariableNames,string(dstcode)));
        if T_pptmin_flags{row,col} == 0
            T_pptmin{row,col} = pptmin_val;
            T_pptmin_flags{row,col} = 1;
        else
            if pptmin_val < T_pptmin{row,col}
                T_pptmin{row,col} = pptmin_val;
                T_pptmin_flags{row,col} = 1;
            end
        end
    end

    %% pptmax
    % if table does not exist, create it
    if ~exist('T_pptmax','var')
        T_pptmax = table(years);
        for j = 1:length(ag_dst)
            T_pptmax.(string(ag_dst(j))) = zeros(height(T_pptmax),1);
        end
        T_pptmax_flags = T_pptmax;
    end

    % get max temp data
    pptmaxvaridx = find(contains(t_vars,'ppt'));
    for j = 1:length(years)
        currentyear = years(j);
        pptmax_year_idx = find(contains(string(t.Date),string(currentyear)));
        pptmax_val = max(t{pptmax_year_idx,pptmaxvaridx});

        % append data

        % if first file, append tmax_val directly. Else, compare
        row = find(contains(string(T_pptmax.years),string(currentyear)));
        col = find(contains(T_pptmax.Properties.VariableNames,string(dstcode)));
        if T_pptmax_flags{row,col} == 0
            T_pptmax{row,col} = pptmax_val;
            T_pptmax_flags{row,col} = 1;
        else
            if pptmax_val > T_pptmax{row,col}
                T_pptmax{row,col} = pptmax_val;
                T_pptmax_flags{row,col} = 1;
            end
        end
    end
    %% Tmean
    % if table does not exist, create it
    if ~exist('T_pptmean','var')
        T_pptmean = table(years);
        for j = 1:length(ag_dst)
            T_pptmean.(string(ag_dst(j))) = zeros(height(T_pptmean),1);
        end
        T_pptmean_flags = T_pptmean;
    end

    % get mean temp data
    pptmeanvaridx = find(contains(t_vars,'ppt'));
    for j = 1:length(years)
        currentyear = years(j);
        pptmean_year_idx = find(contains(string(t.Date),string(currentyear)));
        pptmean_val = mean(t{pptmean_year_idx,pptmeanvaridx});

        % append data

        % if first file, append tmin_val directly. Else, compare
        row = find(contains(string(T_pptmean.years),string(currentyear)));
        col = find(contains(T_pptmean.Properties.VariableNames,string(dstcode)));
        if T_pptmean_flags{row,col} == 0
            T_pptmean{row,col} = pptmean_val;
            T_pptmean_flags{row,col} = 1;
        else
            T_pptmean{row,col} = T_pptmean{row,col} + pptmean_val; % sum
            T_pptmean_flags{row,col} = T_pptmean_flags{row,col} + 1; % count
        end
    end
end

T_pptmean{:,2:end} = T_pptmean{:,2:end}./T_pptmean_flags{:,2:end}; % sum/count

% save file
save("ppt_values.mat","T_pptmax","T_pptmin","T_pptmean","years","ag_dst")

%% Plot parameters (surfplot)

load("ppt_values.mat")
figure("Units","normalized","OuterPosition",[0 0 1 1])
tiledlayout(3,1)
x_varname = "Ag District";
y_varname = "Year";
z_varname = ["pptmin (inches)";"pptmean (inches)";"pptmax (inches)"];

% tmax
ax1 = nexttile;
s1 = surf(T_pptmax{:,2:end}, 'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'FaceLighting', 'none');
shading interp;
colormap(ax1,autumn);
yticks([1:length(years)]); xticks([1:length(ag_dst)]); yticklabels(years); xticklabels(ag_dst); ylabel(y_varname); xlabel(x_varname); zlabel("ppt (inches)"); 
title(x_varname + " vs " + y_varname + " vs " + z_varname(3))
colorbar;

% tmean
ax2 = nexttile;
s2 = surf(T_pptmean{:,2:end}, 'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 0.8, 'FaceLighting', 'none'); 
shading interp;
colormap(ax2,jet);
yticks([1:length(years)]); xticks([1:length(ag_dst)]); yticklabels(years); xticklabels(ag_dst); ylabel(y_varname); xlabel(x_varname); zlabel("ppt (inches)"); 
title(x_varname + " vs " + y_varname + " vs " + z_varname(2))
colorbar;


% tmin
ax3 = nexttile;
s3 = surf(T_pptmin{:,2:end}, 'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'FaceLighting', 'none');
shading interp;
colormap(ax3,winter);
yticks([1:length(years)]); xticks([1:length(ag_dst)]); yticklabels(years); xticklabels(ag_dst); ylabel(y_varname); xlabel(x_varname); zlabel("ppt (inches)"); 
title(x_varname + " vs " + y_varname + " vs " + z_varname(1))
colorbar;

% saveplot
filename = x_varname + y_varname + "ppt";
saveas(gcf,[filename + ".png"])
savefig(filename)
