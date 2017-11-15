function fingerEntry = convertPathToActualPath(die, innerLeads, fingerEntry)

global index
global numNodes
global numFinger
global dictionary_for_innernodes
global innerFrames
global outerFrameNodes
global innerFrameNodes


actualPath = cell(1, numFinger);
dictionary_for_innernodes = [dictionary_for_innernodes; innerLeads.inner];
innerToAdd = zeros(1, numFinger);
headTail = zeros(2, numFinger);

for i = 1:numFinger
    if innerLeads.inner(i) >= numNodes + 1
        innerToAdd(i) = innerLeads.inner(i) - numNodes;
    elseif innerLeads.inner(i) <= 0
        innerToAdd(i) = innerLeads.inner(i) + numNodes;
    else
        innerToAdd(i) = innerLeads.inner(i);
    end
end
dictionary_for_innernodes = [dictionary_for_innernodes; innerToAdd];

for ii = 1:numFinger
    thisInnerFrameNodes = innerFrameNodes{index}{innerLeads.layer(ii)};
    thisInnerFrame = innerFrames{index}{innerLeads.layer(ii)};
    
    thispath = innerLeads.path(ii, :);
    thispath(thispath == 0) = [];
    idxOuter = find(die.frameNodes{index} == thispath(end));
    if isempty(idxOuter)
        continue;
    end
    headTail(:, ii) = [thispath(1); thispath(end)];
        
    corners = [];
    if innerLeads.sgn(ii) == 0
        actualPath{idxOuter} = [thisInnerFrameNodes(thispath(1),:);
                                outerFrameNodes{index}(thispath(end),:)];
        
    elseif innerLeads.sgn(ii) == -1
        for mm = 1:length(thispath)-1
            if thispath(mm) == 1 && thispath(mm+1) == 20
                corners = [corners; thisInnerFrame(1, :)];
            elseif thispath(mm) == 6 && thispath(mm+1) == 5
                corners = [corners; thisInnerFrame(2, :)];
            elseif thispath(mm) == 11 && thispath(mm+1) == 10
                corners = [corners; thisInnerFrame(3, :)];
            elseif thispath(mm) == 16 && thispath(mm+1) == 15
                corners = [corners; thisInnerFrame(4, :)];
            end
        end
        actualPath{idxOuter} = [thisInnerFrameNodes(thispath(1),:);
                                corners;
                                thisInnerFrameNodes(thispath(end),:);
                                outerFrameNodes{index}(thispath(end),:)];
        
    elseif innerLeads.sgn(ii) == +1
        for mm = 1:length(thispath)-1
            if thispath(mm) == 20 && thispath(mm+1) == 1
                corners = [corners; thisInnerFrame(1, :)];
            elseif thispath(mm) == 5 && thispath(mm+1) == 6
                corners = [corners; thisInnerFrame(2, :)];
            elseif thispath(mm) == 10 && thispath(mm+1) == 11
                corners = [corners; thisInnerFrame(3, :)];
            elseif thispath(mm) == 15 && thispath(mm+1) == 16
                corners = [corners; thisInnerFrame(4, :)];
            end
        end
        actualPath{idxOuter} = [thisInnerFrameNodes(thispath(1),:);
                                corners;
                                thisInnerFrameNodes(thispath(end),:);
                                outerFrameNodes{index}(thispath(end),:)];
    end

    temp = find(dictionary_for_innernodes(7,:) == dictionary_for_innernodes(9,ii));
    temp = find(dictionary_for_innernodes(5,:) == dictionary_for_innernodes(6,temp));
    temp = find(dictionary_for_innernodes(2,:) == dictionary_for_innernodes(3,temp));
    idxInner = find(dictionary_for_innernodes(1,:) == dictionary_for_innernodes(2,temp));
    
    fingerEntry{idxInner}.path = [fingerEntry{idxInner}.entry(2,:);
                                  fingerEntry{idxInner}.entry(1,:);
                                  actualPath{idxOuter}];
    
end