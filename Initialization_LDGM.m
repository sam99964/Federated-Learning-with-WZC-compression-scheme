function  [LDGM_VND2CND, LDGM_CND2VND] = Initialization_LDGM()
    LDGM_VND2CND = importdata('.\input\Cq_intlv.txt');
    LDGM_CND2VND = importdata('.\input\Cq_Deintlv.txt');
end