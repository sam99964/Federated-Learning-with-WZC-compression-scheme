function Cc_X_probi_0 = Cc_ij_to_X_u_i(L_Ccu_Xu)
    
    % Cc_ij_to_X_u_i use L_Ccu_Xu(each iteration's output LLR) to calculate
    % the P(ci=0)

    global N_VND
    Cc_X_probi_0 = zeros(N_VND,1);
    for i=1:N_VND
        Cc_X_probi_0(i) = 1 / (exp(L_Ccu_Xu(i)) + 1);
    end
end

