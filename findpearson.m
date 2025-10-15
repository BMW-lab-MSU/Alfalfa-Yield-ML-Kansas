function [idx, scores] = findpearson(X, y)
    % Compute Pearson correlation for each predictor with respect to y
    numFeatures = size(X,2);
    scores = zeros(1, numFeatures);
    for i = 1:numFeatures
        r = corr(X(:,i), y, 'Type', 'Pearson');

        if isnan(r)
            scores(i) = 0; % Assign zero score for NaN correlation
        else
            scores(i) = abs(r); % absolute correlation
        end
    end
    
    % Normalize scores to [0, 1] range
    scores = normalize(scores, 'range');
    
    % Sort by descending score
    [~, idx] = sort(scores, 'descend');
end
