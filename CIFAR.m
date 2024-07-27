
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE ALL THE GLOBAL VARIABLES FOR WZC
s1=cell2mat(struct2cell(load("predict_v.mat")));


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

Dvi =  [2, 1, 2, 1, 2, 1, 2, 1, 2, 3, 7, 6, 7, 6, 7, 6, 7, 6, 7, 8, 11, 22, 23];
Dci =  8;
Frac_N_VND = [34736, 1, 35121, 1, 20896, 1, 17987, 1, 2648, 73495, 1769, 1, 9417, 1, 11418, 1, 11363, 1, 2903, 2583, 2, 4543, 4923];
Frac_N_CND = 116905;
N_VND = 233812;
N_CND = 116905;
TotalEdge = 935240;
Dv = 24;
Dc = 1;
PAM_Cc = 4;
LDPC_point = (Az/4);
sigma_ep_LDPC = 0.1691; 
sigma_dp_LDPC = 0.1532; 


% For LDGM 

global Dvi_Cq
global Dci_Cq
global Frac_N_VND_Cq
global Frac_N_CND_Cq
global N_CND_Cq
global N_VND_Cq
global Total_edge_Cq
global Dv_Cq
global Dc_Cq
global PAM
global LDGM_point
global sigma_eo_LDGM
global sigma_ep_LDGM

Dvi_Cq = 10;
Dci_Cq = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 24, 27, 30, 33, 57, 63, 70];
Frac_N_VND_Cq = 52154;
Frac_N_CND_Cq = [65292, 19361, 9011, 5793, 2386, 3095, 2228, 790, 1012, 866, 1468, 1546, 559, 29, 622, 923, 735, 2, 350, 800, 38];
N_VND_Cq = 52154;
N_CND_Cq = 116906;
Total_edge_Cq = 521540;
Dv_Cq = 1;
Dc_Cq = 21;
PAM = 2;
LDGM_point = 0.2792;
sigma_eo_LDGM = 0.07247;	
sigma_ep_LDGM = 0.0933;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

type = 6; % switch different quantize Scheme

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for z-sign  parameter
gamma = zeros(40,1);
for h=1:40
    if h<9
        gamma(h)=0.008;
    elseif h<16 && h>=8
        gamma(h)=0.0008;
    elseif h<24 && h>=16
        gamma(h)=0.005;
    elseif h==24
        gamma(h)=0.0005;
    elseif h<33 && h>=25
        gamma(h)=0.002;
    elseif h<39 && h>=33
        gamma(h)=0.0005;
    else 
        gamma(h)=0.0001;
    end
end
sigma = 0.05;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
datanumber=5000;  %% the number of data samples of each user

%Run DownloadCIFAR10 function to download CIFAR-10 dataset
%Run
% %% Prepare the CIFAR-10 dataset

% if ~exist('cifar10Train','dir')
%     disp('Saving the Images in folders. This might take some time...');    
%     saveCIFAR10AsFolderOfImages('cifar-10-batches-mat', pwd, true);
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%% data processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
categories = {'Deer','Dog','Frog','Cat','Bird','Automobile','Horse','Ship','Truck','Airplane'};

rootFolder = 'cifar10Test';
imds_test = imageDatastore(fullfile(rootFolder, categories), ...
    'LabelSource', 'foldernames');


 categories = {'Deer','Dog','Frog','Cat','Bird','Automobile','Horse','Ship','Truck','Airplane'};

rootFolder = 'cifar10Train';
imds = imageDatastore(fullfile(rootFolder, categories), ...
    'LabelSource', 'foldernames');
 
