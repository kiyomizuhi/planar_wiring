function innerNodes = selectInnerNodes(die)

global innerFrames
global innerFrameNodes
global dictionary_for_innernodes
global index
global numNodes
global numFinger

refpt = die.wrs(index, :);
innerNodes = zeros(1, length(die.finger{index}));
innerFrameCorners = innerFrames{index}{1};
thisFingerEntry = die.finger{index};
% figure(1234);
% for ii = 1:6
%     innerFrameCorners = generateFrameCorners(innerFrames{index}{ii});
%     plot(innerFrameCorners(:,1), innerFrameCorners(:,2), 'm-');hold on;
% end

nodeStepped = zeros(1, numNodes);
for ii = 1:numFinger
    ps = generateSegment(refpt, thisFingerEntry{ii}.entry(1,:));
    for kk = 1:4
        [xc, yc] = findSegmentsCrossing(thisFingerEntry{ii}.entry(1,:), ps, innerFrameCorners(kk, :), innerFrameCorners(kk + 1, :));
        if ~isempty(xc) && ~isempty(yc)
            pss = [xc yc];
            break;
        end
    end
    dists = sqrt(sum((innerFrameNodes{index}{1} - repmat(pss, [numNodes,1])).^2, 2));
    [val, idx] = min(dists);
    mm = 0;
    if nodeStepped(idx) == 0
        innerNodes(ii) = idx;
        nodeStepped(idx) = 1;
    else
        jj = idx;
        while nodeStepped(jj) ~= 0            
            jj = jj + 1;
            mm = mm + 1;
            if jj > numNodes
                jj = jj - numNodes;
            end
        end
        innerNodes(ii) = jj;
        nodeStepped(jj) = 1;
    end
end
innerNodes = innerNodes - floor(mm/2);
innerNodes(innerNodes <= 0) = innerNodes(innerNodes <= 0) + numNodes;
dictionary_for_innernodes = innerNodes;
innerNodes = sort(innerNodes, 'descend');
dictionary_for_innernodes = [dictionary_for_innernodes; innerNodes];