function C2_codeword = Cq_codeword_bits_BPSK(L_Cqu_Xu)
    
    global N_CND_Cq
    global LDGM_point
    
    C2_codeword = zeros(N_CND_Cq,1);
    
    for i=1:N_CND_Cq
        if L_Cqu_Xu(i)>0
           amp = 1;
        elseif L_Cqu_Xu(i)<0
           amp = -1;
        end
        C2_codeword(i) = amp * LDGM_point;
    end
end