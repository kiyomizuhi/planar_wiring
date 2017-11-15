function frame = generateFrameNodesBlock1(tgt, nn, N)

% This generates squarely teritory for a given wire, that is negative of
% outer frame nodes. In searching for shortest pathes, this will navigate the leads to the outer frame nodes.
% This is mark the frame as used grid points after drawing leads for the wire. assuming nn = 13 as a
% default. N is the number of nodes on one side on the grid.

n = floor(nn/2);
if rem(tgt, N) < n || rem(tgt, N) > N - n || tgt - n*N < 0 ||  tgt + n*N > N^2
    error('target is too close to the boundary')
end

if rem(nn, 2) == 0
    error('the frame width should be an odd number')
end

m = n - 1;
left = tgt - m*N - m : tgt - m*N + m;
right = tgt + m*N - m : tgt + m*N + m;
top = tgt + m - m*N:N:tgt + m + m*N;
bottom = tgt - m - m*N:N:tgt - m + m*N;
frame = sort([left right top bottom]);

left = tgt - n*N - m : 2 : tgt - n*N + m;
right = tgt + n*N - m : 2 : tgt + n*N + m;
top = tgt + n - m*N: 2*N :tgt + n + m*N;
bottom = tgt - n - m*N: 2*N :tgt - n + m*N;
frame = sort([frame left right top bottom]);

top = [tgt + n - n*N tgt + n + n*N];
bottom = [tgt - n - n*N tgt - n + n*N];
frame = sort([frame top bottom]);