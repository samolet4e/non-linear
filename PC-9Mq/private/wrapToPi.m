function [y] = wrapToPi(u1)

%https://stackoverflow.com/questions/27093704/converge-values-to-range-pi-pi-in-matlab-not-using-wraptopi
    t = u1 - 2.*pi*floor((u1+pi)/(2*pi));
    y = t;

endfunction

