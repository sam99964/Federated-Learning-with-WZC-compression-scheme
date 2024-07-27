function Cq_X_probi_0 = Cq_ij_to_X_u_i(L_Cqu_Xu)
    global N_CND_Cq
    Cq_X_probi_0 = zeros(N_CND_Cq,1);
    for i=1:N_CND_Cq
        Cq_X_probi_0(i) = 1 / (exp(L_Cqu_Xu(i)) + 1);
    end
end