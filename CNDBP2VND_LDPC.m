function VNDEdgeLayer2 = CNDBP2VND_LDPC(CNDEdgeLayer2, LDPC_CND2VND)

    global Frac_N_CND
    global Dci
    global N_CND
    global dc_tilta_max_Cc
    global Mul_Max
    global TotalEdge
    
    VNDEdgeLayer2 = zeros(TotalEdge,1);
    r_CNDnow = Frac_N_CND;
    dc = Dci;
    node_index = 1;
    edge_index = 1;
    
    while node_index <= N_CND
        buffer = zeros(dc_tilta_max_Cc, 1);
        if r_CNDnow == 0
            r_CNDnow = Frac_N_CND;
        end
        mul_all = 1;
        for i=1:dc
            temp = tanh(-CNDEdgeLayer2(edge_index + i-1)/2);
            buffer(i) = temp;
            mul_all = mul_all * temp;
        end
        for j=1:dc
            Mul = mul_all/buffer(j);
            if (abs(Mul) > 1 || isnan(Mul) || buffer(j) == 0)
                Mul = 1;
                for k=1:dc
                    if k ~= j
                        Mul = Mul*buffer(k);
                    end
                end
            end
            if (1 - Mul) < (1 + Mul) && Mul >= Mul_Max
                Mul = Mul_Max;
            elseif (1 - Mul) > (1 + Mul) && Mul <= -Mul_Max
                Mul = -Mul_Max;
            end
            L_value= log((1 - Mul) / (1 + Mul));
            VNDEdgeLayer2(LDPC_CND2VND(edge_index+j-1)+1) = L_value;
        end
        r_CNDnow = r_CNDnow - 1;
        edge_index = edge_index + dc;
        node_index = node_index + 1;
    end
end


