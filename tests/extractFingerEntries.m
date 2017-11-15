function fingerEntry = extractFingerEntries(idx, die)

wr = die.wrs(idx, :);
if ~isempty(wr.marks)
    if length(die.frameNodes{idx}) ~= length(wr.marks)
        error('the number of fingers have to match between gds and your input...')
    end
end

num_finger = length(die.frameNodes{idx});
fingerEntry = cell(1, num_finger);

for ii = 1:num_finger
    fingerEntry{ii} = struct('entry', [], 'width', [], 'layer', [], 'path', []);
    pts = wr.marks{ii}.points/1000;
    
    p1 = pts(:,1);
    p2 = pts(:,end-1);
    p3 = pts(:,2);
    p4 = pts(:,end-2);
    
    w = norm(p1-p3);
    pc1 = (p1 + p2)/2;
    pc2 = (p3 + p4)/2;
    
    fingerEntry{ii}.entry = [pc1' ; pc2'];
    fingerEntry{ii}.width = w;
    fingerEntry{ii}.layer = wr.marks{ii}.layer;
end
        
    