function output = only_LDPC(gradient)
    
    global Az
    global LDPC_point

    
%     Oz = max(max(gradient), -min(gradient));
%     O = Oz/4;
    dither = Generate_Dither(gradient,Az);
    a =  gradient + dither; 
    T = a(:,1);
    uniform_output = ModA(T, Az);
    [~ ,Cc_word_bits] = LDPC_Quantizer(uniform_output);
    
    decode_codeword = Cc_word_bits * LDPC_point ;
    output = decode_codeword - dither;

    
    output = ModA(output,Az);
end