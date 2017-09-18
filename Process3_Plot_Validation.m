myFile = dir(fullfile('./','A_Stage*/Network_Cytoscape.csv'));

BDeu_threshold = 10;
for i = 1 : length(myFile)
    file = sprintf('%s/%s',myFile(i).folder,myFile(i).name);
    T = readtable(file,'ReadRowNames',false,'ReadVariableNames',true);
    % MaxBDeu = max(T.BDeu);
    indx = T.BDeu > -BDeu_threshold;
    subT = T(indx,:);
    target = unique(subT.Target);
    ntarget = length(target);
    for j = 1 : ntarget
        t_indx = strcmp(subT.Target, target{j});
        source = subT.Source(t_indx);
        glist = [source;target{j}];
        T_expr = readtable('Profiles-ANan-DEGs-Filtered.csv','ReadRowNames',true,'ReadVariableNames',true);
        T_tmp = T_expr(glist,:);
        writetable(T_tmp,sprintf('%s/BDeuMax/subTable%d.csv',myFile(i).folder,j),'WriteVariableNames',true,'WriteRowNames',true);
    end
end

%% plot
myFile = dir(fullfile('./','A_Stage*/BDeuMax/*.csv'));

for i = 1 : length(myFile)
    csv = sprintf('%s/%s',myFile(i).folder,myFile(i).name);
    f_plotTable3( csv, [], 'Normalized Legend' );
end