function u_probi_Cc = f_z_i_to_u_i_decoder(w_vector) 
    
    global source_len
    global PAM_Cc
    global LDPC_point
    global sigma_dp_LDPC;
    global Az

    u_probi_Cc = zeros(source_len,PAM_Cc);

    for i=1:source_len
        sum = 0;
        for j=1:PAM_Cc
            amp = j * 2 - 5;
            output = w_vector(i) - amp *  LDPC_point;
            test = ModA(output,Az);
            temp = exp(-0.5/sigma_dp_LDPC*test^2);
            u_probi_Cc(i,j) = temp;
            sum = sum + temp;
        end
        for k=1:PAM_Cc
            u_probi_Cc(i,k) = u_probi_Cc(i,k)/sum;
        end
    end
end