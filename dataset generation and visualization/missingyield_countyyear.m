clear all
close all
clc

% Filename of your text file
filename = 'county_year_yieldinfo.txt';

% Read all lines from file
fid = fopen(filename, 'r');
lines = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
lines = lines{1};

% Initialize storage
countyYears = containers.Map(); % dictionary-like storage

% initialize a count variable
count_missing = 0;

for i = 1:numel(lines)
    line = strtrim(lines{i});
    
    % Extract county and year
    tokens = regexp(line, 'County:\s*(\w+),\s*Year:\s*(\d+)', 'tokens');
    if ~isempty(tokens)
        county = tokens{1}{1};
        year   = str2double(tokens{1}{2});
        
        % If line says "does not exist" → add year to that county
        if contains(line, 'does not exist')

            count_missing = count_missing+1; % add count

            if isKey(countyYears, county)
                countyYears(county) = [countyYears(county), year];
            else
                countyYears(county) = year;
            end
        end
    end
end

% Convert to table for grouped output
counties = keys(countyYears);
yearsMissing = values(countyYears);

% Deduplicate and sort years
yearsMissingUnique = cellfun(@(y) unique(sort(y)), yearsMissing, 'UniformOutput', false);

% Turn cell arrays into strings for display
yearsStr = cellfun(@(y) sprintf('%d ', sort(y)), yearsMissing, 'UniformOutput', false);

GroupedTable = table(counties', yearsStr', 'VariableNames', {'County', 'MissingYears'});

% Display
disp(GroupedTable);

% save to CSV
% writetable(GroupedTable, 'GroupedMissingYieldInfo.csv');
