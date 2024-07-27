function CNDEdgeLayer2 = VND_pure_BP2CND_LDPC(VNDEdgeLayer2,LDPC_VND2CND,Cc_ij_L)
    
    global Dvi
    global Frac_N_VND
    global N_VND
    global Dv
    global TotalEdge

    CNDEdgeLayer2 = zeros(TotalEdge,1);
    node_index = 1;
    edge_index = 1;
    id = 1;
    r_Frac_N_VND = Frac_N_VND(id);
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

        for i=1:Dvi(id)
            CNDEdgeLayer2(LDPC_VND2CND(edge_index+i-1)+1) = Out_LLR_k - VNDEdgeLayer2(edge_index+i-1);
        end

        edge_index = edge_index + Dvi(id);
        node_index = node_index + 1;
        r_Frac_N_VND = r_Frac_N_VND - 1;
    end
end