%%%%%%%%%%%%%%%%%%%%% IID dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
[imds1,imds2,imds3,imds4,imds5,imds6,imds7,imds8,imds9,imds10] = splitEachLabel(imds, 0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%% Non IID dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [imds1,imds2,imds3,imds4,imds5,imds6,imds7,imds8,imds9,imds10] = GetUnbalancedCIFAR(rootFolder, 0.25);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% imds1 is the dataset of user 1. 


numberofneuron=50; % Number of neurons that consists of local FL model of each user
averagenumber=1;  % Average number of runing simulations. 
iteration=40;     % Total number of global FL iterations.
learningspeed=0.005; % Learning speed of each user
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

localiterations=17;  % Number of local updates at each iteration.


finalerror=[];
averageerror=[];
kk=0;
proposed=1; % 0 for FedAvg


%%%%%%%%%%%%%%%%%%%%%%%% Matrix size of local FL model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w1length=5*5*3*32;

w2length=5*5*32*32;

w3length=5*5*32*64;

w4length=64*576;

w5length=10*64;

b1length=32;

b2length=32;

b3length=64;

b4length=64;

b5length=10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error=zeros(iteration,1);

for userno=10:3:10  % Number of users.
    kk=kk+1;
    usernumber=userno; 
    
    
for average=1:1:averagenumber

    
    
wupdate=zeros(iteration,usernumber);   % local model for each user

%%%%%%%%%%%%% local model of each user%%%%%%%%%%%%%%%%%%%%%%%  
w1=[];
w2=[];
w3=[];
w4=[];
w5=[];
b1=[];
b2=[];
b3=[];
b4=[];
b5=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wnew=zeros(5,5,3,32,usernumber);
lwnew=zeros(5,5,32,32,usernumber);
bnew=zeros(5,5,32,64,usernumber);
obnew=zeros(64,576,usernumber);
fwnew=zeros(10,64,usernumber);



%%%%%%%%%%%%% gradient of local FL models %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
deviationw=[];
deviationlw=[];
deviationb=[];
deviationob=[];
deviationofw=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%Building local FL model of each user  %%%%%%%%%%%%%%%%%%%%%%%%%
varSize = 32; 
layer = [
    imageInputLayer([varSize varSize 3]);
    convolution2dLayer(5,varSize,'Padding',2,'BiasLearnRateFactor',2); 
    maxPooling2dLayer(3,'Stride',2);
    reluLayer();
    convolution2dLayer(5,32,'Padding',2,'BiasLearnRateFactor',2);
    reluLayer();
    averagePooling2dLayer(3,'Stride',2);
    convolution2dLayer(5,64,'Padding',2,'BiasLearnRateFactor',2);
    reluLayer();
    averagePooling2dLayer(3,'Stride',2);
    fullyConnectedLayer(64,'BiasLearnRateFactor',2); 
    reluLayer();
    fullyConnectedLayer(length(categories),'BiasLearnRateFactor',2);
    softmaxLayer()
    classificationLayer()];

option = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.008, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 1, ...
    'MiniBatchSize', 60, ...
    'Verbose', true);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




for i=1:1:iteration
    
%%%%%%%%%%%%%%%%%%%%%%%Setting of local FL model %%%%%%%%%%%%%%%%%%%%%%%%%%   
    if i==16
        option = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.005, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 1, ...
    'MiniBatchSize', 60, ...
    'Verbose', true);
    
     elseif i==25
        option = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.002, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 1, ...
    'MiniBatchSize', 60, ...
    'Verbose', false);
     elseif i==33
        option = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.0005, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 1, ...
    'MiniBatchSize', 60, ...
    'Verbose', false);
     elseif i==39
        option = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.0001, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 1, ...
    'MiniBatchSize', 60, ...
    'Verbose', false);
         elseif i==42
        option = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.00005, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 1, ...
    'MiniBatchSize', 60, ...
    'Verbose', false);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sum_side = zeros(116906,1);

disp("to zero")
for user=1:1:usernumber
       
    
           clear netvaluable;
    Winstr1=strcat('net',int2str(user));     
     midstr=strcat('imds',int2str(user)); 
     
    eval(['imdss','=',midstr,';']);
    
if i > 1
   % Let global FL model to be the local FL model of each user, which is
   % equal to that the BS transmits the global FL model to the users  

      layer(2).Weights=globalw1;

    layer(5).Weights=globalw2;

     layer(8).Weights=globalw3;
     layer(11).Weights=globalw4;
    layer(13).Weights=globalw5;   
     
         layer(2).Bias=globalb1;

    layer(5).Bias=globalb2;

     layer(8).Bias=globalb3;
     layer(11).Bias=globalb4;
    layer(13).Bias=globalb5;   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
       
      




[netvaluable, info] = trainNetwork(imdss, layer, option); % Train local FL model.


