function C2_codeword = LDGM_Quantizer(quantization_error)
    
    global N_VND_Cq
    global Total_edge_Cq
    global source_len
    round_Cq = 1;
    Max_Iteration_Cq = 2000;
    Cq_CNDEdgeLayer = Generate_trigger(zeros(Total_edge_Cq,1), 2);
    
%     Cq_CNDEdgeLayer = importdata("C:\Users\sam01\Desktop\test LDGM result data\test trigger.txt");

    pre_LDGM_decode = zeros(N_VND_Cq,1);
    [LDGM_VND2CND, LDGM_CND2VND] = Initialization_LDGM();

    while round_Cq <= Max_Iteration_Cq    
        if round_Cq == 1
            u_probi = f_z_i_to_u_i(quantization_error); 
            Cq_ij_L = u_i_to_CND(u_probi);   
        end
        Cq_VNDEdgeLayer = CNDDecode2VND_Cq(Cq_CNDEdgeLayer, Cq_ij_L, LDGM_CND2VND);

        [Cq_CNDEdgeLayer, LDGM_decode]= VNDDecode_Cq(Cq_VNDEdgeLayer, LDGM_VND2CND, round_Cq, pre_LDGM_decode);
        pre_LDGM_decode = LDGM_decode;
        round_Cq = round_Cq + 1;
    end
    EdgeLayer = Info2Intlv(LDGM_VND2CND, LDGM_decode);        % Do VND encoding calculation, repetition
    L_Cqu_Xu = Intlv2codeword(EdgeLayer);  % Do CND encoding calculation, parity calculation
    C2_codeword = Cq_codeword_bits_BPSK(L_Cqu_Xu);

%     sum = 0;
    error = zeros(source_len, 1);
    for i=1:source_len
        error(i) = quantization_error(i) - C2_codeword(i);
%         sum = sum + error(i)^2;
    end
%     mse = sum / source_len;
%     disp("LDGM MSE")
%     disp(mse)
    disp(var(error))
%     write(C2_codeword,9);
end