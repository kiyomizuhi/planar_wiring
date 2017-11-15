function frame = generateFrameCorners(frameNodes)

xmax = max(frameNodes(:,1));
xmin = min(frameNodes(:,1));
ymax = max(frameNodes(:,2));
ymin = min(frameNodes(:,2));
frame = [xmin ymax; xmax ymax; xmax ymin; xmin ymin; xmin ymax];