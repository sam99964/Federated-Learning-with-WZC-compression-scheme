function [quantization_error, Cc_word_bits] = LDPC_Quantizer(input)

    global source_len
    global N_VND;
    global TotalEdge;
    global Az;
    global LDPC_point;

    g_0 = 1;
    g_1 = 0.9998;
    g0_now = g_0;
    gamma_Trial = 15;  
    Max_Iteration = 2000; 
    
    pre_LDPC_decode = zeros(N_VND,1);
    VNDEdgeLayer2 = zeros(TotalEdge,1);      % interleaver to store LLR from VND2CND
    CNDEdgeLayer2 = zeros(TotalEdge,1); % interleaver to store LLR from CND2VND
    L_Ccu_Xu = zeros(N_VND,1);           % each iteration's output LLR 
    [LDPC_VND2CND, LDPC_CND2VND, sysbit] = Initialization_LDPC();      % read the LDPC data

% part 1, 4-ary LDPC quantizer (R=1 b/s)
    for i = 0:gamma_Trial-1
        g1_now = g_1 + 0.00001 * i;       % clculate gamma 1
        Clean(CNDEdgeLayer2, VNDEdgeLayer2, L_Ccu_Xu);      % clean the previous RBP data
        round = 1;
        disp("gamma_Trial") 
        disp(i+1)
        while round < Max_Iteration
            Cc_X_probi_0 = Cc_ij_to_X_u_i(L_Ccu_Xu);  % right hand side p(ci=0) of gray mapping               

            if round == 1
                u_probi_Cc = f_z_i_to_Cc_i(input); %  p(u=A) of gray mapping;
            end
            
            Cc_ij_L = X_u_i_to_Cc_ij(u_probi_Cc, Cc_X_probi_0);  %calculate the LLR after gray mapping            

            [CNDEdgeLayer2,LDPC_decode] = VNDBP2CND_LDPC(VNDEdgeLayer2, LDPC_VND2CND, Cc_ij_L, round, g0_now, g1_now, pre_LDPC_decode);
  
            pre_LDPC_decode = LDPC_decode;
            stop_1 = CND_constraint_LDPC(CNDEdgeLayer2);
        
            VNDEdgeLayer2 = CNDBP2VND_LDPC(CNDEdgeLayer2, LDPC_CND2VND);
           
            stop_2 = VND_constraint_LDPC(VNDEdgeLayer2);         
        
            L_Ccu_Xu = VND_to_Ccij(VNDEdgeLayer2);
%              if round>=300
%                 write(Cc_X_probi_0,1);
%                 write(Cc_ij_L,2);
%                 write(CNDEdgeLayer2,3);
%                 write(LDPC_decode,4);
%                 write(stop_1,5);
%                 write(VNDEdgeLayer2,6);
%                 write(L_Ccu_Xu,11);
%                 write(stop_2,7);
%              end
            
%             if mod(round,100)==0
%                 count = 0;
%                 for y=1:100000
%                     if L_Ccu_Xu(y)<0
%                         count = count+1;
%                     end
%                 end
%                 disp(count)
%                 pause('on');
%             end
            if stop_1 == 0 && stop_2 == 0
                break;
            end
        
            round = round + 1;
        end
    
    if stop_1 == 0 && stop_2 == 0
        Cc_word_bits = Cc_codeword_bits(L_Ccu_Xu);
        break;
    end
    
    if i == gamma_Trial - 1 
        disp("hard")
        hard_margin = hard_decision(LDPC_decode,sysbit); % Implement hard_decision function
        Clean(CNDEdgeLayer2, VNDEdgeLayer2, L_Ccu_Xu);
        pre_LDPC_decode = zeros(N_VND,1);
        round_2 = 1;
        
        while round_2 <= Max_Iteration
            if round_2 == 1
                for xx = 1:N_VND
                    Cc_ij_L(xx) = hard_margin(xx);
                end
            end
            
            [CNDEdgeLayer2, LDPC_decode] = VNDBP2CND_LDPC(VNDEdgeLayer2, LDPC_VND2CND, Cc_ij_L, round_2, g0_now, g1_now, pre_LDPC_decode);
            pre_LDPC_decode = LDPC_decode;
            stop_3 = CND_constraint_LDPC(CNDEdgeLayer2);
            
            VNDEdgeLayer2 = CNDBP2VND_LDPC(CNDEdgeLayer2, LDPC_CND2VND);

            stop_4 = VND_constraint_LDPC(VNDEdgeLayer2);
            
            if stop_3 == 0 && stop_4 == 0
                break;
            end
            
            round_2 = round_2 + 1;
        end

        L_Ccu_Xu = VND_to_Ccij(VNDEdgeLayer2);
        Cc_word_bits = Cc_codeword_bits(L_Ccu_Xu);
    end
    end
    
    % Assuming Cc found a codeword, continue execution
%     write(Cc_word_bits,8);
%     sum = 0;
   
    error = zeros(source_len, 1);
    for ss = 1:source_len
        error(ss) = input(ss) - Cc_word_bits(ss) * LDPC_point;
%         sum = sum + error(ss)^2;
    end
%     mse = sum/source_len;
%     disp("LDPC round")
%     disp(round)
%     disp("LDPC MSE")
%     disp(mse)
%     disp(var(error))
    quantization_error = ModA(error, Az); % Implement mod2A function
        disp(var(quantization_error))
%     sum = 0;
%     for ss = 1:source_len
%         sum = sum + quantization_error(ss)^2;
%     end
%     disp("distortion constraint e1")
%     disp(sum/source_len)
end