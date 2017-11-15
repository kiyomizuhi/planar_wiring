function  cross = SegmentToCross(p1, p2, latticeConst)

% for the convenience to find the sides of grid points, normalize the
% coordinates with latticeConst and find the crossing points.

p1 = p1/latticeConst;
p2 = p2/latticeConst;

p1Ind = round(p1);
p2Ind = round(p2);
cross = [];
if p1Ind(1) < p2Ind(1)
    for i = p1Ind(1)-0.5:1:p2Ind(1)+0.5
        [xc, yc] = findSegmentsCrossing(p1, p2, [i -2^32], [i 2^32]); % 2^32 is just an arbitrary large number. representing a line along the boundary of a grid point.
        cross = [cross; xc yc];
    end
elseif p1Ind(1) > p2Ind(1)
    for i = p2Ind(1)-0.5:1:p1Ind(1)+0.5
        [xc, yc] = findSegmentsCrossing(p1, p2, [i -2^32], [i 2^32]);
        cross = [cross; xc yc];
    end
end
if p1Ind(2) < p2Ind(2)
    for i = p1Ind(2)-0.5:1:p2Ind(2)+0.5
        [xc, yc] = findSegmentsCrossing(p1, p2, [-2^32 i], [2^32 i]);
        cross = [cross; xc yc];
    end
elseif p1Ind(2) > p2Ind(2)
    for i = p2Ind(2)-0.5:1:p1Ind(2)+0.5
        [xc, yc] = findSegmentsCrossing(p1, p2, [-2^32 i], [2^32 i]);
        cross = [cross; xc yc];
    end
end
cross = unique(cross, 'rows'); % get rid of duplicates
cross = cross * latticeConst;  % bring the crossing points back to the original coordinates

% for the continuation of the pixels over segments
if p1(1) < p2(1)
    cross = sortrows(cross, 1);
else
    cross = flipud(sortrows(cross, 1));
end
