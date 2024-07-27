function [Cq_CNDEdgeLayer, LDGM_decode] = VNDDecode_Cq(Cq_VNDEdgeLayer, LDGM_VND2CND, round_Cq, pre_LDGM_decode)
    
    global N_VND_Cq
    global Frac_N_VND_Cq
    global Dvi_Cq
    global Total_edge_Cq

    node_index = 1;
    edge_index = 1;
    id = 1;
    r_Frac_N_VND = Frac_N_VND_Cq;
    gaga = 1-0.9998^round_Cq;
    LDGM_decode = zeros(N_VND_Cq,1);
    Cq_CNDEdgeLayer = zeros(Total_edge_Cq,1);
    
    while node_index <= N_VND_Cq
        if r_Frac_N_VND == 0 
            r_Frac_N_VND = Frac_N_VND_Cq(id);
        end

        Out_LLR_k = Cq_VNDEdgeLayer(edge_index);

        for i=2:Dvi_Cq
            Out_LLR_k = Out_LLR_k + Cq_VNDEdgeLayer(edge_index+i-1);
        end
        if round_Cq == 1
            LDGM_decode(node_index) = Out_LLR_k;
        else
            VND_L_pre = pre_LDGM_decode(node_index);
            Out_LLR_k = Out_LLR_k + gaga * VND_L_pre;
            LDGM_decode(node_index) = Out_LLR_k;
        end
        for j=1:Dvi_Cq
            Cq_CNDEdgeLayer(LDGM_VND2CND(edge_index+j-1)+1) = Out_LLR_k - Cq_VNDEdgeLayer(edge_index+j-1);
        end
        edge_index = edge_index + Dvi_Cq;
        node_index = node_index + 1;
        r_Frac_N_VND = r_Frac_N_VND - 1;
    end
end