function u_probi_Cc = only_f_z_i_to_Cc_i(source)
    
    % gray mapping calculate p(u=-3A) p(u=-A) p(u=A) p(u=3A)
    global source_len
    global O
    global Oz

    global sigma_ep_LDPC
    u_probi_Cc = zeros(100000,4);
    for i=1:source_len
        sum = 0;
        for j=1:4
            amp = j * 2 - 5;
            test = source(i) - amp * O;
            output = ModA(test,Oz);
            temp = exp(-0.5 / (5*10^-3) * (output^2));
            u_probi_Cc(i,j) = temp;
            sum = sum + temp;
        end
        for k=1:4
            u_probi_Cc(i,k) = u_probi_Cc(i,k) / sum;
        end
    end

end