%%%%%%%%%%%%%%%%%%%calculate identification accuracy%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 labels = classify(netvaluable, imds_test);

% This could take a while if you are not using a GPU
confMat = confusionmat(imds_test.Labels, labels);
confMat = confMat./sum(confMat,2);
error(i,1)=mean(diag(confMat))+error(i,1); % Here, error is identification accuracy.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%% global model for each user, which consists of 4 matrices  

if i==1    
    globalw1=zeros(5,5,3,32);
globalw2=zeros(5,5,32,32);
globalw3=zeros(5,5,32,64);
globalw4=zeros(64,576);
globalw5=zeros(10,64);

    globalb1=zeros(1,1,32);
globalb2=zeros(1,1,32);
globalb3=zeros(1,1,64);
globalb4=zeros(64,1);
globalb5=zeros(10,1);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Record trained local FL model.

w1(:,:,:,:,user)=netvaluable.Layers(2).Weights;

w2(:,:,:,:,user)=netvaluable.Layers(5).Weights;

     w3(:,:,:,:,user)=netvaluable.Layers(8).Weights;
    w4(:,:,user)=netvaluable.Layers(11).Weights;
w5(:,:,user)=netvaluable.Layers(13).Weights;
     
     
b1(:,:,:,user)=netvaluable.Layers(2).Bias;

b2(:,:,:,user)=netvaluable.Layers(5).Bias;

   b3(:,:,:,user)=netvaluable.Layers(8).Bias;
   b4(:,:,user)=netvaluable.Layers(11).Bias;
   b5(:,:,user)=netvaluable.Layers(13).Bias;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     
if proposed==1
    
    
%%%%%%%%%%%%% Calculate the gradient of local FL model of each user%%%%%%%        
if i==1    
     
deviationw1= w1(:,:,:,:,user);
deviationw2=w2(:,:,:,:,user);
deviationw3= w3(:,:,:,:,user);
deviationw4=w4(:,:,user);
deviationw5=w5(:,:,user);

deviationb1=b1(:,:,:,user);
deviationb2=b2(:,:,:,user);
deviationb3=b3(:,:,:,user);
deviationb4=b4(:,:,user);
deviationb5= b5(:,:,user);

else
    
    
deviationw1= w1(:,:,:,:,user)-globalw1;
deviationw2=w2(:,:,:,:,user)-globalw2;
deviationw3= w3(:,:,:,:,user)-globalw3;
deviationw4=w4(:,:,user)-globalw4;
deviationw5=w5(:,:,user)-globalw5;

deviationb1=b1(:,:,:,user)-globalb1;
deviationb2=b2(:,:,:,user)-globalb2;
deviationb3=b3(:,:,:,user)-globalb3;
deviationb4=b4(:,:,user)-globalb4;
deviationb5= b5(:,:,user)-globalb5;    
        
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%% reshape the gradient of local FL model of each user%%%%%%%        

w1vector=reshape(deviationw1,[w1length,1]);

w2vector=reshape(deviationw2,[w2length,1]);

w3vector=reshape(deviationw3,[w3length,1]);

w4vector=reshape(deviationw4,[w4length,1]);

w5vector=reshape(deviationw5,[w5length,1]);   


b1vector=reshape(deviationb1,[b1length,1]);

b2vector=reshape(deviationb2,[b2length,1]);

