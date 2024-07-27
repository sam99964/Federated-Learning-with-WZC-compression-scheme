function write(input,num)    
    if num==1
        fileID = fopen('C:\Users\sam01\Desktop\test LDPC result data\test Cc_ij_to_X_u_i matlab.txt','w');
        fprintf(fileID,'%.15f\n',input);
        fclose(fileID);
    elseif num==2
        fileID = fopen('C:\Users\sam01\Desktop\test LDPC result data\test X_u_i_to_Cc_ij matlab.txt','w');
        fprintf(fileID,'%.15f\n',input);
        fclose(fileID);
    elseif num==3
        fileID = fopen('C:\Users\sam01\Desktop\test LDPC result data\test CNDEdgeLayer2 matlab.txt','w');
        fprintf(fileID,'%.15f\n',input);
        fclose(fileID);
    elseif num==4
        fileID = fopen('C:\Users\sam01\Desktop\test LDPC result data\test LDPC_decode matlab.txt','w');
        fprintf(fileID,'%.15f\n',input);
        fclose(fileID);
    elseif num==5
        fileID = fopen('C:\Users\sam01\Desktop\test LDPC result data\test stop1 matlab.txt','w');
        fprintf(fileID,'%d\n',input);
        fclose(fileID);
    elseif num==6
        fileID = fopen('C:\Users\sam01\Desktop\test LDPC result data\test VNDEdgeLayer2 matlab.txt','w');
        fprintf(fileID,'%.15f\n',input);
        fclose(fileID);
    elseif num==7
        fileID = fopen('C:\Users\sam01\Desktop\test LDPC result data\test stop2 matlab.txt','w');
        fprintf(fileID,'%d\n',input);
        fclose(fileID);
    
    elseif num==8
        fileID = fopen('C:\Users\sam01\Desktop\quantizer MSE test\test LDPC codeword matlab.txt','w');
        fprintf(fileID,'%d\n',input);
        fclose(fileID);
    elseif num==9
        fileID = fopen('C:\Users\sam01\Desktop\quantizer MSE test\test LDGM codeword matlab.txt','w');
        fprintf(fileID,'%f\n',input);
        fclose(fileID);
    elseif num==10
        fileID = fopen('C:\Users\sam01\Desktop\test LDGM result data\test trigger.txt','w');
        fprintf(fileID,'%f\n',input);
        fclose(fileID);
    elseif num==11
        fileID = fopen('C:\Users\sam01\Desktop\test LDPC result data\test VND_to_Ccij matlab.txt','w');
        fprintf(fileID,'%.15f\n',input);
        fclose(fileID);
    elseif num==12
        fileID = fopen('C:\Users\sam01\Desktop\quantizer MSE test\test LDPC decode codeword matlab.txt','w');
        fprintf(fileID,'%f\n',input);
        fclose(fileID);
    end
end