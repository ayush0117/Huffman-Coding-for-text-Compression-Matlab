
file_name=input('Enter original file name:','s');
file_name_2=input('Enter compressed file name:','s');
fid = fopen(file_name,'r');
fid2=fopen(file_name_2,'r');
F = fread(fid);
G = fread(fid2);
fclose(fid);
fclose(fid2);
t=isequal(F,G);

if t==1
    fprintf('$$$$$$$$$ Equal $$$$$$$$$\n');
else
    fprintf('$$$$$$$$$ Not Equal $$$$$$$$$\n');
end