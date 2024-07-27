function EdgeLayer = Info2Intlv(LDGM_VND2CND,LDGM_decode)
    
    global N_VND_Cq
    global Frac_N_VND_Cq
    global Total_edge_Cq
    global Dvi_Cq

    node_index = 1;
    edge_index = 1;
    r_Frac_N_VND = Frac_N_VND_Cq;
    EdgeLayer = zeros(Total_edge_Cq,1);

    while node_index<=N_VND_Cq
        if r_Frac_N_VND == 0
            r_Frac_N_VND = Frac_N_VND_Cq;
        end
        for i=1:Dvi_Cq
            EdgeLayer(LDGM_VND2CND(edge_index+i-1)+1) = LDGM_decode(node_index);
        end
        edge_index = edge_index + Dvi_Cq;
        node_index = node_index + 1;
        r_Frac_N_VND = r_Frac_N_VND - 1;
    end
end