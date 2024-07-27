function [CNDEdgeLayer2, LDPC_decode] = VNDBP2CND_LDPC(VNDEdgeLayer2, LDPC_VND2CND, Cc_ij_L, round, g0_now, g1_now,pre_LDPC_decode)
    
    global Dvi
    global Frac_N_VND
    global N_VND
    global Dv
    global TotalEdge

    CNDEdgeLayer2 = zeros(TotalEdge,1);
    LDPC_decode = zeros(N_VND,1);
    node_index = 1;
    edge_index = 1;
    id = 1;
    r_Frac_N_VND = Frac_N_VND(id);
    gaga = 1 - g0_now * (g1_now ^ round);
    while node_index <= N_VND
        if r_Frac_N_VND == 0 && id ~= Dv
            id = id + 1;
            r_Frac_N_VND = Frac_N_VND(id);
        end

        Out_LLR_k = VNDEdgeLayer2(edge_index);


        for i=2:Dvi(id)
            Out_LLR_k = Out_LLR_k + VNDEdgeLayer2(edge_index+i-1);
        end

        Out_LLR_k = Out_LLR_k + Cc_ij_L(node_index);

        if round == 1
            LDPC_decode(node_index) = Out_LLR_k;
        else
            pre_margin = pre_LDPC_decode(node_index);
            Out_LLR_k = Out_LLR_k + gaga * pre_margin;
            LDPC_decode(node_index) = Out_LLR_k;
        end

        for i=1:Dvi(id)
            CNDEdgeLayer2(LDPC_VND2CND(edge_index+i-1)+1) = Out_LLR_k - VNDEdgeLayer2(edge_index+i-1);
        end

        edge_index = edge_index + Dvi(id);
        node_index = node_index + 1;
        r_Frac_N_VND = r_Frac_N_VND - 1;
    end
end