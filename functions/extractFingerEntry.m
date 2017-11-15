function die = extractFingerEntry(die)

DD = length(die);
for D = 1:DD
    numWrs = length(die{D}.marks);
    die{D}.('finger') = cell(1, numWrs);
    for ii = 1:numWrs
        numFinger = length(die{D}.marks{ii});
        die{D}.finger{ii} = cell(1, numFinger);
        for jj = 1:numFinger
            thisMark = die{D}.marks{ii}{jj};
            die{D}.finger{ii}{jj} = struct('entry', [], 'width', [], 'layer', [], 'path', []);
            pts = thisMark.points/1000;
            
            p1 = pts(:,1);
            p2 = pts(:,end-1);
            p3 = pts(:,2);
            p4 = pts(:,end-2);
            
            w = norm(p1-p3);
            pc1 = (p1 + p2)/2;
            pc2 = (p3 + p4)/2;
            
            die{D}.finger{ii}{jj}.entry = [pc1' ; pc2'];
            die{D}.finger{ii}{jj}.width = w;
            die{D}.finger{ii}{jj}.layer = thisMark.layer;
        end
    end
end

    