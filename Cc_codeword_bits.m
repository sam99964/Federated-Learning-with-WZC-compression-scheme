function Cc_word_bits = Cc_codeword_bits(L_Ccu_Xu)

    global source_len

    buffer = zeros(2,1);
    Cc_word_bits = zeros(source_len,1);

    for i=1:source_len
        for j=1:2
            if j==1
                index = i;
            else
                index = i + source_len;
            end
            if L_Ccu_Xu(index) >= 0
                buffer(j) = 1;
            else
                buffer(j) = 0;
            end
        end
        amp = PAM_transform(buffer);
        Cc_word_bits(i) = amp;
    end

end