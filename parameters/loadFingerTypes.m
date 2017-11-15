function die = loadFingerTypes(die, wiredata)

DD = length(die);

if strcmp(wiredata, 'manual')
    
    fingerTypes{1}{1} = 'dummy'; numlds{1}{1} = 4;
    fingerTypes{1}{2} = 'dummy'; numlds{1}{2} = 4;
    fingerTypes{1}{3} = 'dummy'; numlds{1}{3} = 4;
    fingerTypes{1}{4} = 'dummy'; numlds{1}{4} = 4;
    fingerTypes{1}{5} = 'dummy'; numlds{1}{5} = 4;
    fingerTypes{1}{6} = 'dummy'; numlds{1}{6} = 4;
    fingerTypes{1}{7} = 'dummy'; numlds{1}{7} = 4;
    fingerTypes{1}{8} = 'dummy'; numlds{1}{8} = 4;
    
    die{1}.('fingerTypes') = fingerTypes{1};
    
%     fingerTypes{2}{1} = 'dummy'; numlds{2}{1} = 4;
%     fingerTypes{2}{2} = 'dummy'; numlds{2}{2} = 4;
%     fingerTypes{2}{3} = 'dummy'; numlds{2}{3} = 4;
%     fingerTypes{2}{4} = 'dummy'; numlds{2}{4} = 4;
%     fingerTypes{2}{5} = 'dummy'; numlds{2}{5} = 4;
%     fingerTypes{2}{6} = 'dummy'; numlds{2}{6} = 4;
%     fingerTypes{2}{7} = 'dummy'; numlds{2}{7} = 4;
%     fingerTypes{2}{8} = 'dummy'; numlds{2}{8} = 4;
%     
%     die{2}.('fingerTypes') = fingerTypes{2};
%     
%     fingerTypes{2}{1} = 'dummy1'; numlds{2}{1} = 4;
%     fingerTypes{2}{2} = 'dummy1'; numlds{2}{2} = 4;
%     fingerTypes{2}{3} = 'dummy1'; numlds{2}{3} = 4;
%     fingerTypes{2}{4} = 'dummy1'; numlds{2}{4} = 4;
%     fingerTypes{2}{5} = 'dummy1'; numlds{2}{5} = 4;
%     fingerTypes{2}{6} = 'dummy1'; numlds{2}{6} = 4;
%     fingerTypes{2}{7} = 'dummy1'; numlds{2}{7} = 4;
%     fingerTypes{2}{8} = 'dummy1'; numlds{2}{8} = 4;
%     
%     fingerTypes{3}{1} = 'dummy1'; numlds{3}{1} = 4;
%     fingerTypes{3}{2} = 'dummy1'; numlds{3}{2} = 4;
%     fingerTypes{3}{3} = 'dummy1'; numlds{3}{3} = 4;
%     fingerTypes{3}{4} = 'dummy1'; numlds{3}{4} = 4;
%     fingerTypes{3}{5} = 'dummy1'; numlds{3}{5} = 4;
%     fingerTypes{3}{6} = 'dummy1'; numlds{3}{6} = 4;
%     fingerTypes{3}{7} = 'dummy1'; numlds{3}{7} = 4;
%     fingerTypes{3}{8} = 'dummy1'; numlds{3}{8} = 4;
%     
%     fingerTypes{4}{1} = 'dummy1'; numlds{4}{1} = 4;
%     fingerTypes{4}{2} = 'dummy1'; numlds{4}{2} = 4;
%     fingerTypes{4}{3} = 'dummy1'; numlds{4}{3} = 4;
%     fingerTypes{4}{4} = 'dummy1'; numlds{4}{4} = 4;
%     fingerTypes{4}{5} = 'dummy1'; numlds{4}{5} = 4;
%     fingerTypes{4}{6} = 'dummy1'; numlds{4}{6} = 4;
%     fingerTypes{4}{7} = 'dummy1'; numlds{4}{7} = 4;
%     fingerTypes{4}{8} = 'dummy1'; numlds{4}{8} = 4;
%     
%     fingerTypes{5}{1} = 'dummy1'; numlds{5}{1} = 4;
%     fingerTypes{5}{2} = 'dummy1'; numlds{5}{2} = 4;
%     fingerTypes{5}{3} = 'dummy1'; numlds{5}{3} = 4;
%     fingerTypes{5}{4} = 'dummy1'; numlds{5}{4} = 4;
%     fingerTypes{5}{5} = 'dummy1'; numlds{5}{5} = 4;
%     fingerTypes{5}{6} = 'dummy1'; numlds{5}{6} = 4;
%     fingerTypes{5}{7} = 'dummy1'; numlds{5}{7} = 4;
%     fingerTypes{5}{8} = 'dummy1'; numlds{5}{8} = 4;
%     
%     fingerTypes{6}{1} = 'dummy1'; numlds{6}{1} = 4;
%     fingerTypes{6}{2} = 'dummy1'; numlds{6}{2} = 4;
%     fingerTypes{6}{3} = 'dummy1'; numlds{6}{3} = 4;
%     fingerTypes{6}{4} = 'dummy1'; numlds{6}{4} = 4;
%     fingerTypes{6}{5} = 'dummy1'; numlds{6}{5} = 4;
%     fingerTypes{6}{6} = 'dummy1'; numlds{6}{6} = 4;
%     fingerTypes{6}{7} = 'dummy1'; numlds{6}{7} = 4;
%     fingerTypes{6}{8} = 'dummy1'; numlds{6}{8} = 4;
    
elseif strcmp(wiredata, 'auto')
    for D = 1:DD
        numWrs = size(die{D}.wrs, 1);
        die{D}.('fingerTypes') = cell(1, numWrs);
        for w = 1:numWrs
            die{D}.fingerTypes{w} = 'dummy';
        end
    end
else
    error('wiredata should either be auto or manual')
end