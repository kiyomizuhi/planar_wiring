function fingerEntry = sortFingerEntry(idx, fingerEntryUnsorted)

pc = die.wrs(idx, :);
num_finger = length(fingerEntryUnsorted);
fingerEntry = cell(1, num_finger);

angles = zeros(num_finger, 1);
for i = 1:num_finger
    dx = fingerEntryUnsorted{i}.entry(1, 1) - pc(1);
    dy = fingerEntryUnsorted{i}.entry(1, 2) - pc(2);
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

% if length(unique(angles)) ~= length(angles)
%     error('there is a ')

[val, idx] = sort(angles, 'descend');
for j = 1:num_finger
    fingerEntry{j} = fingerEntryUnsorted{idx(j)};
end
    