b3vector=reshape(deviationb3,[b3length,1]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%WZC Quantize Scheme


% gradient
    m_fH1 = [w1vector;w2vector;w3vector;w4vector;w5vector;...
             b1vector;b2vector;b3vector;deviationb4;deviationb5];

%input m_fH1 should be size (:,1)    
    if type ==1 % only LDPC quantizer with scale = 3.33/(2*max(abs(m_fH1)));
        
        scale = 3.33/(2*max(abs(m_fH1)));
        
        test_fH1 = m_fH1 * scale;
        v_fHhat1 = only_LDPC(test_fH1); 
        
        m_fHhat1 = v_fHhat1 / scale;
        
        m_fHhat1 = reshape(m_fHhat1,size(m_fH1));  

        
    elseif type == 2 % LDPC quantizer + WZC with scale = 3.33/(2*max(abs(m_fH1)));
        if user <= 5 
            scale = 3.33/(0.5*max(abs(m_fH1)));
        
            test_fH1 = m_fH1 * scale;
            v_fHhat1 = only_LDPC(test_fH1); 
        
            m_fHhat1 = v_fHhat1 / scale;
        
            m_fHhat1 = reshape(m_fHhat1,size(m_fH1));
            
            sum_side = sum_side + m_fHhat1;
            sideinfo = sum_side/5;
        else           
            scale = 3.33/(max(abs(m_fH1)));
     
            test_fH1 = m_fH1 * scale;
            side_information = sideinfo * scale;
            
            v_fHhat1 = WZC(test_fH1,side_information); 

            m_fHhat1 = v_fHhat1 / scale;
            m_fHhat1 = reshape(m_fHhat1,size(m_fH1));
        end
        
        
     elseif type == 3 % TCQ quantizer + WZC with predict scale
        if user <= 5 
            m_fHhat1 = m_fQuantizeData(m_fH1);
            sum_side = sum_side + m_fHhat1;
            sideinfo = sum_side/5;
        else           
            scale = s1(i);
            
            test_fH1 = m_fH1 * scale;
            side_information = sideinfo * scale;
            
            s_fHhat1 = WZC(test_fH1,side_information); 

            m_fHhat1 = s_fHhat1 / scale;
            m_fHhat1 = reshape(m_fHhat1,size(m_fH1));
        end
        
        
    elseif type == 4 %low rate TCQ

        m_fHhat1 = m_fQuantizeData(m_fH1);

    elseif type ==5  %FedAvg
       
        m_fHhat1 = m_fH1;
        
    elseif type ==6  %[zhang 21 ISIT] previous one side information
       
%          if user == 1 %TCQ
%             m_fHhat1 = m_fQuantizeData(m_fH1);
%             sideinfo = m_fHhat1;
          if user == 1   %LDPC
            scale = 3.33/(2*max(abs(m_fH1)));
        
            test_fH1 = m_fH1 * scale;
            v_fHhat1 = only_LDPC(test_fH1); 
        
            m_fHhat1 = v_fHhat1 / scale;
        
            m_fHhat1 = reshape(m_fHhat1,size(m_fH1)); 
            sideinfo = m_fHhat1;
        else           
 
            scale = s1(i);
            
            test_fH1 = m_fH1 * scale;
            side_information = sideinfo * scale;
            
            v_fHhat1 = WZC(test_fH1,side_information); 

            m_fHhat1 = v_fHhat1 / scale;
            m_fHhat1 = reshape(m_fHhat1,size(m_fH1));
            
            sideinfo = m_fHhat1;
        end
        
    elseif type ==7  %average previous side information
       if user == 1 
            m_fHhat1 = m_fQuantizeData(m_fH1);
            sum_side = sum_side + m_fHhat1;
            sideinfo = sum_side;
        else          
            scale = s1(i);
            
            test_fH1 = m_fH1 * scale;
            side_information = sideinfo * scale;
            
            v_fHhat1 = WZC(test_fH1,side_information); 

            m_fHhat1 = v_fHhat1 / scale;
            m_fHhat1 = reshape(m_fHhat1,size(m_fH1));
            
            sum_side = sum_side + m_fHhat1;
            sideinfo = sum_side/user;
       end
     elseif type == 8 %z-SignFedAvg
         disp(max(abs(m_fH1)))
%         ksi_z_0  = normrnd(0,1,size(m_fH1)); % z=1
%         v_fHhat1 = gamma(i).*z_sign(m_fH1.\gamma(i)+sigma.*ksi_z_0);
        
         ksi_z_inf = unifrnd(-1,1,size(m_fH1)); % z=inf
         v_fHhat1 = gamma(i).*z_sign(m_fH1.\gamma(i)+sigma.*ksi_z_inf);
        
        
        m_fHhat1 = reshape(v_fHhat1,size(m_fH1));
    end


   
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
 bstart=w1length+w2length+w3length+w4length+w5length;
   
 %%%%%%%%%%%%%%%% reshape the gradient of the loss function after coding %%%%%%%%%%%%  
 deviationw1=reshape(m_fHhat1(1:w1length),[5,5,3,32]);
  deviationw2=reshape(m_fHhat1(w1length+1:w1length+w2length),[5,5,32,32]);
  deviationw3=reshape(m_fHhat1(w1length+w2length+1:w1length+w2length+w3length),[5,5,32,64]);
deviationw4=reshape(m_fHhat1(w1length+w2length+w3length+1:w1length+w2length+w3length+w4length),[64,576]);
deviationw5=reshape(m_fHhat1(w1length+w2length+w3length+w4length+1:bstart),[10,64]);

 deviationb1(1,1,:)=reshape(m_fHhat1(bstart+1:bstart+b1length),[1,1,32]);
  deviationb2(1,1,:)=reshape(m_fHhat1(bstart+b1length+1:bstart+b1length+b2length),[1,1,32]);
  deviationb3(1,1,:)=reshape(m_fHhat1(bstart+b1length+b2length+1:bstart+b1length+b2length+b3length),[1,1,64]);
deviationw4(:,1)=m_fHhat1(bstart+b1length+b2length+b3length+1:bstart+b1length+b2length+b3length+b4length);
deviationw5(:,1)=m_fHhat1(bstart+b1length+b2length+b3length+b4length+1:bstart+b1length+b2length+b3length+b4length+b5length);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 %%%%%%%%%%%%%%%% calculate the local FL model of each user after coding %%%%%%%%%%%%  

    if i==1
   
   w1(:,:,:,:,user)=deviationw1;
w2(:,:,:,:,user)=deviationw2;
 w3(:,:,:,:,user)=deviationw3;
w4(:,:,user)=deviationw4;
w5(:,:,user)=deviationw5;

b1(:,:,:,user)=deviationb1;
b2(:,:,:,user)=deviationb2;
b3(:,:,:,user)=deviationb3;
b4(:,:,user)=deviationb4;
b5(:,:,user)=deviationb5;
              
    else       
      w1(:,:,:,:,user)=deviationw1+globalw1;
w2(:,:,:,:,user)=deviationw2+globalw2;
 w3(:,:,:,:,user)=deviationw3+globalw3;
w4(:,:,user)=deviationw4+globalw4;
w5(:,:,user)=deviationw5+globalw5;

b1(:,:,:,user)=deviationb1+globalb1;
b2(:,:,:,user)=deviationb2+globalb2;
b3(:,:,:,user)=deviationb3+globalb3;
b4(:,:,user)=deviationb4+globalb4;
b5(:,:,user)=deviationb5+globalb5;     
        
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

end



 %%%%%%%%%%%%%%%% update the global FL model  %%%%%%%%%%%%  
globalw1=1/usernumber*sum(w1,5);  % global training model
globalw2=1/usernumber*sum(w2,5);  % global training model
globalw3=1/usernumber*sum(w3,5);
globalw4=1/usernumber*sum(w4,3);

globalw5=1/usernumber*sum(w5,3);

globalb1=1/usernumber*sum(b1,4);  % global training model
globalb2=1/usernumber*sum(b2,4);  % global training model
globalb3=1/usernumber*sum(b3,4);
globalb4=1/usernumber*sum(b4,3);

globalb5=1/usernumber*sum(b5,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%% without coding and encoding 
% 
% wglobal(i,:)=1/usernumber*sum(w,2);  % global training model
% lwglobal(i,:)=1/usernumber*sum(lw,2);  % global training model
% bglobal(i,:)=1/usernumber*sum(b,2);
% obglobal(i,:)=1/usernumber*sum(ob,2);


%tmp_net = netvaluable.saveobj;

% netvaluable.Layers(2).Weights =globalw1;
% tmp_net.Layers(5).Weights =globalw2;
% tmp_net.Layers(8).Weights =globalw3;
% tmp_net.Layers(11).Weights =globalw4;
% tmp_net.Layers(13).Weights =globalw5;
% 
% tmp_net.Layers(2).Bias =globalb1;
% tmp_net.Layers(5).Bias =globalb2;
% tmp_net.Layers(8).Bias =globalb3;
% tmp_net.Layers(11).Bias =globalb4;
% tmp_net.Layers(13).Bias =globalb5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


error(i,1)=error(i,1)/10; %%%% calculate the final error
end





    






end

end