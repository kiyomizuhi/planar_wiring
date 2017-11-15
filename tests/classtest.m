classdef classtest
    properties
        value
        prev
        next
    end
    properties (GetAccess=private)
        cubic
    end
    properties (GetAccess=public)
        quatro
    end
    properties (Constant)
        c = 3e8
    end
    properties (Dependent)
        squared
    end
    methods
        function obj = node(value, prev, next, cubic)
            if nargin == 0
                obj.value = 1;
                obj.prev = 1;
                obj.next = 1;
                obj.cubic = 1;
            else
                obj.value = value;
                obj.prev = prev;
                obj.next = next;
                obj.cubic = cubic;
            end
        end
        function zerros = generateZeros(obj)
            zerros = zeros(obj.next);
        end
        function squared = get.squared(obj)
            squared = obj.value^2;
        end
        function printCubic(obj)
            fprintf('%d\n', obj.cubic)
        end
    end
end