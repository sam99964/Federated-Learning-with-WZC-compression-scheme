function [C2_codeword, dither] = WZC_Quantizer(gradient) 
    A = 3.33;
    alpha = 0.4612; 
    dither = Generate_Dither(gradient,A);
    a = alpha * gradient + dither;  

     fileID = fopen('.\test data\test20.txt','w');
     fprintf(fileID,'%.15f\n',a);
     fclose(fileID);

%     input = importdata('test8.txt');
    T = a(:,1);
    uniform_output = ModA(T, A/2);
    
    mod_quantization_error = LDPC_Quantizer(uniform_output);
    C2_codeword = LDGM_Quantizer(mod_quantization_error);
end