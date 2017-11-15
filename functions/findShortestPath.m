function path = findShortestPath(nds, gridPnts, start, target, trty, goal, usedGrid)

% This code is to find "a" shortest path given the start and target.
% usedGrid records which grid points cannot be used.

% First, initialize the nodes (nds) according to usedGrid
for i = 1:size(nds, 1)
    if usedGrid(i) == 1
        nds{i}.visit = 1;
        nds{i}.lvl = 2^32;
    else
        nds{i}.visit = 0;
        nds{i}.lvl = 2^32;
    end
end

% The strategy is to start from the target and update the levels (layers) of all the nodes within
% the shortest distances. This is just the breath first search.
str = target;
tgt = start;

qeue = [str];
curr = str;
nds{curr}.visit = 1;
while curr ~= tgt
    curr = qeue(1);
    qeue(1) = [];
    nbrs = nds{curr}.nbr;
    if isempty(nbrs)
        continue;
    end
    for j = nds{curr}.nbr
        if nds{j}.visit == 0
            qeue = [qeue j];
            nds{j}.visit = 1;
            nds{j}.lvl = nds{curr}.lvl + 1;
        end
    end
end

% before finding the shortest path, we initialize the "visit" of all the
% nodes according to the usedGrid.

usedGrid(trty) = 1;
for i = 1:size(nds, 1)
    if usedGrid(i) == 1
        nds{i}.visit = 1;
    else
        nds{i}.visit = 0;
    end
end

% Now, starting from the start and aim for the target. But the goal is to
% let it reach one of the outer frame nodes.

str = start;
tgt = target;

curr = str;
nds{curr}.visit = 1;
path = [curr];
while ~ismember(curr, goal)
    nbrs = nds{curr}.nbr;
    dists = 2^32*ones(1, length(nbrs));
    for j = 1:length(nbrs)
        if nds{nbrs(j)}.visit == 0 & nds{nbrs(j)}.lvl <= nds{curr}.lvl + 2
            dists(j) = norm(gridPnts(tgt, :) - gridPnts(nbrs(j), :));
        end
    end
    [val, ind] = min(dists);
    curr = nbrs(ind);
    nds{curr}.visit = 1;
    path = [path curr];
end
usedGrid(trty) = 0;
