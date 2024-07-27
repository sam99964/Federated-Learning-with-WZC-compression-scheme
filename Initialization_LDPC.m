function  [LDPC_VND2CND, LDPC_CND2VND, sysbit] = Initialization_LDPC()
    LDPC_VND2CND = importdata('.\input\LDPC_VND2CND.txt');
    LDPC_CND2VND = importdata('.\input\LDPC_CND2VND.txt');
    sysbit = importdata('.\input\systematic_bit_indx.txt');
end