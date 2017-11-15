function die = groupWiresAndLeads(die, D)

global Ls
global figNumStart

% load some paramters
figNum = figNumStart + 1;
numPad = numberOfPads;

% id info
wrs = die.wrs;
numLds = die.numLds;
numWrs = size(die.wrs, 1);
die.wireLeads = cell(numWrs, 1);
die.frameNodes = cell(numWrs, 1);

% This is the core of this code. But it should be improved so it can
% handle also complex situations. If crossing, swap them.
% Should implement userinput swapping as the final resort.
usedLeads = zeros(numPad, 1);
for i = 1:numWrs
    thisNumLds = numLds(i);
    avl = find(usedLeads == 0);
    avls = [avl; avl; avl];
    shift = [1:length(avl)]' - ceil(length(avl)/2);
    dists = round(sortrows([avl sqrt(sum((Ls.node(avl, :) - repmat(wrs(i, :), [length(avl), 1])).^2, 2))], 2));
    dd = find(avl == dists(1, 1));
    hlf = floor(thisNumLds/2);
    score = [[1:length(avl)]' zeros(length(avl), 1)];
    inds = zeros(length(avl), thisNumLds);
    for j = 1:length(shift)
        inds(j, :) = length(shift) + [-hlf:-hlf+thisNumLds-1] + dd + shift(j);
        range = avls(inds(j, :));
        score(j, 2) = sum(sqrt(sum((repmat(wrs(i, :), [thisNumLds,1]) - Ls.node(range,:)).^2, 2)));
    end
    score = sortrows(score, 2);
    rng = sort(avls(inds(score(1,1), :)));
    usedLeads(rng) = 1;
    dists = round(sortrows([rng sqrt(sum((Ls.node(rng, :) - repmat(wrs(i, :), [length(rng), 1])).^2, 2))], 2));
    die.wireLeads{i} = dists(:, 1);
end

% The rest is to plot the situation of the die.
while true
    figure(figNum);clf;
    set(gcf, 'position', [-1200 50 1000 900]);
    plot(Ls.extn(:,1), Ls.extn(:,2), 'b.', 'markerSize',12);hold on;
    plot(Ls.node(:,1), Ls.node(:,2), 'b.', 'markerSize',12);hold on;
    for i = 1:numPad
        if 1  <= i && 11 >= i
            text(Ls.node(i, 1) - 15, Ls.node(i, 2) + 30, sprintf('p%2.0d', i), 'color', 'r')
        elseif 12 <= i && 22 >= i
            text(Ls.node(i, 1) + 15, Ls.node(i, 2) +  5, sprintf('p%2.0d', i), 'color', 'r')
        elseif 23 <= i && 33 >= i
            text(Ls.node(i, 1) - 15, Ls.node(i, 2) - 30, sprintf('p%2.0d', i), 'color', 'r')
        elseif 34 <= i && 44 >= i
            text(Ls.node(i, 1) - 55, Ls.node(i, 2) +  5, sprintf('p%2.0d', i), 'color', 'r')
        else
            pass
        end
    end
    for i = 1:numWrs
        plot(wrs(i, 1), wrs(i, 2), 'r.', 'markerSize', 8*numLds(i));hold on;
        sqr = 30;
        plot(wrs(i, 1)+ sqr * [-1 1 1 -1 -1], wrs(i, 2) + sqr * [1 1 -1 -1 1], 'g-', 'lineWidth', 0.2);hold on;
        text(wrs(i, 1)-31, wrs(i, 2)+30, sprintf('w%2.0d :%2.0d', i, numLds(i)), 'color', 'r')
        lim = 560;
        P = translateCoordinates(D);
        xlim(P(1) + [-1 1]*lim);
        ylim(P(2) + [-1 1]*lim);
        axis square;
        for j = die.wireLeads{i}'
            plot([wrs(i, 1) Ls.node(j, 1)], [wrs(i, 2) Ls.node(j, 2)], 'b-', 'linewidth', 0.2);hold on;
            text(wrs(i, 1)-31, wrs(i, 2)+30, sprintf('w%2.0d :%2.0d', i, numLds(i)), 'color', 'r')
        end
    end
    drawnow;
    
    % let's interact with the user to make sure if the user is satisfied
    % with the grouping. if not, let them swap leads as they want.
    usrans = input('Satisfied with the grouping? (y/n)\n', 's');
    while true
        if usrans == 'n' || usrans == 'N'
            ldSwp = input('which leads do you want to swap?\n');
            if length(ldSwp) ~= 2
                fprintf('You need to input two leads to swap\n')
                continue;
            end
            if sum(ismember(ldSwp, 1:numPad)) ~= 2
                fprintf(sprintf('The leads are 1 to %d\n', numPad))
                continue;
            end
            wrSwp = zeros(1, 2);
            ldIdx = zeros(1, 2);
            for k = 1:2
                for i = 1:numWrs
                    if ismember(ldSwp(k), die.wireLeads{i})
                        wrSwp(k) = i;
                        ldIdx(k) = find(die.wireLeads{i} ==  ldSwp(k));
                        break;
                    end
                end
            end
            die.wireLeads{wrSwp(1)}(ldIdx(1)) = ldSwp(2);
            die.wireLeads{wrSwp(2)}(ldIdx(2)) = ldSwp(1);
            break;
        elseif  usrans == 'y' || usrans == 'Y'
            break;
        else
            fprintf('answer with y/n...\n')
        end
    end
    if usrans == 'y'
        break;
    end
end