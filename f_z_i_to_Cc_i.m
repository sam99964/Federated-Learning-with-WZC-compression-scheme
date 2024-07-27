function u_probi_Cc = f_z_i_to_Cc_i(source)
    
    % gray mapping calculate p(u=-3A) p(u=-A) p(u=A) p(u=3A)
    global source_len
    global LDPC_point
    global Az
    global sigma_ep_LDPC
    u_probi_Cc = zeros(source_len,4);
    for i=1:source_len
        sum = 0;
        for j=1:4
            amp = j * 2 - 5;
            test = source(i) - amp * LDPC_point;
            output = ModA(test,Az);
            temp = exp(-0.5 / sigma_ep_LDPC * (output^2));
            u_probi_Cc(i,j) = temp;
            sum = sum + temp;
        end
        for k=1:4
            u_probi_Cc(i,k) = u_probi_Cc(i,k) / sum;
        end
    end

end