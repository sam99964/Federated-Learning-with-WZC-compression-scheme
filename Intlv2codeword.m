function L_Cqu_Xu = Intlv2codeword(EdgeLayer)

    global Frac_N_CND_Cq
    global N_CND_Cq
    global Dci_Cq
    
    node_index = 1;
    edge_index = 1;
    id = 1;
    r_CNDnow = Frac_N_CND_Cq(id);
    dc = Dci_Cq(id);
    L_Cqu_Xu = zeros(N_CND_Cq,1);

    while node_index <= N_CND_Cq
        if r_CNDnow == 0
            id = id + 1;
            r_CNDnow = Frac_N_CND_Cq(id);
            dc = Dci_Cq(id);
        end
        XOR = 0;
        for i=1:dc
            if EdgeLayer(edge_index+i-1)>0
                temp = 1;
            else
                temp = 0;
            end
            XOR = xor(XOR, temp);
        end
        if XOR == 1
            L_Cqu_Xu(node_index) = 10;
        elseif XOR == 0
            L_Cqu_Xu(node_index) = -10;
        end
        edge_index = edge_index + dc;
        node_index = node_index + 1;
        r_CNDnow = r_CNDnow - 1;
    end
end