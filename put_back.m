function output = put_back(input,index)
    a = 1;
    b = 1;
    for i=1:length(input)+length(index)
        if i==index(a)
            output(i) = 0;
            a = a + 1;
            if a>length(index)
                a = length(index);
            end
        else
            output(i) = input(b);
            b = b + 1;
            if b>length(input)
                b = length(input);
            end
        end
    end
end