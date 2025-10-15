% clear all
% close all
% clc
% 
%% Generate temp_values.mat
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

    %% Tmin
    % if table does not exist, create it
    if ~exist('T_tmin','var')
        T_tmin = table(years);
        for j = 1:length(ag_dst)
            T_tmin.(string(ag_dst(j))) = zeros(height(T_tmin),1);
        end
        T_tmin_flags = T_tmin;
    end

    % get min temp data637
    tminvaridx = find(contains(t_vars,'tmin'));
    for j = 1:length(years)
        currentyear = years(j);
        tmin_year_idx = find(contains(string(t.Date),string(currentyear)));
        tmin_val = min(t{tmin_year_idx,tminvaridx});

        % append data

        % if first file, append tmin_val directly. Else, compare
        row = find(contains(string(T_tmin.years),string(currentyear)));
        col = find(contains(T_tmin.Properties.VariableNames,string(dstcode)));
        if T_tmin_flags{row,col} == 0
            T_tmin{row,col} = tmin_val;
            T_tmin_flags{row,col} = 1;
        else
            if tmin_val < T_tmin{row,col}
                T_tmin{row,col} = tmin_val;
                T_tmin_flags{row,col} = 1;
            end
        end
    end

    %% Tmax
    % if table does not exist, create it
    if ~exist('T_tmax','var')
        T_tmax = table(years);
        for j = 1:length(ag_dst)
            T_tmax.(string(ag_dst(j))) = zeros(height(T_tmax),1);
        end
        T_tmax_flags = T_tmax;
    end

    % get max temp data
    tmaxvaridx = find(contains(t_vars,'tmax'));
    for j = 1:length(years)
        currentyear = years(j);
        tmax_year_idx = find(contains(string(t.Date),string(currentyear)));
        tmax_val = max(t{tmax_year_idx,tmaxvaridx});

        % append data

        % if first file, append tmax_val directly. Else, compare
        row = find(contains(string(T_tmax.years),string(currentyear)));
        col = find(contains(T_tmax.Properties.VariableNames,string(dstcode)));
        if T_tmax_flags{row,col} == 0
            T_tmax{row,col} = tmax_val;
            T_tmax_flags{row,col} = 1;
        else
            if tmax_val > T_tmax{row,col}
                T_tmax{row,col} = tmax_val;
                T_tmax_flags{row,col} = 1;
            end
        end
    end
    %% Tmean
    % if table does not exist, create it
    if ~exist('T_tmean','var')
        T_tmean = table(years);
        for j = 1:length(ag_dst)
            T_tmean.(string(ag_dst(j))) = zeros(height(T_tmean),1);
        end
        T_tmean_flags = T_tmean;
    end

    % get mean temp data
    tmeanvaridx = find(contains(t_vars,'tmean'));
    for j = 1:length(years)
        currentyear = years(j);
        tmean_year_idx = find(contains(string(t.Date),string(currentyear)));
        tmean_val = mean(t{tmean_year_idx,tmeanvaridx});

        % append data

        % if first file, append tmin_val directly. Else, compare
        row = find(contains(string(T_tmean.years),string(currentyear)));
        col = find(contains(T_tmean.Properties.VariableNames,string(dstcode)));
        if T_tmean_flags{row,col} == 0
            T_tmean{row,col} = tmean_val;
            T_tmean_flags{row,col} = 1;
        else
            T_tmean{row,col} = T_tmean{row,col} + tmean_val; % sum
            T_tmean_flags{row,col} = T_tmean_flags{row,col} + 1; % count
        end
    end
end

T_tmean{:,2:end} = T_tmean{:,2:end}./T_tmean_flags{:,2:end}; % sum/count

% save file
save("temp_values.mat","T_tmax","T_tmin","T_tmean","years","ag_dst")

