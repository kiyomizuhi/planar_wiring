function die = groupWiresAndLeads(DD, wireData)

numPad = numberOfPads;
for D = 1:DD
    if strcmp(wireData, 'auto')
        diePreOrd = generateRandomWiresAndLeads(D);
        ord = [[1:diePreOrd{1}.numWrs]'  sqrt(sum(diePreOrd{1}.wrs.^2, 2))];
        ord = flipud(round(sortrows(ord, 2)));
        die = diePreOrd;
    elseif strcmp(wireData, 'manual')
        diePreOrd = generateRandomWiresAndLeads(D);
        ord = [[1:diePreOrd{1}.numWrs]'  sqrt(sum(diePreOrd{1}.wrs.^2, 2))];
        ord = flipud(round(sortrows(ord, 2)));
        die = diePreOrd;
    else
        error('')
    end
    
    for i = 1:diePreOrd{1}.numWrs
        die{D}.wrs(i, :) = diePreOrd{1}.wrs(ord(i, 1), :);
        die{D}.numLds(i) = diePreOrd{1}.numLds(ord(i, 1));
    end
    wrs = die{1}.wrs;
    numLds = die{1}.numLds;
    numWrs = size(die{1}.wrs, 1);
    
    Ls = loadLeadCoordinates(D);
    ldw = leadWidth;
    leads = cell(numPad, 1);
    for i = 1:numPad
        leads{i} = leadPath;
        leads{i}.centerPath = [Ls.extn(i, :); Ls.node(i, :)];
        leads{i}.width = [ldw ldw]';
    end
    
    usedLeads = zeros(numPad, 1);
    die{D}.wireLeads = cell(numWrs, 1);
    for i = 1:numWrs
        wr = wrs(i, :);
        thisNumLds = numLds(i);
        thisLeadNode = Ls.node;
        avl = find(usedLeads == 0);
        avls = [avl; avl; avl];
        shift = [1:length(avl)]' - ceil(length(avl)/2);
        dists = round(sortrows([avl sqrt(sum((thisLeadNode(avl, :) - repmat(wr, [length(avl), 1])).^2, 2))], 2));
        dd = find(avl == dists(1, 1));
        hlf = floor(thisNumLds/2);
        score = [[1:length(avl)]' zeros(length(avl), 1)];
        inds = zeros(length(avl), thisNumLds);
        for j = 1:length(shift)
            inds(j, :) = length(shift) + [-hlf:-hlf+thisNumLds-1] + dd + shift(j);
            range = avls(inds(j, :));
            score(j, 2) = sum(sqrt(sum((repmat(wr, [thisNumLds,1]) - thisLeadNode(range,:)).^2, 2)));
        end
        score = sortrows(score, 2);
        rng = sort(avls(inds(score(1,1), :)));
        usedLeads(rng) = 1;
        die{D}.wireLeads{i} = rng;
    end
    
end

% figure(5);clf;
% set(gcf, 'position', [-1150 50 1000 900])
% plot(Ls.extn(:,1), Ls.extn(:,2), 'b.', 'markerSize',12);hold on;
% plot(Ls.node(:,1), Ls.node(:,2), 'b.', 'markerSize',12);hold on;
% for i = 1:numPad
%     if 1  <= i && 11 >= i
%         text(Ls.node(i, 1) - 15, Ls.node(i, 2) + 30, sprintf('p%2.0d', i), 'color', 'r')
%     elseif 12 <= i && 22 >= i
%         text(Ls.node(i, 1) + 15, Ls.node(i, 2) +  5, sprintf('p%2.0d', i), 'color', 'r')
%     elseif 23 <= i && 33 >= i
%         text(Ls.node(i, 1) - 15, Ls.node(i, 2) - 30, sprintf('p%2.0d', i), 'color', 'r')
%     elseif 34 <= i && 44 >= i
%         text(Ls.node(i, 1) - 55, Ls.node(i, 2) +  5, sprintf('p%2.0d', i), 'color', 'r')
%     else
%         pass
%     end
% end
% for i = 1:numWrs
%     plot(wrs(i, 1), wrs(i, 2), 'r.', 'markerSize', 8*numLds(i));hold on;
%     sqr = 30;
%     plot(wrs(i, 1)+ sqr * [-1 1 1 -1 -1], wrs(i, 2) + sqr * [1 1 -1 -1 1], 'g-', 'lineWidth', 0.2);hold on;
%     text(wrs(i, 1)-31, wrs(i, 2)+30, sprintf('w%2.0d :%2.0d', i, numLds(i)), 'color', 'r')
%     lim = 560;
%     xlim([-1 1]*lim);
%     ylim([-1 1]*lim);
%     axis square;
%     for j = wireLeads{i}'
%         plot([wrs(i, 1) Ls.node(j, 1)], [wrs(i, 2) Ls.node(j, 2)], 'b-', 'linewidth', 0.2);hold on;
%         text(wrs(i, 1)-31, wrs(i, 2)+30, sprintf('w%2.0d :%2.0d', i, numLds(i)), 'color', 'r')
%     end
% end
% [X, Y] = meshgrid([-495:5:495], [-495:5:495]);
% plot(X(:), Y(:), '.', 'color', 0.8*[1 1 1]);