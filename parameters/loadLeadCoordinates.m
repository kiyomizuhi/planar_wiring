function Ls = loadLeadCoordinates(D)

Ls = struct('node', [], 'extn', []);
numPads = numberOfPads;
leadEdge = leadEdgePos;

pos = [-400, -325, -250, -175, -100,    0, +100, +175, +250, +325, +400];
Ls.node = [pos; leadEdge * ones(1, length(pos))];       
Ls.extn = [pos;      500 * ones(1, length(pos))];

r1 = [ 0 +1; -1  0];
r2 = [-1  0;  0 -1];
r3 = [ 0 -1; +1  0];

Ls.node = [Ls.node r1*Ls.node r2*Ls.node r3*Ls.node]';
Ls.extn = [Ls.extn r1*Ls.extn r2*Ls.extn r3*Ls.extn]';

Ls.node = Ls.node + repmat(translateCoordinates(D), [numPads 1]);
Ls.extn = Ls.extn + repmat(translateCoordinates(D), [numPads 1]);