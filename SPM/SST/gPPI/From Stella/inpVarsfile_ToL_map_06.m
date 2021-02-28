clear all;
%stats/model batch
%input: cd, scans, mat file met condities
%in map 04 zijn alleen de incorrect van conditie 5 gemodeled, ipv alle
%condities

cd '/Volumes/Anders EXT/Analysis_ToL/1stlevels/';
%studynumber (Exposure, DCS etc)
for S = 1
    %group = 0;
    % %Subjects included in ToL analyses (loaded into structures per run/timepoint):
    % % Run1: x = [1, 3:19, 21:24, 26:29, 33:36, 38, 41:57, 59:70, 72:2:80]
    % % Run2: x = [1, 3:4, 6:14, 16:18, 21:22, 26, 28:29, 33:36, 42:48, 50:53, 55:57, 59:66, 68,70, 72, 78, 80]
    % % Run3: x = [1, 3:4, 6:11, 13:14, 16:18, 21:22, 24, 26, 28:29, 33:36, 42:48, 50:51, 53, 55:57, 60:61, 63:66, 68, 70, 72, 78, 80]
    % % Following IDs are mising: ID20, ID25, 30, 31, 32, 37, 39, 40,58, 71, 73, 75, 77, 79.
    % % Not included, because part of DCS trial: run1: 2152, 2154, 2156, 2158, 21510, 21512; ...
    % % run2: 2152, 2154, 2156, 2158, 21510, 21512; run3: 2152, 2154, 2156, 2158, 21510, 21512
    %
    % Bergen T0
    subjects{1}=[1, 3:19, 21:24, 26:29, 33:36, 38, 41:57, 59:63, 65:70, 72:2:74, 78,80];
    
    % Bergen T1
    subjects{2}=[1, 3:4, 6:14, 16:18, 21:22, 26, 28:29, 33:36, ...
        42:48, 50:53, 55:57, 59:66, 68,70, 72, 78, 80];
    
    % Bergen T2
    subjects{3}=[1, 3:4, 6:11, 13:14, 16:18, 21:22, 24, 26, 28:29, 33:36, ...
        42:48, 50:51, 53, 55:57, 60:61, 63:66, 68, 70, 72, 78, 80];
    
    % % Bergen test
    % subjects{4}=[1];
    
    
    %xls file 1st row has been deleted (practive round)
    %define group: 1 OCD, 2 Controls, 0 Pilot
    %define run
    %for r = 1:3
    for r = 1:3
        for x = subjects{1,r}
        %for x = 4
    
        %define subjectnumber
        %for x = [22, 65]
        %for x = subjects{1,r}
            %         for  x = [1, 3:19, 21:24, 26:29, 33:36, 38, 41:57, 59:63, 65:70, 72:2:74, 78, 80];
            %map
            m = [6];
            
            %load study specific files
            file = strcat('/Volumes/Anders EXT/Analysis_ToL/1stlevels/Beh_xls2mat_20May2019/ToLBergenSubjOnsets_iCBT_v2.mat');
            %ToL_BehData_iCBT_1_run_1
            load(file);
            outputdir = ['/Volumes/Anders EXT/Analysis_ToL/1stlevels/'];
            
            
            if x < 10
                dir =  strcat(outputdir,'map_0', num2str(m),'/ToL_0000', num2str(x), '_', num2str(r-1), '/');
            else
                dir =  strcat(outputdir,'map_0', num2str(m),'/ToL_000', num2str(x), '_', num2str(r-1), '/');
            end
            mkdir(dir);
            
            
            % ONSETS(x).run(r).cond(n).accRT = X(f,3);
            % ONSETS(x).run(r).cond(n).accOns = X(f,4);
            % ONSETS(x).run(r).cond(n).numbacc = u;
            % ONSETS(x).run(r).cond(n).incRT = K(i,3);
            % ONSETS(x).run(r).cond(n).incOns = K(i,4);
            % ONSETS(x).run(r).cond(n).numbInc = a;
            
            
            %N conditions:
            %1 = baseline, ToL1 = 2; ToL2=3; ToL3=4; ToL4=5; ToL5=6; all
            %incorrect=7
            %accurate trials
            %run1: x=22; x=65 no cond6
            if ((x == 22) | (x == 65)) & (r == 1)
                nr = 6 %was 5
            else
                nr = 7 %was 6
            end
            
            onsets = cell(1,nr);
            durations = cell(1,nr);
            names = cell(1,nr);
            
            %1tm5 of 1tm6
            %1 = baseline, ToL1 = 2; ToL2=3; ToL3=4; ToL4=5; ToL5=6; all
            %incorrect=7
            for n = 1:(nr-1)
                %N = [n];
                %names{n} = ['cond' num2str(N)];
                onsets{n} = ONSETS(x).run(r).cond(n).accOns;
                durations{n} = ONSETS(x).run(r).cond(n).accRT;
            end
            names{1} = ['count'];
            names{2} = ['plan1'];
            names{3} = ['plan2'];
            names{4} = ['plan3'];
            names{5} = ['plan4'];
            if ((x == 22) | (x == 65)) & (r == 1)
                names{nr} = ['incorrect'];
                onsets{nr} = ONSETS(x).run(r).cond(7).incOns;
                durations{nr} = ONSETS(x).run(r).cond(7).incRT;
                
            else
                names{6} = ['plan5'];
                names{nr} = ['incorrect'];
                onsets{nr} = ONSETS(x).run(r).cond(7).incOns;
                durations{nr} = ONSETS(x).run(r).cond(7).incRT;
                
            end
            
            
            
            if x < 10
                eval(['save(''' num2str(dir) 'ToL_iCBT_7cond_vars_00' num2str(x) '_' num2str(r-1) '.mat'',' '''names''' ',' '''onsets''' ',' '''durations''' ')']);
            else
                eval(['save(''' num2str(dir) 'ToL_iCBT_7cond_vars_0' num2str(x) '_' num2str(r-1) '.mat'',' '''names''' ',' '''onsets''' ',' '''durations''' ')']);
            end
            %eval(['save(''' num2str(pathstr) '\ERT_vars_10cond' num2str(x) '_' num2str(r) '.mat'',' '''names''' ',' '''onsets''' ',' '''durations''' ')']);
            
        end
    end
end

