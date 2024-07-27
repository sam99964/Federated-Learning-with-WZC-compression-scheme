function output = ModA(data, A)
    output = zeros(numel(data),1);
    for k = 1:numel(data)
        a = data(k);
        if a == 0
            b = 0;
        elseif a > 0
            b = fix(a / (2 * A));
            
            if abs(a - 2 * A * b) > abs(a - 2 * A * (b + 1))
                b = b + 1;
            end
        else
            b = fix(a / (2 * A));
            
            if abs(a - 2 * A * b) > abs(a - 2 * A * (b - 1))
                b = b - 1;
            end
        end
        output(k) = data(k) - b * 2 * A;
    end
end