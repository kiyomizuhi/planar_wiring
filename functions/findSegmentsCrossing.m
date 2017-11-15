function [xc, yc] = findSegmentsCrossing(p1, p2, q1, q2)

if nargin ~= 4
    error('you need to give me coordinates (x, y) of edges of two segments (4 points in total)')
end
    
if length(p1) ~= 2 || length(p2) ~= 2 || length(q1) ~= 2 || length(q2) ~= 2
    error('you need to pass a coordinate of a point as (x, y)')
end

if p1(1) == p2(1) && p1(2) == p2(2)
    error('you need to pass two different points for the first two points')
end

if q1(1) == q2(1) && q1(2) == q2(2)
    error('you need to pass two different points for the last two points')
end

if checkSegmentsIntersect(p1, p2, q1, q2)
    if p1(1) ~= p2(1) && q1(1) ~= q2(1)
        [a, b] = generateLine(p1, p2);
        [c, d] = generateLine(q1, q2);
        xc = (d - b)/(a - c);
        yc = (a*d - b*c)/(a-c);
        
    elseif p1(1) == p2(1) && q1(1) ~= q2(1)
        xc = p1(1);
        [c, d] = generateLine(q1, q2);
        yc = c*xc + d;
        
    elseif p1(1) ~= p2(1) && q1(1) == q2(1)
        xc = q1(1);
        [a, b] = generateLine(p1, p2);
        yc = a*xc + b;
    end
else
    xc = [];
    yc = [];
end

function [a, b] = generateLine(p, q)
a = (p(2)-q(2))/(p(1)-q(1));
b = (p(1)*q(2)-p(2)*q(1))/(p(1)-q(1));



