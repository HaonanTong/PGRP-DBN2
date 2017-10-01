T = readtable('Arabidopsis_TFs.csv','ReadRowNames',false,'ReadVariableNames',true);
array_T = table2array(T);
myFile = dir(fullfile('./','A_Stage*/GOTARGET.txt'));
for i = 1 : length(myFile)
    file = sprintf('%s/%s',myFile(i).folder,myFile(i).name);
    subT = readtable(file,'ReadRowNames',false,'ReadVariableNames',false);
    Targets = table2array(subT); % target that associated with GO:0009873
    GOTargetTF = [];
    for j = 1 : length(Targets)
        if any( strcmp(array_T,Targets(j)) )
            GOTargetTF = [ GOTargetTF ; Targets(j) ];
        end
    end
    if ~isempty(GOTargetTF)
        subTout = table(GOTargetTF);
        writetable(subTout,sprintf('%s/GOTargetTF.txt',myFile(i).folder),...
            'WriteRowNames',false,'WriteVariableNames',true);
    end
end