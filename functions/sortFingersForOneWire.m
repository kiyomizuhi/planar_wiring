function marksSorted = sortFingersForOneWire(pc, marks)

numFinger = length(marks);
marksSorted = marks;

angles = zeros(numFinger, 1);
for i = 1:numFinger
    dx = marks(i).points(1, 1) - pc(1);
    dy = marks(i).points(1, 2) - pc(2);
    if dx > 0 && dy > 0
        angles(i) = 180*atan(dy/dx)/pi;
    elseif dx > 0 && dy < 0
        angles(i) = 360 + 180*atan(dy/dx)/pi;
    elseif dx < 0 && dy > 0
        angles(i) = 180 + 180*atan(dy/dx)/pi;
    elseif dx < 0 && dy < 0
        angles(i) = 180 + 180*atan(dy/dx)/pi;
    elseif dx == 0 && dy ~= 0
        angles(i) = 180 - sgn(dy)*90;
    elseif dx ~= 0 && dy == 0
        angles(i) = 90 - sgn(dx)*90;
    else
        error('the entry point cannot be at the center of wire...')
    end
end

[val, idx] = sort(angles, 'descend');
for j = 1:numFinger
    marksSorted(j) = marks(idx(j));
end
    