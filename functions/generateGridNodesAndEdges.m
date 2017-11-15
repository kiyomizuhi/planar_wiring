function [grid, edges] = generateGridNodesAndEdges(rangex, rangey, latticeConst)

m = round(rangex/latticeConst);
n = round(rangey/latticeConst);

x = m(1):1:m(2);
y = n(1):1:n(2);

Nx = length(x);
Ny = length(y);

[xv, yv] = meshgrid(x, y);
xx = xv(:)';
yy = yv(:)';
grid = latticeConst*[xx; yy]';

NN = 4*(Nx-2)*(Ny-2) + 3*2*(Nx-2) + 3*2*(Ny-2) + 4*2;
edges = zeros(NN, 2);
k = 1;
for i = 1:size(xx, 2)
    xmin = xx(1);
    xmax = xx(end);
    ymin = yy(1);
    ymax = yy(end);
    if xx(i) > xmin & xx(i) < xmax & yy(i) > ymin & yy(i) < ymax
        edges(k, :)   = [i i - Ny];
        edges(k+1, :) = [i i + Ny    ];
        edges(k+2, :) = [i i + 1     ];
        edges(k+3, :) = [i i - 1     ];
        edges(k+4, :) = [i i + Ny + 1];
        edges(k+5, :) = [i i + Ny - 1];
        edges(k+6, :) = [i i - Ny + 1];
        edges(k+7, :) = [i i - Ny - 1];
        k = k + 8;
    elseif xx(i) > xmin & xx(i) < xmax & yy(i) == ymin
        edges(k, :)   = [i i - Ny    ];
        edges(k+1, :) = [i i + Ny    ];
        edges(k+2, :) = [i i + 1     ];
        edges(k+3, :) = [i i - Ny + 1];
        edges(k+4, :) = [i i + Ny + 1];
        k = k + 5;
    elseif xx(i) > xmin & xx(i) < xmax & yy(i) == ymax
        edges(k, :)   = [i i - Ny    ];
        edges(k+1, :) = [i i + Ny    ];
        edges(k+2, :) = [i i - 1     ];
        edges(k+3, :) = [i i - Ny - 1];
        edges(k+4, :) = [i i + Ny - 1];
        k = k + 5;
    elseif xx(i) == xmin & yy(i) > ymin & yy(i) < ymax
        edges(k, :)   = [i i + Ny    ];
        edges(k+1, :) = [i i + 1     ];
        edges(k+2, :) = [i i - 1     ];
        edges(k+3, :) = [i i + Ny + 1];
        edges(k+4, :) = [i i + Ny - 1];
        k = k + 5;
    elseif xx(i) == xmin & yy(i) == ymin
        edges(k, :)   = [i i + Ny];
        edges(k+1, :) = [i i + 1];
        edges(k+2, :) = [i i + Ny + 1];
        k = k + 3;
    elseif xx(i) == xmin & yy(i) == ymax
        edges(k, :)   = [i i + Ny];
        edges(k+1, :) = [i i - 1];
        edges(k+2, :) = [i i + Ny - 1];
        k = k + 3;
    elseif xx(i) == xmax & yy(i) > ymin & yy(i) < ymax
        edges(k, :)   = [i i - Ny    ];
        edges(k+1, :) = [i i + 1     ];
        edges(k+2, :) = [i i - 1     ];
        edges(k+3, :) = [i i - Ny + 1];
        edges(k+4, :) = [i i - Ny - 1];
        k = k + 5;
    elseif xx(i) == xmax & yy(i) == ymin
        edges(k, :)   = [i i - Ny];
        edges(k+1, :) = [i i + 1];
        edges(k+2, :) = [i i - Ny + 1];
        k = k + 3;
    elseif xx(i) == xmax & yy(i) == ymax
        edges(k, :) = [i i - Ny];
        edges(k+1, :) = [i i - 1];
        edges(k+2, :) = [i i - Ny - 1];
        k = k + 3;
    end
end