function die = placeFingers(die, gdsfl)

DD = length(die);
for D = 1:DD
    gdsFile = gds_library_append(gdsfl);
    gds_start_structure(gdsFile, sprintf('die_%d', D));
    for i = 1:size(die{D}.wrs, 1)
        pc = die{D}.wrs(i, :);
        pe = die{D}.edge{i};
        theta_rad = atan((pe(2, 2)-pe(1, 2))/(pe(2, 1)-pe(1, 1)));
        if theta_rad < 0
            theta_rad = theta_rad + 2*pi;
        end
        theta_deg = 180*theta_rad/pi;
        gds_write_sref(gdsFile, die{D}.fingerTypes{i}, 'refPoint', pc', 'angle', theta_deg);
    end
    gds_close_structure(gdsFile);
    gds_close_library(gdsFile);
end