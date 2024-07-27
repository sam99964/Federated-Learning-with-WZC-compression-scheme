function dither = Generate_trigger(data, A)
    len = length(data);
    dither = unifrnd(-A, A, [len, 1]);
end