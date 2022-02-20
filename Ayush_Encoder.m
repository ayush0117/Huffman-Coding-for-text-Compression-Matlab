clc 
clear all;


%%%%%%%%%%%%%%%%%%%%%%%% Read Text File %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% The text file must be in the same directory withe the encoder %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file_name=input('Enter file name:','s');
window_size=str2double(input('Enter block size (1 to 6):','s'));
fid = fopen(file_name,'r');
data = char(fread(fid)');
s = [data]
data = char(s+1)
a=length(data); %%% length of the sequence

%%%%%%%%%%%%%%%%%% Frequency, Probability and Transition Probability %%%%%%
original_symbols=[];
q=1;
for i=1:length(data)
   temp= str2double(data(i));
   single_data(i)=temp;
   t=ismember(temp,original_symbols);
   if t==0
   original_symbols(q)=temp;
   q=q+1;
   end 
end
original_symbols=(sort(original_symbols,'ascend')); %% SORTED SYMBOLS
alphabet_size=length(original_symbols);   %%% SIZE OF ALPHABET IN SEQUENCE

original_symbols_str=string(original_symbols); %%% for concatenation of symbols
original_symbols_str2=strtrim(int2str(original_symbols)); %%% for concatenation of  
                                                          %%% extra symbol when required
                                                          
%%%%%%%%%%%%%%%% CREATING CELL ARRAY TO STORE COUNT OF SYMBOLS AND ASSOCIATED INDEX %%%%%%%%%%%%

for i=1:alphabet_size
    for j=1:2
        if j==1
            index{i,j}=find(single_data==original_symbols(i));
        elseif j==2
            index{i,j}=length(index{i,j-1});
        end
     end
 end

%%%%%%%%%%%%%%%%%%%%%% ACCESSING CELL TO FIND INDIVIDUAL PROB %%%%%%%%%%%%

for i=1:alphabet_size
   indiv_prob(i)=index{i,2}/a;
end

%%%%%%%% FINDING TRANSITION PROBABILITY %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%

last=single_data(end); %%% FIND WHICH SYMBOL IS THE LAST SYMBOL OF SEQUENCE
index_last=find(original_symbols==last);  
ram=index{index_last,1};
temp=ram(1:end-1); %% DELETE THE INDEX OF THE LAST SYMBOL BECAUSE AFTER IT WE DONT HAVE SYMBOL
index{index_last,1}=temp; %%%%updated index

%%FIND THE LENGTH OF SYMBOL WHICH IS CONTAINED AFTER A SYMBOL
%%% DIVIDE BY INDIVIDUAL COUNT TO FIND TRANSITION PROB

for i=1:alphabet_size
    for j=1:alphabet_size     
trans_mat(i,j)=length(find(single_data(index{i,1}+1)==original_symbols(j))); %%TRANSITION MATRIX
trans_prob(i,j)=(trans_mat(i,j)/index{i,2});  %%TRANSITION PROBABILITY
    end  
end

%%%%%%%%%%% Finding the probabilities of Extended symbols depending on window size %%%%%%%%%%%%%%%

t=1;
v=1;
q=1;
symbols=zeros(1,alphabet_size^window_size);
trunc_len=0;
modulus=mod(length(data),window_size);

switch window_size
case 1
        prob=indiv_prob;
        symbols=original_symbols;
        my_data=single_data;
case 2
        while modulus~=0
        data=strcat(data,original_symbols_str2(1));
        trunc_len=trunc_len+1;
        modulus=mod(length(data),window_size);
        end
        
        for i=1:length(data)/2
            my_data(i)= str2double(strcat(data(v),data(v+1)));
            v=v+2; 
        end
        
        for i=1:2
        for j=1:2
            prob(t)=indiv_prob(i)*trans_prob(i,j); %%P(X,Y)=P(X)P(Y|X)
            symbols(t)=str2double(strcat(original_symbols_str(i),original_symbols_str(j)));
            t=t+1;
        end    
        end  
case 3
        while modulus~=0
        data=strcat(data,original_symbols_str2(1));
        trunc_len=trunc_len+1;
        modulus=mod(length(data),window_size);
        end
        
        for i=1:length(data)/3
            my_data(i)=str2double(strcat(data(v),data(v+1),data(v+2)));
            v=v+3 ;
        end
        
        for i=1:2
        for j=1:2
        for k=1:2              %%P(X,Y,Z)=P(X)P(Y|X)P(Z|Y)
            prob(t)=indiv_prob(i)*trans_prob(i,j)*trans_prob(j,k);
            symbols(t)=str2double(strcat(original_symbols_str(i),original_symbols_str(j),original_symbols_str(k)));
            t=t+1;
        end
        end
        end
case 4
        while modulus~=0
        data=strcat(data,original_symbols_str2(1));
        trunc_len=trunc_len+1;
        modulus=mod(length(data),window_size);
        end
        
        for i=1:length(data)/4
             my_data(i)=str2double(strcat(data(v),data(v+1),data(v+2),data(v+3)));
             v=v+4 ;
        end
        
        for i=1:2
        for j=1:2
        for k=1:2
        for l=1:2     %%P(X,Y,Z,A)=P(X)P(Y|X)P(Z|Y)P(A|Z)
            prob(t)=indiv_prob(i)*trans_prob(i,j)*trans_prob(j,k)*trans_prob(k,l);
            symbols(t)=str2double(strcat(original_symbols_str(i),original_symbols_str(j),original_symbols_str(k),original_symbols_str(l)));
            t=t+1;
        end
        end
        end
        end 
case 5
        while modulus~=0
        data=strcat(data,original_symbols_str2(1));
        trunc_len=trunc_len+1;
        modulus=mod(length(data),window_size);
        end
        
        for i=1:length(data)/5
        my_data(i)=str2double(strcat(data(v),data(v+1),data(v+2),data(v+3),data(v+4)));
        v=v+5 ;
        end
        
        for i=1:2
        for j=1:2
        for k=1:2
        for l=1:2
        for m=1:2   %%P(X,Y,Z,A,B)=P(X)P(Y|X)P(Z|Y)P(A|Z)P(B|A)
            prob(t)=indiv_prob(i)*trans_prob(i,j)*trans_prob(j,k)*trans_prob(k,l)*trans_prob(l,m);
            symbols(t)=str2double(strcat(original_symbols_str(i),original_symbols_str(j),original_symbols_str(k),original_symbols_str(l),original_symbols_str(m)));         
            t=t+1;
         end
         end
         end
         end
         end
case 6
        while modulus~=0
        data=strcat(data,original_symbols_str2(1));
        trunc_len=trunc_len+1;
        modulus=mod(length(data),window_size);
        end
        
        for i=1:length(data)/6
             my_data(i)=str2double(strcat(data(v),data(v+1),data(v+2),data(v+3),data(v+4),data(v+5)));
             v=v+6 ;
        end
        
        for i=1:2
        for j=1:2
        for k=1:2
        for l=1:2
        for m=1:2
        for n=1:2  %%P(X,Y,Z,A,B)=P(X)P(Y|X)P(Z|Y)P(A|Z)P(B|A)
            prob(t)=indiv_prob(i)*trans_prob(i,j)*trans_prob(j,k)*trans_prob(k,l)*trans_prob(l,m)*trans_prob(m,n);
            symbols(t)=str2double(strcat(original_symbols_str(i),original_symbols_str(j),original_symbols_str(k),original_symbols_str(l),original_symbols_str(m),original_symbols_str(n)));         
            t=t+1;
        end
        end
        end
        end
        end
        end           
end

%%%%%%%% Normalising the probability %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Because the sum of probability vector must be 1 %%%%%

prob(1) = prob(1) + ( 1 - sum(prob) );

%%%%%%%%%%%% Finding the huffman dictionary %%%%%%%%%%%%%%%%%%

[dict, avglen] = huffmandict(symbols, prob);


%%%%%%%%%%%%%% Huffman encoding %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

encoded = huffmanenco(my_data,dict);
l_encoded=length(encoded);
t_prob=trans_prob(:)';

%%%%%%%%%%%%% Creating header for decoding purpose %%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%  The info that is needed for decoding purpose %%%%%%%%%%%%   

head1  = [trunc_len window_size alphabet_size original_symbols indiv_prob t_prob l_encoded]; 
l_head = length( head1 );                                                          
header = [l_head head1];


%%%%%%%%%%% File writing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file_name=input('Enter the file name (.bin): ', 's');
fid=fopen(file_name,'w');
fwrite(fid, header, 'double');   %%%% writing the header in double format
fwrite(fid,encoded,'ubit1');      %%%% writing the encoded bits in binary format after the header
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%