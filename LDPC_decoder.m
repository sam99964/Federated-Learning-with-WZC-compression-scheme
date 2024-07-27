function decode_codeword = LDPC_decoder(w_vector)
    
    global N_VND
    global TotalEdge
    global source_len
    global LDPC_point

    round = 1;
    VNDEdgeLayer2 = zeros(TotalEdge,1);      % interleaver to store LLR from VND2CND
    L_Ccu_Xu = zeros(N_VND,1);
    [LDPC_VND2CND, LDPC_CND2VND, ~] = Initialization_LDPC();
    
    while round<=1000
        Cc_X_probi_0 = Cc_ij_to_X_u_i(L_Ccu_Xu);
        if round == 1
            u_probi_Cc = f_z_i_to_u_i_decoder(w_vector);
        end
        Cc_ij_L = X_u_i_to_Cc_ij(u_probi_Cc,Cc_X_probi_0);

        CNDEdgeLayer2 = VND_pure_BP2CND_LDPC(VNDEdgeLayer2,LDPC_VND2CND,Cc_ij_L);
        stop_1 = CND_constraint_LDPC(CNDEdgeLayer2);

        VNDEdgeLayer2 = CNDBP2VND_LDPC(CNDEdgeLayer2,LDPC_CND2VND);
        stop_2 = VND_constraint_LDPC(VNDEdgeLayer2);

        L_Ccu_Xu = VND_to_Ccij(VNDEdgeLayer2);
        
        if stop_1 == 0 && stop_2 == 0
            disp("LDPC success decode")
            break;
        end
        round = round + 1; 
    end

    decode = Cc_codeword_bits(L_Ccu_Xu);
%     write(decode,12)
    decode_codeword = decode * LDPC_point;        
end