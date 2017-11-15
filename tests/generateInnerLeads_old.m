function [thisFingerEntry, dictionary_for_outernodes] = generateInnerLeadsLoop(indexx)

global wrs
global ldw
global outerFrame
global innerFrames
global fingerEntry
global num_nodes
global num_finger
global index
global mindist

% figure(1234);clf;
% outerFrame = generateCorners(outerFrameNodes);
% plot(outerFrame(:,1)', outerFrame(:,2)', '-', 'color', 0.8*[1, 1, 1]);hold on;
% for i = 1:20
%     plot(outerFrameNodes(i,1), outerFrameNodes(i,2), 'o', 'color', 0.8*[0 1 0]);hold on;
% end
% for i = 1:length(innerFrames)    
%     innerFrame = generateCorners(innerFrames{i});
%     plot(innerFrame(:,1)', innerFrame(:,2)',  '-', 'color', 0.8*[1, 1, 1]);hold on;
%     for j = 1:20
%         plot(innerFrames{i}(j,1), innerFrames{i}(j,2), 'o', 'color', 0.8*[1 1 0]);hold on;
%     end
% end
% xlim([-250 250]);
% ylim([-250 250]);
% axis square;
% plot(wr.edges(:,1)', wr.edges(:,2)', 'r-', 'lineWidth', 2);hold on;

index = indexx;
thisFingerEntry = fingerEntry{index};
thisInnerFrames = innerFrames{index};
num_finger = length(thisFingerEntry);
num_nodes = size(outerFrame{index}, 1);
mindist = 2;

refpt = wrs{index}.center;
innerNodes = selectInnerNodes(refpt, thisFingerEntry);
innerNodes = spreadOutNodes(innerNodes);
nodesIndex = [1:num_nodes 1:num_nodes 1:num_nodes];

this_outer = sort(frameNodePairedTo{index}(:,2), 'descend')';

innerNodesPicked = [innerNodes + num_nodes...
                    innerNodes...
                    innerNodes - num_nodes];
                
shift = -num_finger+1:num_finger-1;
record = cell(1,length(shift)); % this keeps the attempts below
for ii = 1:length(shift)
    record{ii} = struct('shift', shift(ii),...
                        'layer', zeros(1, num_finger),...
                        'path',  zeros(num_finger, num_nodes),...
                        'span',  0,...
                        'score', zeros(1, num_finger),...
                        'sgn',   zeros(1, num_finger),...
                        'delta', zeros(1, num_finger),... % path length defined by this_outer - this_inner
                        'inner', zeros(1, num_finger),...
                        'outer', zeros(1, num_finger));
end

% figure(1245);clf;
for ii = 1:length(shift)
    si = [1:num_finger] + shift(ii)+ num_finger;    
    this_inner = innerNodesPicked(si);
    record{ii}.inner = this_inner;
    record{ii}.outer = this_outer;
    
    delta = this_outer - this_inner;   % path length defined by this_outer - this_inner
    record{ii}.delta = delta;
    sgn = sign(delta);                 % clockwise (+) or anti-clockwise (-)
    record{ii}.sgn = sgn;
    layerIdx = 10*ones(1, num_finger); % records if the node has been processed. 10 means un processed.
    
    union = [this_outer this_inner];
    record{ii}.span = max(union)- min(union);
    record{ii}.score = mean(layerIdx);
    
%     subplot(5,2,ii)
%     plot(-19:40, ones(1,60),'o', 'color', 0.8*[1 1 1]);hold on;
%     plot(-19:40, zeros(1,60),'o', 'color', 0.8*[1 1 1]);hold on;
%     for i = -19:40
%         plot([i i], [0 1], '-', 'color', 0.8*[1 1 1]);hold on;
%     end
%     plot([1 1], [0 1], '-', 'color', 0.6*[1 1 1]);hold on;
%     plot([21 21], [0 1], '-', 'color', 0.6*[1 1 1]);hold on;
%     colors = [1 0 0;...
%         0 1 0;...
%         0 0 1;...
%         1 0 1;...
%         0 1 1];
%     for i = 1:num_finger
%          plot(this_inner(i), ones(1,5),'o', 'color', colors(i,:));hold on;
%          plot(this_outer(i), zeros(1,5),'o', 'color', colors(i,:));hold on;
%     end
%     xlim([-20 40]);
%     ylim([-0.1 1.1]);
    
    if record{ii}.span >= num_nodes % it's impossible to find a configuration if ones has to wind more than num_nodes. So, move on to the next config.
%     if ~isempty(find(abs(delta) > num_nodes))
        continue
    end
    
    for jj = 1:num_finger
        if layerIdx(jj) == 10 % here, 10 means unprocessed node
            locj = jj;
            if delta(jj) == 0 || locj+1 > num_finger % the inner node and the outer node are the same index
                layerIdx(jj) = 1; % so, we set the layer index to 1
                
            elseif delta(jj) < 0 % connect the two nodes backward (counting from the inner node)
                count_overlap = 0; % count the number of overlapping segments
                while this_outer(locj) <= this_inner(locj+1) && this_inner(locj) >= this_inner(locj+1)
                    layerIdx(locj+1) = layerIdx(locj) - 1;
                    count_overlap = count_overlap + 1;
                    locj = locj + 1;
                    if locj + 1 > num_finger
                        break;
                    end
                end
                layerIdx(jj:locj) = layerIdx(jj:locj) + count_overlap + 1;
                
            elseif delta(jj) > 0 % connect the two nodes forward (counting from the inner node)
                while this_outer(locj) >= this_outer(locj+1) &&  this_inner(locj) <= this_outer(locj+1)
                    layerIdx(locj+1) = layerIdx(locj) + 1;
                    locj = locj + 1;
                    if locj + 1 > num_finger
                        break;
                    end
                end
                layerIdx(jj:locj) = layerIdx(jj:locj) + 1;
            end
            
        end
        
        if sgn(jj) == 0
            pathIdx = this_inner(jj) + num_nodes;
        else
            pathIdx = this_inner(jj) + num_nodes : sgn(jj) : this_outer(jj) + num_nodes;
        end
        
        if length(pathIdx) > 20
            pathIdx = pathIdx(1:end-20);
        end
        
        thisPath = nodesIndex(pathIdx);
        record{ii}.path(jj, 1:length(thisPath)) = thisPath;
    end
    layerIdx(layerIdx > 10) = layerIdx(layerIdx > 10) - 10;
    record{ii}.layer = layerIdx;
    record{ii}.score = mean(layerIdx);
%     for kk = 1:num_finger
%         plot([this_inner(kk) this_inner(kk) this_outer(kk) this_outer(kk)], [1 1-0.1*layerIdx(kk) 1-0.1*layerIdx(kk) 0], '-', 'color', 0.5*[1 1 1], 'lineWidth', 2);hold on;
%     end
end

scores = [];
for i = 1:length(shift)
    scores = [scores record{i}.score];
end
[val, idx] = min(scores);
innerLeadsRecord = record{idx};

[thisFingerEntry, dictionary_for_outernodes] = convertPathToActualPath(innerLeadsRecord, thisInnerFrames, thisFingerEntry);

% figure(1234);
for i = 1:num_finger
%     plot(fingerEntry{i}.path(:,1)',fingerEntry{i}.path(:,2)', '-', 'color', 0.5*[1 1 1], 'lineWidth', 2);hold on;
    widths = 0.3*ldw*ones(1, size(thisFingerEntry{i}.path, 1));
    widths(1) = thisFingerEntry{i}.width;
    widths(2) = thisFingerEntry{i}.width;
    widths(end) = ldw;
    thisFingerEntry{i}.width = widths;
end