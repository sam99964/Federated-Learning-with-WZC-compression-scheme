function stop_2 = VND_constraint_LDPC(VNDEdgeLayer2)

    global Frac_N_VND
    global Dvi
    global N_VND

    id = 1;
    remain_node = Frac_N_VND(id);
    edge_index = 1;
    VND_num = 0;

    for i=1:N_VND
        if remain_node == 0
            id = id + 1;
            remain_node = Frac_N_VND(id);
        end
        if VNDEdgeLayer2(edge_index) > 0
            sign_1st = 1;
        else
            sign_1st = 0;
        end
        for j=2:Dvi(id)
            if VNDEdgeLayer2(edge_index + j -1) > 0
                sign_now = 1;
            else
                sign_now = 0;
            end
            if sign_1st ~= sign_now
                VND_num = VND_num + 1;
                break;
            end
        end
        remain_node = remain_node - 1;
        edge_index = edge_index + Dvi(id);
    end
    stop_2 = VND_num;
end
