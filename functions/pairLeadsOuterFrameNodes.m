function [leadsPolygons, frameNodePairedTo, outerFrame, innerFrames] = pairLeadsOuterFrameNodes()

global wrs
global wirePairedTo
global Ls
global num_wires

leadsPolygons  = cell(1,11);
outerFrame = cell(1, num_wires);
innerFrames = cell(1, num_wires);
mm = 4*numberOfNodesOnOneSide();

for i = 1:11
    leadsPolygons{i} = [Ls.extension(i,:); Ls.node(i,:)];
end

frameNodePairedTo = cell(1, num_wires);
for i = 1:num_wires
    frameNodePairedTo{i} = [wirePairedTo{i}' zeros(length(wirePairedTo{i}), 1)];
end

for ii = 1:num_wires
    [nodesW2F, outerFrameNodes, innerFrameNodes] = generateWireNodesFrames(wrs{ii}.center);
    outerFrame{ii} = nodesW2F;
    innerFrames{ii} = innerFrameNodes;
    pairedFrameNodes = zeros(1,mm);
    
    for jj = 1:length(wirePairedTo{ii})
        mm = wirePairedTo{ii}(jj);
        for kk = 1:4
            [temp1, temp2] = findSegmentsCrossing(Ls.node(mm,:), wrs{ii}.center, outerFrameNodes(kk,:), outerFrameNodes(kk+1,:));
            if ~isempty(temp1) && ~isempty(temp2)
                crossing = [temp1 temp2];
                break;
            end
        end
        dists = sqrt(sum((repmat(crossing, [mm 1]) - nodesW2F).^2, 2));
        [val, idx] = min(dists);
        idx = idx - 1;
        if idx < 1
            idx = idx + mm;
        end
        while pairedFrameNodes(idx) == 1
            idx = idx + 1;
            if idx > mm
                idx = idx - mm;
            end
        end
        pairedFrameNodes(idx) = 1;
        frameNodePairedTo{ii}(jj, 2) = idx;
    end
end    