classdef nodeClass
    properties
        id
        visit
        path
        nbr
        lvl
    end
%     properties (Dependent)
%         dist
%     end
    methods
        function obj = node(id, visit, path, nbr, lvl)
            if nargin == 0
                obj.id = 0;
                obj.visit = 0;
                obj.path = [];
                obj.nbr = [];
                obj.lvl = 2^32;
            else
                obj.id = id;
                obj.visit = visit;
                obj.path = path;
                obj.nbr = nbr;
                obj.lvl = lvl;
            end
        end
%         function dist = get.dist(obj)
%             if ~isempty(obj.path)
%                 dist = length(obj.path);
%             else
%                 dist = 2^32;
%             end
%         end
    end
end