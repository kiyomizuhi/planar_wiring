function die = generateRandomWiresAndLeads(D, lambda)

% This code simulates various situations of wire and required leads.
% The output is "die" for this specific die D.
% The limitation is the total required leads cannot exceed 44.
% So, employing Poisson distribution, we sample a sequence of required
% leads (100). And look at cummulative sum. At the point (say, i) where the cumsum
% exceeds 44 is a sampled situation of wires and leads. The number of wires
% is numWrs = i. and wire"1" to wire"i" require numLds(1), ..., numLds(i)
% leads. The coodinate of the wires are sampled randomly. But try to
% distribute them over quadrants as equal as possible.

numPad = numberOfPads;

die = struct('wrs', [], 'edge', [], 'numLds', [], 'numWrsQuad', [], 'numWrs', 0);
rnd = poissrnd(randi(lambda), 50, 1);
rnd(rnd == 1) = 2;
rnd(rnd == 0) = 2;
rndcum = cumsum(rnd);

die.numLds = rnd(rndcum <= numPad);

die.numWrs = length(die.numLds);
rm = rem(die.numWrs, 4);
for i = 1:100
    rndbin = randi([0,1], 4, 1);
    if rm == sum(rndbin)
        die.numWrsQuad = floor(die.numWrs/4)*ones(4, 1) + rndbin;
        break;
    end
end

fprintf('number of wires per quad = %d\n',die.numWrsQuad)
fprintf('total number of wires    = %d\n',die.numWrs)
fprintf('total number of leads    = %d\n', sum(die.numLds))

die.wrs = [200*(2*rand(die.numWrsQuad(1), 2)-1) + repmat([-240 +240],die.numWrsQuad(1), 1);
           200*(2*rand(die.numWrsQuad(2), 2)-1) + repmat([+240 +240],die.numWrsQuad(2), 1);
           200*(2*rand(die.numWrsQuad(3), 2)-1) + repmat([-240 -240],die.numWrsQuad(3), 1);
           200*(2*rand(die.numWrsQuad(4), 2)-1) + repmat([+240 -240],die.numWrsQuad(4), 1)];
die.wrs = die.wrs + repmat(translateCoordinates(D), [size(die.wrs,1) 1]);

die.edge = cell(die.numWrs, 1);
for i = 1:die.numWrs
    theta = pi * rand();
    die.edge{i} = [die.wrs(i, :) + 2.5 * [cos(theta) sin(theta)]; die.wrs(i, :) + 2.5 * [cos(theta + pi) sin(theta + pi)]];
end