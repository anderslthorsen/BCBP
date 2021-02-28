%stats/model batch
%input: cd, scans, mat file met condities
%load('C:\OCDPD\OCDproject\Analyses_SPM8\Analyses_ERT_stFeb2010\ERT\Volcount')
% S = 1(OCD), 2(PD), 3 (familiestudie)

clear
clc

% Bergen test
subjects{4}.stop=[1];
        
% Bergen T0
subjects{1}.stop=[1 3 4 5 6 7 8 9 10  ...
    11 12 13 14 15 16 17 18 19 21 22    ...
    23 24 26 27 28 29 33 34 35 36       ...
    38 41 42 43 44 45 46 47 48 49       ...
    50 51 52 53 54 55 56 57 59 60       ...
    61 62 63 64 65 66 67 68 69 70       ...
    72 74 78 80];

% Bergen T1
subjects{2}.stop=[1 3 4 6 7 8 9 10 11       ...
    12 13 14 16 17 18 21 22 26 28 29 33 34  ...
    35 36 42 43 44 46 47 48 50 51 52     ...
    53 55 56 57 59 60 61 62 63 64 65 66     ...
    68 70 72 78 80];

% Bergen T2
subjects{3}.stop=[1 3 4 6 7 8 9 10 11 13        ...
    14 16 17 18 21 22 24 26 28 29 33 34 35      ...
    36 42 43 44 45 46 47 48 50 51 53 55 56 57   ...
    59 60 61 63 64 65 66 68 70 72 78 80];



EPI_dir = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\EPI_corrected_slicetiming\';


for S = 3

for x = subjects{1,S}.stop
    
        %m = 15; %map01, 02 etc
 
     %study group
            if S == 1
                st = '_T0';
                onset_file = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\behavioral_data\output\StopSubjOnsets_SST_T0';
            elseif S == 2
                st = '_T1';
                onset_file = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\behavioral_data\output\StopSubjOnsets_SST_T1';
            elseif S ==3
                st = '_T2';
                onset_file = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\behavioral_data\output\StopSubjOnsets_SST_T2';
            elseif S == 4
                st = '_T0';
                onset_file = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\behavioral_data\output\StopSubjOnsets_SST_T0';
            end
            

        %find right files
        %define right directory ...yet to come
        if x < 10
           subjdirs = strcat(EPI_dir, 'SST_0000', num2str(x), st, '\');
           %eval(['subjdirs ='EPI_dir SST_0000 num2str(x) st '\']);
        elseif x < 100
            subjdirs = strcat(EPI_dir, 'SST_000', num2str(x), st, '\');
            %eval(['subjdirs ='EPI_dir 'SST_000' num2str(x) st '\']);
        else
            eval(['subjdirs =''O:\chris\stop\fMRI\analyses\1st_level\map_' num2str(m) '\' num2str(st) '_0' num2str(x) '\''']);
        end
    
        cd(subjdirs)
        

        % 3cell arrays: names, onsets, durations
        % load(SubjScoresERT) moederfile
       
            %load study specific files
            %file = ['N:\My Scripts\Stop_Stella\Stop_xls\StopSubjOnsets_' num2str(st)];
          
        file = [onset_file];
          load(file)
        %load('C:\OCDPD\OCDproject\Gedrag_hoofdbestanden\Nback\NbackSubjOnsets.mat');
      
        
        %event-related design: %3condities: SucGo, SucStop, FailStop.
        %Fixatie en Fail Go niet mee modelen
        %durations = 0
       
        
        %accurate evemts:
%         for c = 1:8
%             for n = 1:4
%                 events = {ONSETS(x).run(r).cond(n).AccEvent, ONSETS(x).run(r).cond(n).IncorEvent}
%                 
%             
%             i = length(ONSETS(x).run(r).cond(n).AccEvent)
%             onsets = cell(1,i)
%             durations = cell(1,i)
        onsets = cell(1,3)
        durations = cell(1,3)
        names = cell(1,3)
 
        %blok design:
        %events: N0-3 inacc/acc events
        %
        names{1} = 'SucGo';
        onsets{1} = ONSETS(x).cond(3).onsets;
        durations{1} = 0;
        
        names{2} = 'SucStop';
        onsets{2} = ONSETS(x).cond(4).onsets;
        durations{2} = 0;
%         
         names{3} = 'FailStop';
         onsets{3} = ONSETS(x).cond(2).onsets;
         durations{3} = 0;
%         
        
        
        if x < 10
            eval(['save(''' num2str(subjdirs) '\behavior_' '0000' num2str(x) num2str(st) '.mat'',' '''names''' ',' '''onsets''' ',' '''durations''' ')']);
        elseif x < 100
            eval(['save(''' num2str(subjdirs) '\behavior_' '000' num2str(x) num2str(st) '.mat'',' '''names''' ',' '''onsets''' ',' '''durations''' ')']);
        else
            eval(['save(''' num2str(subjdirs) '\Stop_vars_ev1_' num2str(st) '_0' num2str(x) '.mat'',' '''names''' ',' '''onsets''' ',' '''durations''' ')']);
        end
        %eval(['save(''' num2str(pathstr) '\ERT_vars_10cond' num2str(x) '_' num2str(r) '.mat'',' '''names''' ',' '''onsets''' ',' '''durations''' ')']);

        end
    end

