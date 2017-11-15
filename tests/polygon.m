[X, Y] = meshgrid([1:20], [1:20]);
stepped = zeros(size(X));
stepped(4:9,1:16) = 1;
curr = [2 2];
targ = [15 5];
step = [1 0; -1 0; 0 1; 0 -1];
path = [];
figure(2);clf;
set(gcf, 'position', [-1150 50 1000 900])
for i = 1:size(X)
    for j = 1:size(Y)
        if stepped(i, j) == 1
            plot(i+0.55*[-1 1 1 -1 -1], j+0.55*[1 1 -1 -1 1], '-', 'color', 0.5*[0 1 1], 'linewidth',2);hold on;
        end
    end
end

while norm(targ - curr) > 1
    nxt = repmat(curr, [4, 1]) + step;
    next = [];
    for i = 1:4
        if stepped(nxt(i, 1), nxt(i, 2)) == 0
            next = [next; nxt(i, :)];
        end
    end
    if 
    dists = sum((repmat(targ, [size(next, 1), 1]) - next).^2, 2)
    fprintf('')
    [val, ind] = min(dists);
    curr = next(ind, :);
    stepped(curr(1), curr(2)) = 1;
    path = [path; curr];
end
i = 1;
while i <= size(path, 1)-2
    if norm(path(i+2, :) - path(i, :)) < 1.5 
        path(i+1, :) = [];
        i = i + 1;
    else
        i = i + 1;
    end
end        
plot(path(:,1), path(:,2),'.-');hold on;
plot(X(:), Y(:), '.', 'color', 0.7*[1 1 1]);
for i = 1:size(X)
    for j = 1:size(Y)
        if stepped(i, j) == 1
            plot(i+0.5*[-1 1 1 -1 -1], j+0.5*[1 1 -1 -1 1], '-', 'color', 0.7*[1 1 0]);
        end
    end
end
xlim([0 21])
ylim([0 21])
axis square;
