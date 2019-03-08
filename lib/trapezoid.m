

function y = trapezoid(x, x0, base_width, rise, fall)
%TRAPEZOID Summary of this function goes here
%   Detailed explanation goes here

y = zeros(size(x));

i2 = find(x>(x0-base_width/2-rise) & x<(x0-base_width/2));
i3 = find(x>(x0-base_width/2) & x<(x0+base_width/2));
i4 = find(x>(x0+base_width/2) & x<(x0+base_width/2+fall));

y(i2) = 1/numel(i2)*[1:numel(i2)];
y(i3) = 1;
y(i4) = 1-1/numel(i4)*[1:numel(i4)];

end

