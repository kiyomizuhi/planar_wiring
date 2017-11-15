function wirePairedTo = groupLeadsWires()

global wrs
global Ls
global num_wires

wrperm = perms(wrs);
Lss = Ls.node;
num_wires = length(wrs);

if num_wires == 1;
    wirePairedTo = cell(1);
    wirePairedTo{1} = 1:num_wires;
    return;
end

for ii = 1:size(wrperm, 1)
    
    wirePairedTo = cell(1, num_wires);
    pairedWire = zeros(1, num_wires);
    
    wires = wrperm(ii, :);
    LL = [];
    for i = 1:num_wires
        LL = [LL length(wires{i}.marks)];
    end
    Ltail = cumsum(LL);
    Lhead = cumsum([0 LL(1:end-1)])+1;
    
    for jj = 1:num_wires-1
        flag = 0;
        wr1 = wires{jj}.center;
        ld1 = Lss(Lhead(jj), :);
        ld2 = Lss(Ltail(jj), :);
        
        for kk = jj+1:num_wires
            wr2 = wires{kk}.center;
            ld3 = Lss(Lhead(kk), :);
            ld4 = Lss(Ltail(kk), :);
            
            if checkSegmentsIntersect(ld1, wr1, ld3, wr2)
                flag = 1;
                break;
            end
            
            if checkSegmentsIntersect(ld2, wr1, ld3, wr2)
                flag = 1;
                break;
            end
            
            if checkSegmentsIntersect(ld1, wr1, ld4, wr2)
                flag = 1;
                break;
            end
            
            if checkSegmentsIntersect(ld2, wr1, ld4, wr2)
                flag = 1;
                break;
            end
        end
        
        if flag == 1
            break;
        elseif flag == 0
            wirePairedTo{jj} = Lhead(jj):Ltail(jj);
            pairedWire(jj) = 1;
        end
        
    end
    
    if isequal(pairedWire, [ones(1,num_wires-1) 0])
        wirePairedTo{num_wires} = Lhead(end):Ltail(end);
        break;
    end
end

if isempty(find(pairedWire == 0));
    error('can''t find non-crossing pairs')
end
wrs = wires;