function output = hard_decision(LDPC_decode,sysbit)
    
    global system_bits
    global hard_value
    global N_VND
    
    output = zeros(N_VND, 1);
    for i=1:system_bits
        if LDPC_decode(sysbit(i)+1) >= 0
            output(sysbit(i)+1) = hard_value;
        else
            output(sysbit(i)+1) = -hard_value;
        end
    end
end