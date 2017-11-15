function die = loadDieData(DD, wiredata)

if strcmp(wiredata, 'auto')
    lambda = [4, 5];
    die = cell(DD, 1);
    for D = 1:DD
        diePreOrd = generateRandomWiresAndLeads(D, lambda);
        ord = [[1:diePreOrd.numWrs]'  sqrt(sum(diePreOrd.wrs.^2, 2))];
        ord = flipud(round(sortrows(ord, 2)));
        die{D} = diePreOrd;
        for i = 1:diePreOrd.numWrs
            die{D}.wrs(i, :) = diePreOrd.wrs(ord(i, 1), :);
            die{D}.edge{i} = diePreOrd.edge{ord(i)};
            die{D}.numLds(i) = diePreOrd.numLds(ord(i, 1));
        end
    end
elseif strcmp(wiredata, 'manual')
    die = cell(DD, 1);
    diePreOrd = loadWireCoordinates();
    for D = 1:DD
        P = translateCoordinates(D);
        ord = [[1:diePreOrd{D}.numWrs]'  sqrt(sum((diePreOrd{D}.wrs - repmat(P, [diePreOrd{D}.numWrs, 1])).^2, 2))];
        ord = flipud(round(sortrows(ord, 2)));
        die{D} = diePreOrd{D};
        for i = 1:diePreOrd{D}.numWrs
            die{D}.wrs(i, :) = diePreOrd{D}.wrs(ord(i, 1), :);
            die{D}.edge{i} = diePreOrd{D}.edge{ord(i)};
            die{D}.numLds(i) = diePreOrd{D}.numLds(ord(i, 1));
        end
    end
else
    error('wiredata = auto or manual')
end
