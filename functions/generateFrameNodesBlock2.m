function frame = generateFrameNodesBlock2(tgt, nn, N)

% This generates squarely teritory for a given wire. This is mark the frame 
% as used grid points after drawing leads for assuming nn = 13 as a
% default. N is the number of nodes on one side on the grid.

n = floor(nn/2);
if rem(tgt, N) < n || rem(tgt, N) > N - n || tgt - n*N < 0 ||  tgt + n*N > N^2
    error('target is too close to the boundary')
end

if rem(nn, 2) == 0
    error('the frame width should be an odd number')
end

left = tgt - n*N - n : tgt - n*N + n;
right = tgt + n*N - n : tgt + n*N + n;
top = tgt + n - n*N:N:tgt + n + n*N;
bottom = tgt - n - n*N:N:tgt - n + n*N;
frame = sort([left right top bottom]);