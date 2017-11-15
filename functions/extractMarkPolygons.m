function die = extractMarkPolygons(die, exactPathofGdsBundle, gdsFileNameToGenerate)

DD = length(die);
kaka = gds_load(exactPathofGdsBundle);

for D = 1:DD    
    figNum = getFigureNumber() + 100*D;
    figure(figNum);clf;
    set(gcf, 'position', [-1250 50 1000 900]);

    pipi = gds_flat_structure(kaka.structures, sprintf('die_%d', D));

    marks = [];
    marks = pipi.plgs([pipi.plgs.layer] == 23); % tunnel probe
    marks = [marks pipi.plgs([pipi.plgs.layer] == 24)]; % superconducting contacts
    marks = [marks pipi.plgs([pipi.plgs.layer] == 25)]; % normal contacts
    marks = [marks pipi.plgs([pipi.plgs.layer] == 26)]; % etch
    marks = [marks pipi.plgs([pipi.plgs.layer] == 27)]; % gate
    
    nn = length(marks);
    markCenter = zeros(nn, 2);
    for ii = 1:nn
        markCenter(ii,:) = mean(marks(ii).points, 2)'/1000;
        plot(markCenter(ii, 1), markCenter(ii, 2),'r.');hold on;
    end
    
    numWrs = size(die{D}.wrs, 1);
    die{D}.('marks') = cell(numWrs, 1);
    for kk = 1:numWrs
        center = die{D}.wrs(kk, :);
        plot(die{D}.edge{kk}(:, 1), die{D}.edge{kk}(:, 2), 'g-');hold on;
        plot(center(1), center(2), 'r.', 'markerSize',10);hold on;
        dists = sqrt(sum((repmat(center, [nn, 1]) - markCenter).^2, 2));
        marksSorted = sortFingersForOneWire(center, marks(dists < 25));
        
        die{D}.marks{kk} = cell(length(marksSorted), 1);
        for hh = 1:length(marksSorted)
            die{D}.marks{kk}{hh} = marksSorted(hh);
            die{D}.marks{kk}{hh}.layer = die{D}.marks{kk}{hh}.layer - 20;
            plot(die{D}.marks{kk}{hh}.points(1, :)/1000, die{D}.marks{kk}{hh}.points(2, :)/1000, 'r-');hold on;
        end
    end
    P = translateCoordinates(D);
    xlim(P(1)+[-500 500]);
    ylim(P(2)+[-500 500]);
    axis square;
    title(sprintf('die %d', D));
end

gdsFile = gds_create_library(gdsFileNameToGenerate);
gds_start_structure(gdsFile, 'Extraction');
gds_write_boundaries(gdsFile, applyTransform(pipi.plgs(find([pipi.plgs.layer] == 23)), trScale(0.001)));
gds_write_boundaries(gdsFile, applyTransform(pipi.plgs(find([pipi.plgs.layer] == 24)), trScale(0.001)));
gds_write_boundaries(gdsFile, applyTransform(pipi.plgs(find([pipi.plgs.layer] == 25)), trScale(0.001)));
gds_write_boundaries(gdsFile, applyTransform(pipi.plgs(find([pipi.plgs.layer] == 26)), trScale(0.001)));
gds_write_boundaries(gdsFile, applyTransform(pipi.plgs(find([pipi.plgs.layer] == 27)), trScale(0.001)));
gds_close_structure(gdsFile);
gds_close_library(gdsFile);

