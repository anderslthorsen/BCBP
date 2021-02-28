clear
clc
addpath('C:\Midlertidig_Lagring\spm12\toolbox\gPPI\PPPI');

% Bergen T0
subjects{1}=[1 3 4 5 6 7 8 9 10 11        ...
    12 13 14 15 16 17 18 19 21 22       ...
    23 24 26 27 28 29 33 34 35 36       ...
    38 41 42 43 44 45 46 47 48 49       ...
    50 51 52 53 54 55 56 57 59 60       ...
    61 62 63 64 65 66 67 68 69 70       ...
    72 74 78 80];

% Bergen T1
subjects{2}=[1 3 4 6 7 8 9 10 11       ...
    12 13 14 16 17 18 21 22 26 28 29 33 34  ...
    35 36 42 43 44 46 47 48 50 51 52     ...
    53 55 56 57 59 60 61 62 63 64 65 66     ...
    68 70 72 78 80];


% Bergen T2
subjects{3}=[1 3 4 6 7 8 9 10 11 13        ...
    14 16 17 18 21 22 24 26 28 ...
    29 33 34 35      ...
    36 42 43 44 45 46 47 48 50 51 53 55 56 57   ...
    59 60 61 63 64 65 66 68 70 72 78 80];

% Bergen test
subjects{4}=[3];

%% Sets up SPM environment and Graphics window
    spm_jobman('initcfg');
    spm('defaults','FMRI');
    spm_figure('GetWin','Graphics');
%% The following script was retrived and modifed from https://github.com/kkurkela/KyleSPMToolbox/tree/master/gPPI    
%%% gPPI Wrapper Script Template %%%

% Specify paths to relevant directories.
EPI_dir = '\\ihelse.net\Forskning\hbe\2015-00936\Data_analysis\SST\EPI_corrected_slicetiming\';
%analysis_dir = 's:\nad12\STUDYNAME\analyses\ANALYSISNAME';  % where ever we are pulling from
%gPPI_dir     = 's:\nad12\STUDYNAME\analyses\GPPIFOLDERNAME';    % where ever we are outputting to
script_dir   = '\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Scripts\gPPI'; % where ever this script is located

% Specify all subjects to run
%subjects.gPPI = subjects(S);

% Specify VOIs to run
VOI(1).Name = 'L_amygdala';  % Arbitrary VOI Name
VOI(1).Peak = [-23 -2 -16]; % x,y,z, in MNI space
VOI(1).Size = 5;          % diameter (mm)

% VOI(2).Name = 'R_amygdala';  % Arbitrary VOI Name
% VOI(2).Peak = [23 0 -16]; % x,y,z, in MNI space
% VOI(2).Size = 5;          % diameter (mm)
 
% VOI(3).Name = 'R_IFG';  % Arbitrary VOI Name
% VOI(3).Peak = [35 23 -11]; % x,y,z, in MNI space
% VOI(3).Size = 10;          % diameter (mm)
% 
% VOI(4).Name = 'L_IFG';  % Arbitrary VOI Name
% VOI(4).Peak = [-33 23 5]; % x,y,z, in MNI space
% VOI(4).Size = 10;          % diameter (mm)

% VOI(X).Name = 'VOINAME';  % Arbitrary VOI Name
% VOI(X).Peak = [42 37 23]; % x,y,z, in MNI space
% VOI(X).Size = 8;          % diameter (mm)

addpath(script_dir) % add script directory to the MATLAB search path
%for s=1:length(subjects.gPPI) % for each subject...
    %% Change S for which timepoint you want to preprocess. 1 = T0, 2 = T1, 3 = T2, 4 = test.
for S = 1:3
    for x = subjects{1,S}
        
        if S == 1
            timepoint = '_T0';
        elseif S == 2
            timepoint = '_T1';
        elseif S == 3
            timepoint = '_T2';
        elseif S == 4
            timepoint = '_T0';
        end
                
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
            %subject_ID = num2str(x);
            %subject = strcat(subject_ID, timepoint);
            subject = 'subject';
    if isfolder(gPPI_dir)    % if this subject's gPPI directory already exists, skip this part
    else                                        % if the subject's gPPI directory does NOT exist
        mkdir(subject_dir, 'gPPI_omnibus_3conds')   % create new gPPI specific directory
    end
    for v = 1:length(VOI)                       % for each VOI...
        gPPI_parameters(subject, VOI(v).Name, VOI(v).Peak, VOI(v).Size, gPPI_dir,first_level_dir) % run the gPPI analysis
    end
    end
end
%cd(script_dir)                                  % return to the scripts diretory, where this script is held