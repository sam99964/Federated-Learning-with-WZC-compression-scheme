function output = sparse_index(input,index)
    
    global source_len

    seq = reshape(input, [], 1);
    a = 1;
    b = 1;
    output = zeros(source_len,1);
    for i=1:length(seq)
        if i == index(a)
            a = a + 1;
            if a > 16906
                a = 16906;
            end
        else
            output(b) = seq(i);
            b = b + 1;
        end
    end
end