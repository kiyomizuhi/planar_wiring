function [die, leads] = generateInnerLeads(die)

leads = cell(die.numWrs, 1);
for ii = 1: die.numWrs
    leads{ii} = cell(length(die.finger{ii}), 1);
    for jj = 1:length(die.finger{ii})
        leads{ii}{jj} = leadPath;
        leads{ii}{jj}.centerPath = [];
        leads{ii}{jj}.width = [];
    end
end

for ii = 1: die.numWrs
    [die, leads] = generateInnerLeadsLoop(die, leads, ii);
end