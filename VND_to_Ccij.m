function L_Ccu_Xu = VND_to_Ccij(VNDEdgeLayer2)

    global Frac_N_VND
    global N_VND
    global Dvi
    global Dv

    node_index = 1;
    edge_index = 1;
    id = 1;
    r_Frac_N_VND = Frac_N_VND(id);
    L_Ccu_Xu = zeros(N_VND,1);

    while node_index <= N_VND
        if r_Frac_N_VND == 0 && id ~= Dv
            id = id + 1;
            r_Frac_N_VND = Frac_N_VND(id);
        end
        Out_LLR_k = VNDEdgeLayer2(edge_index);
        for i=1:(Dvi(id)-1)
            Out_LLR_k = Out_LLR_k + VNDEdgeLayer2(edge_index + i);
        end
        L_Ccu_Xu(node_index) = Out_LLR_k;
        edge_index = edge_index + Dvi(id);
        node_index = node_index + 1;
        r_Frac_N_VND = r_Frac_N_VND - 1;
    end

end