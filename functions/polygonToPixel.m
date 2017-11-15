function pixel = polygonToPixel(polygon, latticeConst)

% This function pixelize a polygon with the given lattice constant. 
% The output is a vector of pixel including nearest neighbor pixels of this
% pixelized polygon. This is to prevent no two leads will overlap as the
% width of the leads would be the same as the latticeConst

% first, collect all the crossing points with sides of grids.
cross = [];
for i = 1:size(polygon, 1)-1
    cross = [cross; polygon(i, :); SegmentToCross(polygon(i, :), polygon(i+1, :), latticeConst)];
end
cross = [cross; polygon(end, :)];

pixel = [];
crossNorm = cross/latticeConst;  % normalize 
for i = 1:size(cross, 1) - 1
    nxt = round((crossNorm(i, :) + crossNorm(i+1, :))/2); % find the closest grid point
    pixel = [pixel ;
             nxt;...
             nxt + [ 0 +1];... % nearest neighbors
             nxt + [+1  0];... % nearest neighbors
             nxt + [ 0 -1];... % nearest neighbors
             nxt + [-1  0]];   % nearest neighbors
end
pixel = latticeConst*[pixel; pixel(1, :)]; % scale the used grid points back to the real coodinate