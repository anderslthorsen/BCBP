clear
clc

%% Fixed variables
EPI_dir = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\EPI_corrected_slicetiming\';

% Specify VOIs to run
VOI(1).Name = 'R_amygdala';  % Arbitrary VOI Name
VOI(1).Peak = [23 0 -16]; % x,y,z, in MNI space
VOI(1).Size = 5;          % diameter (mm)

VOI(2).Name = 'L_amygdala';  % Arbitrary VOI Name
VOI(2).Peak = [-23 -2 -16]; % x,y,z, in MNI space
VOI(2).Size = 5;          % diameter (mm)

VOI(3).Name = 'R_IFG';  % Arbitrary VOI Name
VOI(3).Peak = [35 23 -11]; % x,y,z, in MNI space
VOI(3).Size = 10;          % diameter (mm)

VOI(4).Name = 'L_IFG';  % Arbitrary VOI Name
VOI(4).Peak = [-33 23 5]; % x,y,z, in MNI space
VOI(4).Size = 10;          % diameter (mm)

%% Timepoint
S = 3;
% 1 = T0, 2 = T1, 3 = T2, 4 = test

if S == 1
    timepoint = '_T0';
    Sheet = 'T0';
elseif S == 2
    timepoint = '_T1';
    Sheet = 'T1';
elseif S == 3
    timepoint = '_T2';
    Sheet = 'T2';
elseif S == 4
    timepoint = '_T0';
    Sheet = 'T0';
end


list_path = '\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Scripts\Participant_list.xlsx';
PPI_list = readtable(list_path,'Sheet',Sheet);
PPI_list = table2struct(PPI_list);

for i = 1:length(PPI_list) % for each participant
    
    % Defining subject folders
    x = PPI_list(i).Participant;
    
    if x < 10
        fn = strcat(EPI_dir,'SST_0000',num2str(x),timepoint,'\swuaSST_0000',num2str(x),timepoint,'.nii');
        subject_dir = strcat(EPI_dir,'SST_0000',num2str(x),timepoint);
        first_level_dir = strcat(subject_dir,'\1st_level\');
        gPPI_dir = strcat(subject_dir,'\gPPI_omnibus_3conds\');
    elseif x < 100
        fn = strcat(EPI_dir,'SST_000',num2str(x),timepoint,'\swuaSST_000',num2str(x),timepoint,'.nii');
        subject_dir = strcat(EPI_dir,'SST_000',num2str(x),timepoint);
        first_level_dir = strcat(subject_dir,'\1st_level\');
        gPPI_dir = strcat(subject_dir,'\gPPI_omnibus_3conds\');
    end
    
    for v = 1:length(VOI)                       % for each VOI...
        region = VOI(v).Name;
        region_voxels = strcat(VOI(v).Name, '_voxels');
        
        PPI_list(i).(region) = isfile(strcat(gPPI_dir, VOI(v).Name, '_mask.nii')); % Gets if VOI is present
        
        if PPI_list(i).(region) == 1
            PPI_list(i).(region_voxels) = sum(spm_summarise(strcat(gPPI_dir, VOI(v).Name, '_mask.nii'),'all'));
        else
            PPI_list(i).(region_voxels) = 0;
        end
    end
end

cd('\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\QC\gPPI');
time = datestr(now,'dd.mm.yyyy-HH.MM');
writetable(struct2table(PPI_list), strcat('PPI_list', timepoint, '_', time, '.xlsx'));

%% denne teller voxler med 1 i verdi (inne i masken)
%sum(spm_summarise('R_amygdala_mask.nii','all'))



