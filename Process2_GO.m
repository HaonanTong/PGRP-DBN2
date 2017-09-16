%% Generate hub gene list hubgobjs.csv for each stage
myFile = dir(fullfile('./','A_Stage*/Network_Cytoscape.csv'));
for i = 1 : length(myFile)
    display(myFile(i).folder);
    display(myFile(i).name);
end

for i = 1 : length(myFile)
    file = sprintf('%s/%s',myFile(i).folder,myFile(i).name);
    T = readtable(file,'ReadRowNames',false,'ReadVariableNames',true);
    Source = T(:,1);
    Source = unique(Source);
    writetable(Source,sprintf('%s/%s',myFile(i).folder,'hubgobjs.csv'));
end

%% hubgenes_go.txt and hubgenes_num.txt
myFile = dir(fullfile('./','A_Stage*/hubgobjs.csv'));
myFile = dir(fullfile('./','A_Stage*/hubgobjs.csv'));
for i = 1 : length(myFile)
    display(myFile(i).folder);
    display(myFile(i).name);
end

for i = 1 : length(myFile)
    file = sprintf('%s/%s',myFile(i).folder,myFile(i).name);
    file_go = strcat(myFile(i).folder,'/hubgenes_go');
    unix(sprintf('awk -F "." ''{if ($1 ~ /AT/) print $1}'' %s | sort -u > %s.txt',file, file_go));
    file_go_num = strcat(myFile(i).folder,'/hubgenes_num');
    unix(sprintf('awk ''END{print NR}'' %s.txt > %s.txt',file_go,file_go_num));
end

%% hubgenes_go_discripition.txt
myFile = dir(fullfile('./','A_Stage*/hubgenes_go.txt'));
for i = 1 : length(myFile) 
    glist = sprintf('%s/%s',myFile(i).folder,myFile(i).name);
    glistgo = sprintf('%s/%s',myFile(i).folder,'hubgenes_go_discripition.txt');
    unix(sprintf('grep -f %s ATH_GO_GOSLIM.txt | sort -u > %s',glist,glistgo));
end

%% For David
unix(sprintf('paste A_Stage*/hubgenes_go.txt > DavidHUBsGO.txt'));

%% Association with GO:0009873
% A_Stage*/GO_ETHYLENE*.txt
Array = [12,123,1234,12345,56];
for i = 1 :length(Array)
    unix(sprintf('grep  "GO:0009873" A_Stage%d/hubgenes_go_discripition.txt > A_Stage%d/GO_ETHYLENE.txt',Array(i),Array(i)));
    unix(sprintf(...
        'awk ''BEGIN{ FS = "\\t"} {if ($1 ~ /AT/) print $1}'' A_Stage%d/GO_ETHYLENE.txt | sort -u > A_Stage%d/GO_ETHYLENE2.txt'...
        ,Array(i),Array(i)));
    unix(sprintf('awk ''END{print NR}'' A_Stage%d/GO_ETHYLENE2.txt > A_Stage%d/GO_ETHYLENE2_NUM.txt',Array(i),Array(i)));
end