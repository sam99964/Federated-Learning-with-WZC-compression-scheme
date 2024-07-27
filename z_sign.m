function output = z_sign(input)
    a = length(input);
    output = zeros(length(input),1);
    for i=1:a
        if input(i)>=0
            output(i) = 1;
        else
            output(i) = -1;
        end
    end
end