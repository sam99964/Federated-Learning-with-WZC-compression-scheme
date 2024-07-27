function u_probi = f_z_i_to_u_i(quantization_error)
       
    global source_len
    global PAM
    global LDGM_point
    global Az
    global sigma_ep_LDGM
    
    u_probi = zeros(source_len,2);
    for i=1:source_len
        sum = 0;
        for j=1:PAM
            amp = j * 2 - 3;
            test = quantization_error(i) - amp * LDGM_point;
            out = ModA(test,Az);
            temp = exp(-0.5 / sigma_ep_LDGM * out^2);
            u_probi(i,j) = temp;
            sum = sum + temp;
        end
        for k=1:PAM
            u_probi(i,k) = u_probi(i,k) / sum;
        end
    end
end