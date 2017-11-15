function [path, usedGrid] = findShortestPath(nodes, edges, start, target, trty, usedGrid)

str = target;
tgt = start;

nds = cell(size(nodes, 1), 1);
for i = 1:size(nodes, 1)
    nd = node();
    nd.id = i;
    nds = [nds nd];
end
for i = 1:size(edges, 1)
    nds(edges(i, 1)).nbr = [nds(edges(i, 1)).nbr edges(i, 2)];
end

for i = usedGrid
    nds(i).visit = 1;
end

qeue = [str];
curr = str;
nds(curr).path = [curr];
nds(curr).visit = 1;
while curr ~= tgt
    curr = qeue(1);
    qeue(1) = [];
    for j = nds(curr).nbr
        if nds(j).visit == 0
            qeue = [qeue j];
            nds(j).visit = 1;
            nds(j).lvl = nds(curr).lvl + 1;
        end
    end
    curr = qeue(1);
end

for i = 1:size(nodes, 1)
    nds(i).visit = 0;
end

str = start;
tgt = target;
curr = str;
nds(curr).visit = 1;
path = [curr];

usedGrid(idx) = 1;

while ~ismember(curr, trty)
    nbrs = nds(curr).nbr;
    dists = 2^32*ones(1, length(nbrs));
    for j = 1:length(nbrs)
        if nds(nbrs(j)).visit == 0 & nds(nbrs(j)).lvl == nds(curr).lvl - 1
            dists(j) = norm(nodes(tgt, :) - nodes(nbrs(j), :));
        end
    end
    [val, ind] = min(dists);
    curr = nbrs(ind);
    nds(curr).visit = 1;
    path = [path curr];
end