function stop1 = CND_constraint_LDPC(CNDEdgeLayer2)

    global Frac_N_CND
    global N_CND
    global Dci

    
    remain_node = Frac_N_CND;
    edge_index = 1;
    CND_num= 0;

    for i=1:N_CND
        if remain_node == 0
            remain_node = Frac_N_CND;
        end
        multiple = 1;
        for j=1:Dci
            multiple = multiple * CNDEdgeLayer2(edge_index + j-1);
        end
        if multiple < 0
            CND_num = CND_num + 1;
        end
        remain_node = remain_node - 1;
        edge_index = edge_index + Dci;
    end
    stop1 = CND_num;
end