% %% Plot parameters (alternate)
% load("temp_values.mat")
% figure("Units","normalized","OuterPosition",[0 0 1 1])
% x_varname = "Ag District";
% y_varname = "Year";
% z_varname = ["tmin (F)";"tmean (F)";"tmax (F)"];
% 
% % tmin
% s1 = surf(T_tmin{:,2:end});  
% s1.EdgeColor = "none";
% s1.FaceColor = "interp";
% s1.FaceColor = "texturemap";
% s1.FaceAlpha = 0.5;
% s1 = surf(T_tmin{:,2:end}, 'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'FaceLighting', 'none');
% shading interp;
% 
% % Customize colormap
% colormap(parula); % You can choose a different colormap
% yticks([1:length(years)]); xticks([1:length(ag_dst)]); yticklabels(years); xticklabels(ag_dst); ylabel(y_varname); xlabel(x_varname); zlabel("temp (F)");
% 
% colorbar;
% hold on 
% 
% % tmean
% s2 = surf(T_tmean{:,2:end}, 'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 0.8, 'FaceLighting', 'none'); 
% shading interp;
% 
% % Customize colormap
% colormap(parula); % You can choose a different colormap
% 
% yticks([1:length(years)]); xticks([1:length(ag_dst)]); yticklabels(years); xticklabels(ag_dst); ylabel(y_varname); xlabel(x_varname); zlabel("temp (F)"); 
% s2.EdgeColor = "none";
% s2.FaceColor = "interp";
% s2.FaceColor = "#77AC30";
% s2.FaceColor = "texturemap";
% s2.FaceAlpha = 0.8;
% 
% % tmax
% s3 = surf(T_tmax{:,2:end},'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'FaceLighting', 'none'); 
% shading interp;
% 
% % Customize colormap
% colormap(parula); % You can choose a different colormap
% yticks([1:length(years)]); xticks([1:length(ag_dst)]); yticklabels(years); xticklabels(ag_dst); ylabel(y_varname); xlabel(x_varname); zlabel("temp (F)"); 
% s3.EdgeColor = "none";
% s3.FaceColor = "interp";
% s3.FaceColor = "#D95319";
% s3.FaceColor = "texturemap";
% s3.FaceAlpha = 0.5;
% 
% hold off
% grid on
% legend(z_varname)
% title(x_varname + " vs " + y_varname + " vs " + " temperature")
% 
% colorbar
% 
% % saveplot
% % filename = x_varname + y_varname + "metdata";
% % saveas(gcf,[filename + ".png"])
% % savefig(filename)
% 

%% surf plots (current)

load("temp_values.mat")
figure("Units","normalized","OuterPosition",[0 0 1 1])
tiledlayout(3,1)
x_varname = "Ag District";
y_varname = "Year";
z_varname = ["tmin (F)";"tmean (F)";"tmax (F)"];

% tmax
% subplot(3, 1, 1);
ax1 = nexttile;
s1 = surf(T_tmax{:,2:end}, 'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'FaceLighting', 'none');
shading interp;
colormap(ax1,autumn);
yticks([1:length(years)]); xticks([1:length(ag_dst)]); yticklabels(years); xticklabels(ag_dst); ylabel(y_varname); xlabel(x_varname); zlabel("temp (F)"); 
title(x_varname + " vs " + y_varname + " vs " + z_varname(3))
colorbar;

% tmean
% subplot(3, 1, 2);
ax2 = nexttile;
s2 = surf(T_tmean{:,2:end}, 'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 0.8, 'FaceLighting', 'none'); 
shading interp;
colormap(ax2,jet);
yticks([1:length(years)]); xticks([1:length(ag_dst)]); yticklabels(years); xticklabels(ag_dst); ylabel(y_varname); xlabel(x_varname); zlabel("temp (F)"); 
title(x_varname + " vs " + y_varname + " vs " + z_varname(2))
colorbar;


% tmin
% subplot(3, 1, 3);
ax3 = nexttile;
s3 = surf(T_tmin{:,2:end}, 'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'FaceLighting', 'none');
shading interp;
colormap(ax3,winter);
yticks([1:length(years)]); xticks([1:length(ag_dst)]); yticklabels(years); xticklabels(ag_dst); ylabel(y_varname); xlabel(x_varname); zlabel("temp (F)"); 
title(x_varname + " vs " + y_varname + " vs " + z_varname(1))
colorbar;

% saveplot
% filename = x_varname + y_varname + "temp";
% saveas(gcf,[filename + ".png"])
% savefig(filename)
