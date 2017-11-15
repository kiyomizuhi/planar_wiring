function fingerEntry = generateFingerEntries(die)

numWrs = length(die.wrs);

fingerEntry = cell(1 ,numWrs);
for ii = 1:numWrs
    fingerEntryUnsorted = extractFingerEntries(ii, die);
    fingerEntry{ii} = sortFingerEntry(ii, fingerEntryUnsorted, die);
end
