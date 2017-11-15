N = 60;
latticeConst = 5;
range = [-N:5:N];
NN = length(range)^2;
[gridPnts, edges] = generateGridNodesAndEdges([range(1) range(end)], [range(1) range(end)], latticeConst);
str1 = find(ismember(gridPnts, 40*[-1 -1], 'rows'));
str2 = find(ismember(gridPnts, 40*[1 -1], 'rows'));
tgt = find(ismember(gridPnts, 40*[0 1], 'rows'));
usedGrid = zeros(size(gridPnts, 1), 1);
trty = generateRoundFrameNodes(tgt, 5, length(range));

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
for i = 1:size(edges, 1)
    nds{edges(i, 1)}.nbr = [nds{edges(i, 1)}.nbr edges(i, 2)];
end

figure(4);clf;
plot(gridPnts(:, 1), gridPnts(:, 2), '.', 'color', 0.8*[1 1 1], 'markersize', 15);hold on;
plot(gridPnts(str1, 1), gridPnts(str1, 2), 'r.', 'markerSize', 30);hold on;
plot(gridPnts(str2, 1), gridPnts(str2, 2), 'r.', 'markerSize', 30);hold on;
plot(gridPnts(tgt, 1), gridPnts(tgt, 2), 'b.', 'markerSize', 30);hold on;
axis square;
xlim(N*[-1.1 1.1]);
ylim(N*[-1.1 1.1]);

[path1, usedGrid, nds] = findShortestPath(nds, gridPnts, str1, tgt, trty, usedGrid);
plot(gridPnts(path1, 1), gridPnts(path1, 2), '-', 'color', 0.7*[0 1 0], 'linewidth', 3);hold on;
[pixel, cross] = polygonToCross(gridPnts(path1, :), latticeConst);
usedGrid(find(ismember(gridPnts, pixel, 'rows'))) = 1;
idx = find(usedGrid == 1);
plot(gridPnts(idx, 1), gridPnts(idx, 2), '.', 'color', 0.2*[1 1 1], 'markerSize', 30);hold on;drawnow;

[path2, usedGrid, nds] = findShortestPath(nds, gridPnts, str2, tgt, trty, usedGrid);
plot(gridPnts(path2, 1), gridPnts(path2, 2), '-', 'color', 0.7*[0 1 0], 'linewidth', 3);hold on;
idx = find(usedGrid == 1);
plot(gridPnts(idx, 1), gridPnts(idx, 2), '.', 'color', 0.2*[1 1 1], 'markerSize', 30);hold on;drawnow;

plot(gridPnts(str1, 1), gridPnts(str1, 2), 'r.', 'markerSize', 30);hold on;
plot(gridPnts(str2, 1), gridPnts(str2, 2), 'r.', 'markerSize', 30);hold on;
plot(gridPnts(tgt, 1), gridPnts(tgt, 2), 'b.', 'markerSize', 30);hold on;


% plot(gridPnts(trty , 1), gridPnts(trty , 2), 'k.', 'markerSize', 30);hold on;
% for i = 1:size(edges, 1)
%     x1 = gridPnts(edges(i, 1), 1);
%     y1 = gridPnts(edges(i, 1), 2);
%     x2 = gridPnts(edges(i, 2), 1);
%     y2 = gridPnts(edges(i, 2), 2);
%     plot([0.1*(x2-x1) + x1 0.45*(x2-x1) + x1], [0.1*(y2-y1) + y1 0.45*(y2-y1) + y1], '-', 'color', [0.8 0.8 1]);hold on;
% end