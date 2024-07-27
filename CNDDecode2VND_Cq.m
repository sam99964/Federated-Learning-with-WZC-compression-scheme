function Cq_VNDEdgeLayer = CNDDecode2VND_Cq(Cq_CNDEdgeLayer, Cq_ij_L, LDGM_CND2VND)
    global Frac_N_CND_Cq
    global Dci_Cq
    global N_CND_Cq
    global Mul_Max
    global Total_edge_Cq

    r_CNDnow = Frac_N_CND_Cq(1);
    id = 1;
    dc = Dci_Cq(1);
    edge_index = 1;
    node_index = 1;
    buffer = zeros(71,1);
    Cq_VNDEdgeLayer = zeros(Total_edge_Cq,1);

    while node_index <= N_CND_Cq
        if r_CNDnow == 0
            id = id + 1;
            r_CNDnow = Frac_N_CND_Cq(id);
            dc = Dci_Cq(id);
        end
        mull_all = 1;
        for i=1:dc
            temp = tanh(-Cq_CNDEdgeLayer(edge_index+i-1)/2);
            buffer(i) = temp;
            mull_all = mull_all * temp;
        end
        temp = tanh(-Cq_ij_L(node_index)/2);
        buffer(i+1) = temp;
        mull_all = mull_all * temp;
        for k=1:dc
            Mul = mull_all / buffer(k);
            if abs(Mul) > 1 || isnan(Mul) || buffer(k) == 0
                Mul = buffer(i+1);
                for j=1:dc
                    if j~=k
                        Mul = Mul * buffer(j);
                    end
                end
            end
            if (1-Mul)<(1+Mul) && Mul>=Mul_Max
                Mul = Mul_Max;
            elseif (1-Mul)>(1+Mul) && Mul<=-Mul_Max
                Mul = -Mul_Max;
            end
            L_value = log((1-Mul)/(1+Mul));
            Cq_VNDEdgeLayer(LDGM_CND2VND(edge_index+k-1)+1) = L_value;
        end
        r_CNDnow = r_CNDnow - 1;
        edge_index = edge_index +dc;
        node_index = node_index+1;
    end
end