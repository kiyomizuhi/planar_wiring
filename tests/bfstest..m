N = 30;
str = 1; 
tgt = 150; 
[grid, edges] = generateGridNodesAndEdges(N*[-1 1], N*[-1 1], 5);
figure(4);clf;plot(grid(:, 1), grid(:, 2), '.', 'color', 0.8*[1 0 0]);hold on;
axis square;
xlim(N*[-1.1 1.1]);
ylim(N*[-1.1 1.1]);
% edgeSegs = zeros(size(edges));
for i = 1:size(edges, 1)
    x1 = grid(edges(i, 1), 1);
    y1 = grid(edges(i, 1), 2);
    x2 = grid(edges(i, 2), 1);
    y2 = grid(edges(i, 2), 2);
    plot([0.1*(x2-x1) + x1 0.45*(x2-x1) + x1], [0.1*(y2-y1) + y1 0.45*(y2-y1) + y1], '-', 'color', 0.8*[0 0 1]);hold on;
end
nds = breathFirstSearch(grid, edges, str, tgt);
obs = [27:35];
for i = obs
    nds(i).visit = 1;
end
path = nds(tgt).path;
plot(grid(str, 1), grid(str, 2), 'r.', 'markerSize', 20);hold on;
plot(grid(tgt, 1), grid(tgt, 2), 'r.', 'markerSize', 20);hold on;
for i = 1:length(path)-1
    plot([grid(path(i), 1) grid(path(i+1), 1)], [grid(path(i), 2) grid(path(i+1), 2)], '-', 'color', 0.7*[0 1 0], 'linewidth', 3);hold on;
end
for i = 1:size(grid,1)
    if nds(i).visit == 1
        plot(grid(i, 1), grid(i, 2), 'r.', 'color', 0.8*[1 0 0], 'markersize', 20);hold on;
    end
end