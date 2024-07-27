clear all
global source_len
global dc_tilta_max_Cc;
global Az;
global system_bits;
global hard_value;
global Mul_Max;
global alpha
global Pv
global side_record
global gradient_record


source_len = 116906;
dc_tilta_max_Cc = 8;
Az = 3.33 / 2 ;
system_bits = 100001;
hard_value = 400;
Mul_Max = 0.999999999999999;
alpha = 0.4612;
Pv = 0.28;
side_record = zeros(source_len,40);
gradient_record = zeros(source_len,40);

% For LDPC 

global Dvi
global Dci
global Frac_N_VND
global Frac_N_CND
global N_VND;
global N_CND;
global TotalEdge;
global Dv;
global Dc;
global PAM_Cc;
global LDPC_point;
global sigma_ep_LDPC;
global sigma_dp_LDPC;

Dvi =  [2,1,2,1,2,1,2,1,2,3,7,6,7,6,7,6,7,6,7,8,12,20,22,23];
Dci =  8;
Frac_N_VND = [34735,1,35120,1,20896,1,17987,1,2649,73490,1765,1,9397,1,11395,1,11340,1,2897,2704,3,1,4053,5372];
Frac_N_CND = 116905;
N_VND = 233812;
N_CND = 116905;
TotalEdge = 935240;
Dv = 23;
Dc = 1;
PAM_Cc = 4;
LDPC_point = (Az/4);
sigma_ep_LDPC = 0.1691; 
sigma_dp_LDPC = 0.1532; 


[LDPC_VND2CND, ~ , ~] = Initialization_LDPC();
parity_check_H = sparse(N_CND,N_VND);

num = Frac_N_VND(1);
total = 0;
ID = 1;
for i=1:N_VND
    if num==0 && ID~=23
        ID = ID+1;
        num = Frac_N_VND(ID);
    end
    for j=1:Dvi(ID)
        parity_check_H(ceil(LDPC_VND2CND(total+j)/8),i) = 1;

    end
    total = total + Dvi(ID);
    num = num - 1;
end

% k = [];

% for i=1:233812
%     a = find(parity_check_H(:,i));
%     a=a';
%     k = [k a];
% end

% while(1)
%     codeword = randi([0 1], 233812,1);
%     for i = 1:116905
%         a = mod(parity_check_H(i,:) * codeword, 2)
%         if mod(parity_check_H(i,:) * codeword, 2) ~= 0
%             break;
%         end
%     end
%     if i==116905
%         break;
%     end
% end


% codeword = ones(233812,1);


value = ones(116906,1);

value = value * 3 * LDPC_point;
% value = value * -3 * LDPC_point;

% w_vector = unifrnd(-Az,Az,[233812,1]);
% [a,b,c] = ldpc_encode(w_vector,parity_check_H);

% codeword(codeword==0) = -1 ;
% 
G = normrnd(0,sqrt(0.1532),[116906,1]);
input = value + G;
w = ModA(input,Az);
decode_codeword = LDPC_decoder(w);
tf1 = zeros(116906,1);
for i=1:116906
    tf1(i) = isequal(value(i),decode_codeword(i));
end
error_bit_num = 116906-sum(tf1);
disp("bit error rate: ")
disp(error_bit_num/116906)
disp(var(w-decode_codeword))

