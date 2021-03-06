function [Die, innerleads, outerleads] = generateLeadCenterPath(Die, D)

% The input arguments should look as 
% 
% W = cell(D, Q) : cell array for each quadrant and die
% W{i, j} = cell(1,N) : cell array for each wire
%
% e.g. you have dies, i = 1:8, and (always) quadrants, j = 1:4.
%      then, D = 8 and Q = 4.
%      For each cell W{i, j}, there are N wires.
%      N can vary for each quadrant.
%      N is the number of wires in one quadrant. 
%
% e.g. For die i and quadrant j, there are 2 wires (N = 2).
%
% W{i, j}{1} = struct('edges' , [X11, Y11; X12, Y12];
%
% W{i, j}{2} = struct('edges' , [X21, Y21; X22, Y22];
%
% For each wire_i, provide [Xi1, Yi1; Xi2, Yi2]
% where X's and Y's are coordinates of the edges of each wire.
%
% :::::::::::::::::::: CAUTION :::::::::::::::::::::::::::::
% For the current version of this code, each quadrant can receive different designs of fingers
% HOWEVER, you have to repeat the same scheme for all the dies.
% e.g. if you decide to use 2 wires for the quadrant 1 with 5 fingers for each
% wire, 5 wires for the quadrant 2 with 2 fingers for each wire, and so on,
% you need to repeat this for the die 1, die 2, die 3... 
%
% :::::::::::::::::::: CAUTION :::::::::::::::::::::::::::::
%  
% For the current version of this code, it's safer to pick wires that are  
% at least 40 microns away fromn each other. In the future (soon) version, 
% this constraints will be relaxed. For now, if you have to pick such wires, 
% go ahead and might need to modifiy the leads manually after compilation.
%
% ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%
% Map of quadrants:
%
%     6 7 8 9 10  1 2 3 4 5
%     -----------------------
%  5 |           |           | 6
%  4 |           |           | 7
%  3 |     1     |     2     | 8
%  2 |           |           | 9
%  1 |           |           | 10
%    -----------------------
% 10 |           |           | 1 
%  9 |           |           | 2
%  8 |     3     |     4     | 3
%  7 |           |           | 4
%  6 |           |           | 5
%     -----------------------
%      5 4 3 2 1  10 9 8 7 6
%
% -----------------------------------------------
%
% Map of dies:
%
%   ------------------
%  |        |         |
%  |    1   |    2    |
%  |        |         |
%   ------------------
%  |        |         |
%  |    3   |    4    |
%  |        |         |
%   ------------------
%  |        |         |
%  |    5   |    6    |
%  |        |         |
%   ------------------
%  |        |         |
%  |    7   |    8    |
%  |        |         |
%   ------------------
%  |        |         |
%  |    9   |   10    |
%  |        |         |
%   ------------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global Ls
global outerFrame
global outerFrameNodes
global innerFrames
global innerFrameNodes
global figNumStart
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if D < 1
    error('You must have at least one die to draw leads')
end

die = Die{D};
figNumStart = getFigureNumber() + 100 * D;

% part 1: generate the coordinate of the beginning of leads.
Ls = loadLeadCoordinates(D);

% part 2: asign which leads are conneted to each wire
% %           Each wire is connected to a bunch of contiguous pad nodes.
% %           The number of leads required for each wire is given already.
% %           We have to check the lines connecting a wire and edge pad nodes
% %           of a contiguous pad nodes are not crossing lines connecting
% %           other wires.
die = groupWiresAndLeads(die, D);

% part 3: generate the paths of leads according to the grouping
% %           Given the groups, we need to pair up each pad node to an outer frame node 
% %           Upon doing that, we put a grid on the system and performs a BFS
% %           to find out the shortest but non-overlapping and non crossing paths
[die, outerleads] = generateOuterLeads(die, D);

% part 4: generate outer and inner frames that will glue the outer and inner leads
% %           The center of the frames are closest grid point to each wire        
[outerFrame, outerFrameNodes, innerFrames, innerFrameNodes] = generateOuterInnerFramesNodes(die);

% part 5: generate inner leads for each wire
% %           This is two steps: 1) find an inner frame node number (layer not 
% %           specified yet) for each finger entry and 2) given those inner
% %           frame nodes, find an arrangement of paths connecting to outer
% %           frame nodes that minimizes the number of used layers.
% %
% %           1) find crossings of the line conneting the wire center and a
% %           finger entries and the first inner frame. find inner frame nodes
% %           that are closest to the crossings and spread them out to avoid
% %           overlap of generated polygons of leadCenterPath.
% %
% %           2) This is a little tricky tho.
[die, innerleads] = generateInnerLeads(die);

Die{D} = die;
figNum = figNumStart;
figure(figNum);
% set(gcf, 'position', [-1100 50 1000 900]);
numPad = numberOfPads;
for i = 1:numPad
    plot(outerleads{i}.centerPath(:,1), outerleads{i}.centerPath(:,2), '-', 'color', 0.5*[1 0 1], 'lineWidth', 5);
    hold on;drawnow;pause(0.02);
end

for i = 1:die.numWrs
    for j = 1:length(die.finger{i})
        if ~isempty(innerleads{i}{j}.centerPath)
            plot(innerleads{i}{j}.centerPath(:,1), innerleads{i}{j}.centerPath(:,2), '-', 'color', 0.5*[0 1 1], 'lineWidth', 2);
            hold on;drawnow;pause(0.02);
        end
    end
end
P = translateCoordinates(D);
xlim([-500 500] + P(1));
ylim([-500 500] + P(2));
axis square;