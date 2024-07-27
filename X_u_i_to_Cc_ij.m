function c_ij_L = X_u_i_to_Cc_ij(u_probi_Cc, Cc_X_probi_0)
    % caculate the left hand side of the gray mapping
    global source_len
    global N_VND
    c_ij_L = zeros(N_VND,1);
    for i=1:source_len
        for j=1:2
            prob_0 = 0;
            prob_1 = 0;
            switch j
                case 1
                    index = i;
                    index_L = i+source_len;
                    prob_0 = prob_0 + u_probi_Cc(i,1) * Cc_X_probi_0(index_L) + u_probi_Cc(i,4)*(1-Cc_X_probi_0(index_L));
                    prob_1 = prob_1 + u_probi_Cc(i,2) * Cc_X_probi_0(index_L) + u_probi_Cc(i,3)*(1-Cc_X_probi_0(index_L));
                case 2  
                    index = i + source_len;
                    index_R = i;
                    prob_0 = prob_0 + u_probi_Cc(i,1) * Cc_X_probi_0(index_R) + u_probi_Cc(i,2) * (1 - Cc_X_probi_0(index_R));
				    prob_1 = prob_1 + u_probi_Cc(i,3) * (1 - Cc_X_probi_0(index_R)) + u_probi_Cc(i,4) * Cc_X_probi_0(index_R);
        
            end
            prob_0 = prob_0 / (prob_0 + prob_1);
            prob_1 = 1 - prob_0;
            c_ij_L(index) = log(prob_1)-log(prob_0);

        end
    end
end