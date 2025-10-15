clear all
close all
clc

%% Load PRISM data
path = "..\dataset\PRISM_1981_2018";
files = dir(fullfile(path,"*.csv"));

% Initialize output table
T_county_pptmean = table('Size',[length(files) 2], ...
    'VariableTypes',{'string','double'}, ...
    'VariableNames',{'Name','pptmean'});

for i = 1:length(files)

    % load data
    filename = files(i).name;
    fullfilename = fullfile(path,filename);
    t = readtable(fullfilename);
    t_vars = t.Properties.VariableNames;

    % extract county name from filename and format properly
    county_raw = extractBefore(filename,".csv");
    county_formatted = [upper(county_raw(1)) lower(county_raw(2:end)) ' County'];

    % extract years
    years = unique(year(t.Date));

    annual_totals = zeros(length(years),1);

    for j = 1:length(years)
        currentyear = years(j);
        idx = year(t.Date) == currentyear;        % all rows for this year
        pptmeanvaridx = find(contains(t_vars,'ppt'));
        annual_totals(j) = sum(t{idx,pptmeanvaridx},'omitnan'); % total ppt for year
    end

    % average annual total
    pptmean_val = mean(annual_totals);


    % store results
    T_county_pptmean.Name(i) = string(county_formatted);
    T_county_pptmean.pptmean(i) = pptmean_val;

end

% Save file
save("ppt_values_county.mat","T_county_pptmean")
%% Save as CSV for ArcGIS
writetable(T_county_pptmean, "ppt_values_county.csv")