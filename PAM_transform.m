function result = PAM_transform(buffer)
    if buffer(2) == 0 && buffer(1) == 0
        result = -3;
    elseif buffer(2) == 0 && buffer(1) == 1
        result = -1;
    elseif buffer(2) == 1 && buffer(1) == 1
        result = 1;
    elseif buffer(2) == 1 && buffer(1) == 0
        result = 3;
    end
end