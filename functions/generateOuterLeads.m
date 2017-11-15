function [die, leads] = generateOuterLeads(die, D)

global Ls
global figNumStart
% This code generates all the lead paths.

% load some parameters
figNum = figNumStart + 2;
numPad = numberOfPads;
latticeConst = latticeConstant; % it might be better just to use "leadWidth;"
P = translateCoordinates(D);
leadEdge = leadEdgePos;
rangex = leadEdge*[-1 +1] + P(1);
rangey = leadEdge*[-1 +1] + P(2);
N = length(rangex(1):latticeConst:rangex(2));
frame = 13;
numWrs = size(die.wrs, 1);

% generate lead path instantces (leadPath is a class)
ldw = leadWidth;
leads = cell(numPad, 1);
for i = 1:numPad
    leads{i} = leadPath;
    leads{i}.centerPath = [Ls.extn(i, :)];
    leads{i}.width = [];
end


% generate a graph representation of the die with lattice constant = 5 by
% default which is equal to the lead width
[gridPnts, edges] = generateGridNodesAndEdges(rangex, rangey, latticeConst);
plot(gridPnts(:, 1), gridPnts(:, 2), '.', 'color', 0.8*[1 1 1]);hold on;drawnow;


% usedGrid will keep track which nodes (grid points) are used
usedGrid = zeros(size(gridPnts, 1), 1);


% generate node struct and initialize them.
nds = cell(size(gridPnts, 1), 1);
for i = 1:size(gridPnts, 1)
    nds{i} = struct('id', i,...
        'visit', 0,...
        'nbr', [],...
        'lvl', 2^32);
    if usedGrid(i) == 1
        nds{i}.visit = 1;
    end
end
% this could have been more succint if we use node class (by method of "grid" class).
for i = 1:size(edges, 1)
    nds{edges(i, 1)}.nbr = [nds{edges(i, 1)}.nbr edges(i, 2)];
end


figure(figNum);
set(gcf, 'position', [-1150 50 1000 900]);
% We generate center paths for each wire accodingly.
for i = 1:numWrs
    wireLeads = die.wireLeads{i}; % grouped leads for this wire
    wrRound = round(die.wrs(i, :)/latticeConst)*latticeConst; % closest grid point to the wire
    tgt = find(ismember(gridPnts, wrRound, 'rows')); % target location on grid
    trty1 = generateFrameNodesBlock1(tgt, frame, N); % teritory 1 (refer to the comment in the code)
    trty2 = generateFrameNodesBlock2(tgt, frame, N); % teritory 2 (refer to the comment in the code)
    outerNodes = generateFrameNodesOnGrid(tgt, frame, N); % the locations of outer frame nodes on the grid 
    
    % This try and catch are for the case if the order of path drawing
    % does not work. (start with the one with the shortest straight distance to the target)
    % If not, order will be flipped.
    try
        thisUsedGrid = usedGrid; % creat a temporal handle for the usedGrid.
        die.frameNodes{i} = zeros(1, length(wireLeads)); % this will record the connected outer frame nodes for this wire
        for j = 1:length(wireLeads)
            ldIdx = wireLeads(j);
            str = find(ismember(gridPnts, Ls.node(ldIdx, :), 'rows')); % the location of Ls.node(ldIdx, :) on the grid
            fprintf('lead %2.0d started. str = %5.0d. tgt = %5.0d.\n',ldIdx, str, tgt)
            path = findShortestPath(nds, gridPnts, str, tgt, trty1, trty2, thisUsedGrid); % found the path
            leads{ldIdx}.centerPath = [Ls.extn(ldIdx, :); gridPnts(path, :)];
            leads{ldIdx}.width = ldw * ones(length(path) + 1, 1);
            pixel = polygonToPixel(leads{ldIdx}.centerPath, latticeConst); % find used grid points and nearest neighbors of the found path
            thisUsedGrid(find(ismember(gridPnts, pixel, 'rows'))) = 1;
            idx = find(thisUsedGrid == 1);
            
            plot(leads{ldIdx}.centerPath(:, 1), leads{ldIdx}.centerPath(:, 2),...
                '-', 'color', 0.7*[0 1 0], 'linewidth', 5);hold on;drawnow;
            plot(gridPnts(idx, 1), gridPnts(idx, 2), '.', 'color', 0.2*[1 1 1]);hold on;axis square;drawnow;
            
            die.frameNodes{i}(j) = find(outerNodes == path(end));
            
            nodeToStitch = leads{ldIdx}.centerPath(end,:);
            tgtCoordinate = gridPnts(tgt, :);
            delta = nodeToStitch - tgtCoordinate;
            if delta(1) == +latticeConst * floor(frame/2)
                stitch = [-1  0]*latticeConst/2;
            elseif delta(1) == -latticeConst * floor(frame/2)
                stitch = [+1  0]*latticeConst/2;
            elseif delta(2) == +latticeConst * floor(frame/2)
                stitch = [ 0 -1]*latticeConst/2;
            elseif delta(2) == -latticeConst * floor(frame/2)
                stitch = [ 0 +1]*latticeConst/2;
            else
                error('where did it end up?')
            end
            leads{ldIdx}.centerPath = [leads{ldIdx}.centerPath; leads{ldIdx}.centerPath(end,:) + stitch];
            leads{ldIdx}.width  = [leads{ldIdx}.width; ldw];
        end
    catch
        thisUsedGrid = usedGrid;
        continue;
    end
    usedGrid = thisUsedGrid;
    usedGrid(trty2) = 1;
    idx = find(usedGrid == 1);
    plot(gridPnts(idx, 1), gridPnts(idx, 2), '.', 'color', 0.2*[1 1 1]);hold on;drawnow;
end
