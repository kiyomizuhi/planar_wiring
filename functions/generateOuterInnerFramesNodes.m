function [outerFrame, outerFrameNodes, innerFrames, innerFrameNodes] = generateOuterInnerFramesNodes(die)

global figNumStart

ldw = leadWidth;
mgn = marginWidth;
ltc = ldw+mgn; % lattice constant
nn = numberOfNodesOnOneSide();
ifw = innerFrameSizes;
numWrs = length(die.wrs);
latticeConst = latticeConstant;

outerFrame      = cell(1, numWrs);
outerFrameNodes = cell(1, numWrs);
innerFrames     = cell(1, numWrs);
innerFrameNodes = cell(1, numWrs);

for kk = 1:numWrs
    wrRnd = round(die.wrs(kk, :)/latticeConst)*latticeConst; % closest grid point to the wire
    ofrmc = wrRnd; %wrs{kk}
    outerFrame{kk} = [-3.0*ltc + ldw/2 + ofrmc(1)  +3.0*ltc - ldw/2 + ofrmc(2);
                      +3.0*ltc - ldw/2 + ofrmc(1)  +3.0*ltc - ldw/2 + ofrmc(2);
                      +3.0*ltc - ldw/2 + ofrmc(1)  -3.0*ltc + ldw/2 + ofrmc(2);
                      -3.0*ltc + ldw/2 + ofrmc(1)  -3.0*ltc + ldw/2 + ofrmc(2);
                      -3.0*ltc + ldw/2 + ofrmc(1)  +3.0*ltc - ldw/2 + ofrmc(2)];
                  
    
    outerFrameNodes{kk} = zeros(4*nn, 2);
    for i = 0:1:nn-1
        outerFrameNodes{kk}(0*nn + i + 1, :) = [-2*ltc + i*ltc + ofrmc(1)  +3*ltc - ldw/2 + ofrmc(2)];
        outerFrameNodes{kk}(1*nn + i + 1, :) = [+3*ltc - ldw/2 + ofrmc(1)  +2*ltc - i*ltc + ofrmc(2)];
        outerFrameNodes{kk}(2*nn + i + 1, :) = [+2*ltc - i*ltc + ofrmc(1)  -3*ltc + ldw/2 + ofrmc(2)];
        outerFrameNodes{kk}(3*nn + i + 1, :) = [-3*ltc + ldw/2 + ofrmc(1)  -2*ltc + i*ltc + ofrmc(2)];
    end
    
    innerFrameNodes{kk} = cell(1, length(ifw));
    innerFrames{kk}     = cell(1, length(ifw));
    for i = 1:length(ifw)
        fw = ifw(i);
        ifrmc = wrRnd; %wrs{kk}
        innerFrames{kk}{i} = [-fw/2 + ifrmc(1)  +fw/2 + ifrmc(2);
                              +fw/2 + ifrmc(1)  +fw/2 + ifrmc(2);
                              +fw/2 + ifrmc(1)  -fw/2 + ifrmc(2);
                              -fw/2 + ifrmc(1)  -fw/2 + ifrmc(2);
                              -fw/2 + ifrmc(1)  +fw/2 + ifrmc(2)];
        innerFrameNodes{kk}{i} = zeros(4*nn,2);
        for j = 1:4*nn
            if 1 <= j && j <= nn
                [innerFrameNodes{kk}{i}(j, 1), innerFrameNodes{kk}{i}(j, 2)]...
                    = findSegmentsCrossing(ifrmc, outerFrameNodes{kk}(j,:), innerFrames{kk}{i}(1, :), innerFrames{kk}{i}(2, :));
            elseif nn+1 <= j && j <= 2*nn
                [innerFrameNodes{kk}{i}(j, 1), innerFrameNodes{kk}{i}(j, 2)]...
                    = findSegmentsCrossing(ifrmc, outerFrameNodes{kk}(j,:), innerFrames{kk}{i}(2, :), innerFrames{kk}{i}(3, :));
            elseif 2*nn+1 <= j && j <= 3*nn
                [innerFrameNodes{kk}{i}(j, 1), innerFrameNodes{kk}{i}(j, 2)]...
                    = findSegmentsCrossing(ifrmc, outerFrameNodes{kk}(j,:), innerFrames{kk}{i}(3, :), innerFrames{kk}{i}(4, :));
            elseif 3*nn+1 <= j && j <= 4*nn
                [innerFrameNodes{kk}{i}(j, 1), innerFrameNodes{kk}{i}(j, 2)]...
                    = findSegmentsCrossing(ifrmc, outerFrameNodes{kk}(j,:), innerFrames{kk}{i}(4, :), innerFrames{kk}{i}(5, :));
            end
        end
    end
end

figNum = figNumStart + 2;
figure(figNum);
for jj = 1:length(outerFrame)
    plot(outerFrame{jj}(:,1)', outerFrame{jj}(:,2)', '-', 'color', 0.8*[1, 0.5 , 0]);hold on;
    plot(outerFrameNodes{jj}(:,1)', outerFrameNodes{jj}(:,2)', '.', 'color', 0.8*[1, 0 , 0]);hold on;
    for ii = 1:length(innerFrames{jj})
        plot(innerFrames{jj}{ii}(:,1)', innerFrames{jj}{ii}(:,2)', '-', 'color', 0.8*[0, 0.5, 1]);hold on;
        plot(innerFrameNodes{jj}{ii}(:,1)', innerFrameNodes{jj}{ii}(:,2)', '.', 'color', 0.8*[0, 0.5, 1]);hold on;
    end
end