clear all
close all
clc

% central MRMR
% load('MRMRcentral.mat')
% temptable = KSfeatures.state;

% district-specific MRMR
% load('MRMRdistrictinfo.mat')

% main table data
Tdata = readtable("..\yielddataset_kansas_monthly_total_1981_2018_0mm.xlsx");

% selectedvars = temptable.("selected variables");
% selected_scores = temptable.("scores");

% Plot Year vs district vs yield
x_varname = "Year";
y_varname = "AgDistrictCode";
xdata = Tdata.(x_varname);
ydata = Tdata.(y_varname);
selectedvars = {'TONS_ACRE'};
selected_scores = 1;
surfplotmetdata(selectedvars,selected_scores,Tdata,xdata,ydata,x_varname,y_varname);

% Plot Year vs district vs metdata
% x_varname = "Year";
% y_varname = "AgDistrictCode";
% xdata = Tdata.(x_varname);
% ydata = Tdata.(y_varname);
% surfplotmetdata(selectedvars,selected_scores,Tdata,xdata,ydata,x_varname,y_varname);

% Plot Yield vs metdata
% x_varname = "TONS_ACRE";
% xdata = Tdata.(x_varname);
% scboxmetdata(selectedvars,selected_scores,Tdata,xdata,x_varname);
% schistmetdata(selectedvars,selected_scores,Tdata,xdata,x_varname)



function surfplotmetdata(selectedvars,selected_scores,Tdata,xdata,ydata,x_varname,y_varname)

x_unique = unique(xdata);
y_unique = unique(ydata);
layout_row = 1; % for yield only
layout_col = ceil(length(selectedvars)/layout_row);
figure("Units","normalized","OuterPosition",[0 0 1 1])
tiledlayout(layout_row,layout_col)
for varidx = 1:length(selectedvars)

    var = selectedvars{varidx};

    Z = zeros(length(x_unique),length(y_unique)); %%%%%%%%%%%%%%%%%% rows = xdata, cols = ydata

    for i = 1:length(x_unique)
        x_idx = find(xdata==x_unique(i));
        t = Tdata(x_idx,:); % table for that x
        targetvar = t.(var);
        y_of_x = t.(y_varname); % ys for that x
        for j = 1:length(y_unique)
            y_idx = find(y_of_x==y_unique(j));
            Z(i,j) = mean(targetvar(y_idx)); % average yield
        end
    end

    Zdata = zeros(size(Z));

    % Find NaN positions
    [nanrowIdx, nancolIdx] = find(isnan(Z));

    % Translate indices to years and districts
    missingYears     = x_unique(nanrowIdx);
    missingDistricts = y_unique(nancolIdx);

    % Put results in a table
    MissingTable = table(missingYears, missingDistricts, ...
        'VariableNames', {'Year', 'District'});

    disp(MissingTable);

    % save to CSV %%%%%%%%%%%%%%%%(uncomment the line below if you'd like to save the .csv)
    % writetable(MissingTable, 'MissingYield_ByYearDistrict.csv');

    % replace Nan by average
    for j = 1:length(y_unique)
        nandata = Z(:,j);
        x_nandata = (1:length(nandata))';
        data=interp1(x_nandata(~isnan(nandata)),nandata(~isnan(nandata)),x_nandata);
        Zdata(:,j) = data;
        % if end value is nan
        if isnan(Z(end,j))
            Zdata(end,j) = Z(end-1,j);
        end
    end


    Z = [Z,x_unique]; %%%%%%%%%%%%%%%%%% append x
    Z = [Z;[y_unique',0]]; %%%%%%%%%%%%%%%%%% append y

    nexttile
    newvar = strrep(var,"_","\_");

    s = surf(Zdata); yticks([1:length(x_unique)]); xticks([1:length(y_unique)]); yticklabels(x_unique); xticklabels(y_unique); ylabel(x_varname); xlabel(y_varname); zlabel(newvar); colorbar;
    % s.EdgeColor = "none";
    s.FaceColor = "interp";
    % title(x_varname + " vs " + y_varname + " vs " + newvar + " ::::: score " + string(round(selected_scores(varidx),2)))
    title(x_varname + " vs " + y_varname + " vs " + newvar)

end

% saveplot
% filename = x_varname + y_varname + "yield";
% saveas(gcf,[filename + ".png"])
% savefig(filename)

end


function schistmetdata(selectedvars,selected_scores,Tdata,xdata,x_varname)
agdst = Tdata.AgDistrictCode;
for varidx = 1:length(selectedvars)
    var = selectedvars{varidx};
    ydata = Tdata.(var);
    newvar = strrep(var,"_","\_");
    figure('units','inch','Position',[0 0 10 8])
    scatterhist(xdata,ydata,"Group",agdst,'Kernel','on','Marker','+odx^v*.d','Location','SouthEast','Direction','out');
    xlabel(strrep(x_varname,"_","\_")); ylabel(newvar)
    title("schist by district " + strrep(x_varname,"_","\_") + " " + newvar + "::::: score " + string(round(selected_scores(varidx),2)))

    % saveplot
    % filename = "schistdistrict" + x_varname + var;
    % saveas(gcf,[filename + ".png"])
    % savefig(filename)

end

end


function scboxmetdata(selectedvars,selected_scores,Tdata,xdata,x_varname)
agdst = Tdata.AgDistrictCode;
for varidx = 1:length(selectedvars)
    var = selectedvars{varidx};
    ydata = Tdata.(var);
    newvar = strrep(var,"_","\_");
    figure('units','inch','Position',[0 0 10 8])
    h = scatterhist(xdata,ydata,"Group",agdst,'Kernel','on','Marker','+odx^v*.d','Location','SouthEast','Direction','out');
    hold on;
    clr = get(h(1),'colororder');
    boxplot(h(2),xdata,agdst,'orientation','horizontal','color',clr);
    boxplot(h(3),ydata,agdst,'orientation','horizontal','color',clr);
    xlabel(strrep(x_varname,"_","\_")); ylabel(newvar)
    view(h(3),[270,90]);  % Rotate the Y plot
    axis(h(1),'auto');  % Sync axes
    hold off;
    title("scbox by district " + strrep(x_varname,"_","\_") + " " + newvar + "::::: score " + string(round(selected_scores(varidx),2)))

    % saveplot
    % filename = "scboxdistrict" + x_varname + var;
    % saveas(gcf,[filename + ".png"])
    % savefig(filename)

end

end