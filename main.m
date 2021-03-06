% We decompose the problem of finding leadCenterPaths into
%   1: from bonding pads (defined as Ls) to outer frame nodes
%   2: from outer frame nodes to inner frame nodes
%   3: from inner frame nodes to finger entry
%   4: finger entry to finger
%
% This code assumes fingers have been placed by hands on gds
% So, it does 1 to 3
%
% What are outer frame nodes and inner frame nodes?
% We introduce square frames with respect to each wire. 
% By default, there are 6 layers of inner frames and 1 layer of outer frame.
% Each frame has 20 nodes (5 nodes on each side)
% Each leadCenterPath connects
%                              pad node
%                              one of outer frame node
%                              one of inner frame node (of a inner frame)
%                              finger entry
%
% The connection between the outer frame node and inner frame node is a
% little tricky as none of the leadCenterPaths for a specific wire 
% should cross each other.
%
% In general, finger entry points are placed around the wire. Even if they 
% are gathered on one side of wire, there is no guarantee that the pad nodes
% are also on the same side so that you can straightly draw leads from 
% the pad nodes to the finger entries. So, the frames allow leadCenterPaths
% to go around the wire without crossing each other.
%
% The reason why there are multiple inner frames is that each frame can 
% accomodate up to 2 leadCenterPaths to be safe on the safe side (no crossings).
% Generally, leadCenterPaths have to follow the corresponding inner frames.
%
% We choose trajectories of leadCenterPaths that minimize the number of
% used inner layers. This is to be ready for a case using 10 fingers for one wire.
% Even that case, 6 inner frames would be able to accomodate 10
% leadCenterPaths. If you have to use more than 12 fingers, you would have
% to increase the number of inner frame layers.
%
% Note that I have not introduced a mechanism to avoid crossing in the case of having
% two wires very close (say, less than 30 microns). In such a case, you
% would have to manually erase the crossed path and draw new leads manually
% that do not cross each other!!!

clear all; close all;
DD = 1; %9
wiredata = 'manual';
die = loadDieData(DD, wiredata);

gdsfl = 'marks';
copyfile('~\draw_leads\ref_finger_mark.gds', [gdsfl '.gds']);
die = loadFingerTypes(die, wiredata);
die = placeFingers(die, gdsfl);

gdsFileNameToGenerate = 'extract';
exactPathofGdsBundle = '~\draw_leads\marks.gds';
die = extractMarkPolygons(die, exactPathofGdsBundle, gdsFileNameToGenerate);
die = extractFingerEntry(die);

for D = 1:DD
    sprintf('\n============================\n Starting Die %d\n============================', D)
    [die, innerleads, outerleads] = generateLeadCenterPath(die, D);
    plgs = [];
    gdsFile = gds_library_append(gdsfl);
    gds_start_structure(gdsFile, sprintf('Die_%d', D));
    numPad = numberOfPads;
    for i = 1:numPad
        if size(outerleads{i}.centerPath, 1) > 1
            lead = struct('points', centerPath(outerleads{i}.centerPath', outerleads{i}.width'), 'layer', outerleads{i}.layer, 'dataType', 0);
            plgs = [plgs lead];
        end
    end
    for i = 1:length(innerleads)
        for j = 1:length(innerleads{i})
            if ~isempty(innerleads{i}{j}.centerPath)
                lead = struct('points', centerPath(innerleads{i}{j}.centerPath', innerleads{i}{j}.width), 'layer', innerleads{i}{j}.layer, 'dataType', 0);
                plgs = [plgs lead];
            end
        end
    end
    gds_write_sref(gdsFile, sprintf('die_%d', D));
    gds_write_boundaries(gdsFile, plgs);
    gds_close_structure(gdsFile);
    gds_close_library(gdsFile);
end

gdsFile = gds_library_append(gdsfl);
gds_start_structure(gdsFile, 'whole');
for D = 1:DD
    gds_write_sref(gdsFile, sprintf('Die_%d', D));
end
gds_close_structure(gdsFile);
gds_close_library(gdsFile);