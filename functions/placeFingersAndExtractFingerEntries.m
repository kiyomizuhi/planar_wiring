function fingerEntry = placeFingersAndExtractFingerEntries(idx)

global Q
global D
global wrs
global frameNodePairedTo
global wirePairedTo
global Ls
global gdsfl
global structNames

wr = wrs{idx};
pc = wr.refPoint;
pe = wr.edges(:);

num_finger = length(wirePairedTo{idx});
ln1 = Ls.node(frameNodePairedTo{idx}(1, 1),:);
ln2 = Ls.node(frameNodePairedTo{idx}(end, 1),:);

if checkSegmentsIntersect(wr.edges(1, :), ln1, wr.edges(2, :), ln2)
    temp = wr.edges(1, :);
    wr.edges(1, :) = wr.edges(2, :);
    wr.edges(2, :) = temp;
end

theta_rad = atan((pe(4)-pe(3))/(pe(2)-pe(1)));
if theta_rad < 0
    theta_rad = theta_rad + 2*pi;
end
theta_deg = 180*theta_rad/pi;
% theta_deg = 180*atan((pe(4)-pe(3))/(pe(2)-pe(1)))/pi; 

gdsFile = gds_library_append(gdsfl);
gds_start_structure(gdsFile, sprintf('finger%d_%d_%d', D, Q, idx));
gds_write_sref(gdsFile, structNames{D, Q}, 'refPoint', pc', 'angle', theta_deg);
gds_close_structure(gdsFile);
gds_close_library(gdsFile);

finger = gds_load([gdsfl '.gds']);
aa = gds_flat_structure(finger.structures,  sprintf('finger%d_%d_%d', D, Q, idx));

num_finger_verify = 0;
for i = 1:length(aa.plgs)
    if aa.plgs(i).layer == 23
        num_finger_verify = num_finger_verify + 1;
    end
end

if num_finger_verify ~= num_finger
    error('the number of fingers have to match between gds and your input...')
end

fingerEntry = cell(1, num_finger);
for i = 1:num_finger
    fingerEntry{i} = struct('entry', [], 'width', [], 'layer', [], 'path', []);
end

idxM = [];
idxF = [];
for i = 1:length(aa.plgs)
    if aa.plgs(i).layer == 23 % LYR_FINGER_ENTRY
        idxM = [idxM i];
    else
        idxF = [idxF i];
    end
end

for j = 1:length(idxM)
    pts = aa.plgs(idxM(j)).points/1000;
    
    p1 = pts(:,1);
    p2 = pts(:,end-1);
    p3 = pts(:,2);
    p4 = pts(:,end-2);
    
    w = norm(p1-p3);
    pc1 = (p1 + p2)/2;
    pc2 = (p3 + p4)/2;
    
    fingerEntry{j}.entry = [pc1' ; pc2'];
    fingerEntry{j}.width = w;
    
    for k = idxF
        % find a way to match the polygon and extract layer number
        layer = checkWhichLayer(aa.plgs(k), [p1 p2]);
        if isempty(layer)
            continue;
        else
            fingerEntry{j}.layer = layer;
            break;
        end
    end
end
        
    