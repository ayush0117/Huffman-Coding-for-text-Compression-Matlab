%clc 
%clear all;
file_name=input('Enter compressed file name:','s');
fileID = fopen(file_name, 'r');    

l_header_dec =(fread(fileID, 1, 'double'))';% Read the length of the header written in the first position
header_dec = (fread(fileID, l_header_dec, 'double'))'; % Read all the fields of the header indicated by first position

%%%%%% header writing  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myfile1 = 'header.bin';                  
fileID1 = fopen(myfile1, 'w');
fwrite(fileID1, header_dec, 'double');
fclose(fileID1);

%%%%%%%%%%%%%%%%EXTRACTING THE REQUIRED INFO FROM THE  HEADER FOR DECODING PURPOSE %%%%%%%%%%

trunc_len_dec=header_dec(1); 
window_size_dec=header_dec(2);
alphabet_size_dec=header_dec(3);
original_symbols_dec=string(header_dec(4:3+alphabet_size_dec));
indiv_prob_dec=header_dec(4+alphabet_size_dec:3+2*alphabet_size_dec);
t_prob_dec=header_dec(4+2*alphabet_size_dec:end-1)';
l_encoded_dec=header_dec(end);
trans_prob_dec=reshape(t_prob_dec,alphabet_size_dec,alphabet_size_dec);

bits_dec = (fread(fileID,l_encoded_dec, 'ubit1'))';   %%%%% Reading the encoded bits 

myfile2 = 'bits.bin';
fileID2 = fopen(myfile2, 'w');
fwrite(fileID2, bits_dec, 'ubit1');
fclose(fileID2);

fclose(fileID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% BUILDING THE SYMBOLS AND PROBABILITIES FOR DECODING %%%
%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


symbols_dec=zeros(1,alphabet_size_dec^window_size_dec);
t=1;

switch window_size_dec
case 1
            prob_dec=indiv_prob_dec;
            symbols_dec=str2double(original_symbols_dec);
case 2
            for i=1:2
            for j=1:2
            prob_dec(t)=indiv_prob_dec(i)*trans_prob_dec(i,j); %%P(X,Y)=P(X)P(Y|X)
            symbols_dec(t)=str2double(strcat(original_symbols_dec(i),original_symbols_dec(j)));
            t=t+1;
            end    
            end    
case 3 
            for i=1:2
            for j=1:2
            for k=1:2              
            prob_dec(t)=indiv_prob_dec(i)*trans_prob_dec(i,j)*trans_prob_dec(j,k);
            symbols_dec(t)=str2double(strcat(original_symbols_dec(i),original_symbols_dec(j),original_symbols_dec(k)));
            t=t+1;
            end
            end
            end
case 4
            for i=1:2
            for j=1:2
            for k=1:2
            for l=1:2     %%P(X,Y,Z,A)=P(X)P(Y|X)P(Z|Y)P(A|Z)
            prob_dec(t)=indiv_prob_dec(i)*trans_prob_dec(i,j)*trans_prob_dec(j,k)*trans_prob_dec(k,l);
            symbols_dec(t)=str2double(strcat(original_symbols_dec(i),original_symbols_dec(j),original_symbols_dec(k),original_symbols_dec(l)));
            t=t+1;
            end
            end
            end
            end 
case 5
            for i=1:2
            for j=1:2
            for k=1:2
            for l=1:2
            for m=1:2   %%P(X,Y,Z,A,B)=P(X)P(Y|X)P(Z|Y)P(A|Z)P(B|A)
            prob_dec(t)=indiv_prob_dec(i)*trans_prob_dec(i,j)*trans_prob_dec(j,k)*trans_prob_dec(k,l)*trans_prob_dec(l,m);
            symbols_dec(t)=str2double(strcat(original_symbols_dec(i),original_symbols_dec(j),original_symbols_dec(k),original_symbols_dec(l),original_symbols_dec(m)));         
            t=t+1;
            end
            end
            end
            end
            end    
case 6
            for i=1:2
            for j=1:2
            for k=1:2
            for l=1:2
            for m=1:2
            for n=1:2  %%P(X,Y,Z,A,B)=P(X)P(Y|X)P(Z|Y)P(A|Z)P(B|A)
            prob_dec(t)=indiv_prob_dec(i)*trans_prob_dec(i,j)*trans_prob_dec(j,k)*trans_prob_dec(k,l)*trans_prob_dec(l,m)*trans_prob_dec(m,n);
            symbols_dec(t)=str2double(strcat(original_symbols_dec(i),original_symbols_dec(j),original_symbols_dec(k),original_symbols_dec(l),original_symbols_dec(m),original_symbols_dec(n)));         
            t=t+1;
            end
            end
            end
            end
            end
            end   
end


prob_dec(1) = prob_dec(1) + ( 1 - sum(prob_dec) ); %Normalising for round off error


%%%%%%%%%%%% Creating Huffman Dict using symbols_dec and prob_dec %

dict_dec = huffmandict(symbols_dec, prob_dec);

%%%%%% Huffman Decoding %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
my_data_dec = huffmandeco(bits_dec, dict_dec); 

%%%% Checking if whether symbols are  truncated %%%%%%%
%%%% If yes, We delete the truncated symbols  %%%%%%%%%
if trunc_len_dec>0
temp=int2str(my_data_dec(end));
temp1=str2double(strcat(temp(1:end-trunc_len_dec)));
my_data_dec(end)=temp1;
seq_dec=my_data_dec;
else
    seq_dec=my_data_dec;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% File writing in the text file %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileID = fopen('t.txt', 'w+');
for i=1:length(my_data_dec) 
   fprintf(fileID,'%d',my_data_dec(i));
end
fclose(fileID);

fid = fopen('t.txt','r');
data = char(fread(fid)');
s = [data];
a = char(s-1)

file_name=input('Enter file name:','s');
fileID = fopen(file_name, 'w+');
for i=1:length(a) 
   fprintf(fileID,char(a(i)));
end
fclose(fileID);
