function innerNodesSpread = spreadOutNodes(innerNodes)

global dictionary_for_innernodes
global numNodes
global mindist

dist = zeros(1,length(innerNodes));
for i = 1:length(innerNodes)
    innerNodesCand = innerNodes;
    innerNodesCand = [innerNodesCand(i:end) innerNodesCand(1:i-1)-numNodes];
    dist(i) = sqrt(sum((innerNodesCand - mean(innerNodesCand)).^2));
end
[val, idx] = min(dist);
innerNodesCand = [innerNodes(idx:end) innerNodes(1:idx-1)];
dictionary_for_innernodes = [dictionary_for_innernodes; innerNodesCand]; %3 yes reordering
innerNodesCand(end-idx+2:end) = innerNodesCand(end-idx+2:end) - numNodes;
dictionary_for_innernodes = [dictionary_for_innernodes; innerNodesCand]; %4 no reordering

diff = innerNodesCand(1:end-1) - innerNodesCand(2:end);
diff_cong = diff(diff < mindist);
shift = sum(mindist*ones(1, length(diff_cong)) - diff_cong);
diff(diff < mindist) = mindist;

innerNodesCand = innerNodesCand(1) - [0 cumsum(diff)] + floor(shift/2);
innerNodesCand(innerNodesCand <= 0) = innerNodesCand(innerNodesCand <= 0) + numNodes;
dictionary_for_innernodes = [dictionary_for_innernodes; innerNodesCand]; %5 no reordering
innerNodesSpread = sort(innerNodesCand, 'descend');
dictionary_for_innernodes = [dictionary_for_innernodes; innerNodesSpread];
dictionary_for_innernodes = [dictionary_for_innernodes; innerNodesSpread]; %6 yes reordering
for i = 1:length(innerNodes)
    if dictionary_for_innernodes(7,i) >= numNodes + 1
        dictionary_for_innernodes(7,i) = dictionary_for_innernodes(7,i) - numNodes;
    elseif dictionary_for_innernodes(7,i)  <= 0
        dictionary_for_innernodes(7,i) = dictionary_for_innernodes(7,i) + numNodes;
    else
        dictionary_for_innernodes(7,i) = dictionary_for_innernodes(7,i);
    end
end
