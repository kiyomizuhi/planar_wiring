function isInt = checkSegmentsIntersect(p1, p2, q1, q2)
% refer to 
% http://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
% for the details of this algorithm

ort1 = orientation(p1, p2, q1);
ort2 = orientation(p1, p2, q2);
ort3 = orientation(q1, q2, p1);
ort4 = orientation(q1, q2, p2);

if ort1 ~= ort2 && ort3 ~= ort4
    isInt = true;

elseif ort1 == 0 && onSegment(p1, p2, q1)
    isInt = true;
    
elseif ort2 == 0 && onSegment(p1, p2, q2)
    isInt = true;
    
elseif ort3 == 0 && onSegment(q1, q2, p1)
    isInt = true;
    
elseif ort4 == 0 && onSegment(q1, q2, p2)
    isInt = true;

else
    isInt = false;
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To find orientation of ordered triplet (p, q, r).
% The function returns following values
%  0 --> p, q and r are colinear
%  1 --> Clockwise
% -1 --> Counterclockwise

function ort = orientation(p, q, r)

ort = sign((q(1)-p(1))*(r(2)-q(2)) - (r(1)-q(1))*(q(2)-p(2)));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Given three colinear points p, q, r, the function checks if
% point q lies on line segment 'pr'

function isSeg = onSegment(p, q, r)

if q(1) > min(p(1), r(1)) && q(1) < max(p(1), r(1)) && ...
   q(2) > min(p(2), r(2)) && q(2) < max(p(2), r(2))
    isSeg = true;
    
else
    isSeg = false;
    
end