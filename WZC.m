function Decoded_Gradient = WZC(gradient,side_information)

    global Az
    global alpha

    
    %user part
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dither = Generate_Dither(gradient,Az);
    a = alpha * gradient + dither; 

    T = a(:,1);
    uniform_output = ModA(T, Az);

    [mod_quantization_error, ~] = LDPC_Quantizer(uniform_output);    
    C2_codeword = LDGM_Quantizer(mod_quantization_error);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Server Part
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    w_vector = C2_codeword - dither - alpha * side_information;
    w_vector = ModA(w_vector,Az);

    w_vector = -w_vector;

    decode_codeword = LDPC_decoder(w_vector);
    
    v_head = ModA(w_vector - decode_codeword,Az);
   
    v_head = -v_head;

    Decoded_Gradient = v_head + side_information;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end