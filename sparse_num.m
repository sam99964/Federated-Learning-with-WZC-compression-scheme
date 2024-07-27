function [output,index] = sparse_num(input,num)
    input = reshape(input, [], 1);
    len = length(input);
    index = [];
    num = len - num;
    seq = sort(abs(input));
    threshold = seq(num);
    ind = 1;
    for i=1:len
        if abs(input(i))>threshold
            output(ind) = input(i);
            ind = ind + 1;
        else
            index = [index, i];
        end
    end    
end