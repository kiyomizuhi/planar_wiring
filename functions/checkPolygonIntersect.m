function flag = checkPolygonIntersect(plg1, plg2)
flag = 0;

for i = 1:(length(plg1)-1)
    for j = 1:(length(plg2)-1)
        flag = flag + checkSegmentsIntersect(plg1(i,:), plg1(i+1,:), plg2(j, :), plg2(j+1, :));
        if flag > 0
            break;
        end
    end
    if flag > 0
        break;
    end
end
