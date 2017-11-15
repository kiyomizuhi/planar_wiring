W = cell(1, 1);
W{1} = -2.5*[1 1] + 5*rand(1,2);
% W{2} = [222.5 321.3];

[outerFrame, outerFrameNodes, innerFrames, innerFrameNodes] = generateOuterInnerFramesNodes(W);

figure(12);clf;
for k = 1:length(W)
    plot(W{k}(1), W{k}(2), 'b.', 'markersize',20);hold on;
    plot(outerFrame{k}(:,1), outerFrame{k}(:,2), 'r-');hold on;
    plot(outerFrameNodes{k}(:,1), outerFrameNodes{k}(:,2), 'b.');hold on;
    for j = 1:length(innerFrames{k})
        plot(innerFrames{k}{j}(:,1), innerFrames{k}{j}(:,2), 'r-');hold on;
        plot(innerFrameNodes{k}{j}(:,1), innerFrameNodes{k}{j}(:,2), 'b.');hold on;
    end
end
axis equal;
plot(2.5*[-1 1 1 -1 -1], 2.5*[1 1 -1 -1 1], 'g-');hold on;
set(gca, 'xtick', [-100:5:100], 'ytick', [-100:5:100])
xlim(35*[-1 1])
ylim(35*[-1 1])
grid on;