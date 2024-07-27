function dither = Generate_Dither(gradient, A)
    len = length(gradient);
    dither = unifrnd(-A, A, [len, 1]);
end