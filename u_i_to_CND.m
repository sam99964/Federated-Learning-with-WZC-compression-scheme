function Cq_ij_L = u_i_to_CND(u_probi)
    
    global N_CND_Cq
    Cq_ij_L = zeros(N_CND_Cq,1);
    for i=1:N_CND_Cq
        Cq_ij_L(i) = log(u_probi(i,2) / u_probi(i,1));
    end
end