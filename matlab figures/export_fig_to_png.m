clear all
close all
clc

fig_files = dir("*.fig");

for i = 1:length(fig_files)
    filename = fig_files(i).name;
    fig = openfig(filename, "new", "invisible");

    if contains(filename,'S2')
        set(fig,'Units','inches','Position',[0 0 20 24]); % resize for the 2 all-features figure
    elseif contains(filename,'S8')
        set(fig,'Units','inches','Position',[0 0 10 12]); % resize for the 2 plotmatrix figure
    end

    tempstr = extractBefore(filename,'.fig');
    %exportgraphics(fig, [tempstr + ".pdf"], 'ContentType', 'vector');
    exportgraphics(fig, [tempstr + ".png"], 'Resolution', 600);
    close(fig);

end