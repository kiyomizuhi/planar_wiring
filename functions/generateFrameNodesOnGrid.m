function frame = generateFrameNodesOnGrid(tgt, nn, N)

% This generates outer frame nodes for a given wire. assuming nn = 13 as a
% default. N is the number of nodes on one side on the grid.

n = floor(nn/2);
if rem(tgt, N) < n || rem(tgt, N) > N - n || tgt - n*N < 0 ||  tgt + n*N > N^2
    error('target is too close to the boundary')
end

if rem(nn, 2) == 0
    error('the frame width should be an odd number')
end

left = tgt - n*N - n + 2 : 2 : tgt - n*N + n - 2;
right = tgt + n*N + n - 2 : -2 : tgt + n*N - n + 2;
top = tgt + n - (n - 2)*N: 2*N :tgt + n + (n - 2)*N;
bottom = tgt - n + (n - 2)*N: -2*N :tgt - n - (n - 2)*N;
frame = [top right bottom left];