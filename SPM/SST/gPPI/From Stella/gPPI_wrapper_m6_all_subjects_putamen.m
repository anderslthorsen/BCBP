clear
clc
addpath('/Applications/SPM_12/spm12/toolbox/PPPI/PPPIv13');

% global x
% global r

%error cond6 no inputs:run1: x=22; x=65 separate!
subjects{1}=[1, 3:19, 21, 23:24, 26:29, 33:36, 38, 41:57, 59:63, 66:70, 72:2:74, 78,80];

% Bergen T1
subjects{2}=[1, 3:4, 6:14, 16:18, 21:22, 26, 28:29, 33:36, ...
    42:48, 50:53, 55:57, 59:66, 68,70, 72, 78, 80];

% Bergen T2
subjects{3}=[1, 3:4, 6:11, 13:14, 16:18, 21:22, 24, 26, 28:29, 33:36, ...
    42:48, 50:51, 53, 55:57, 60:61, 63:66, 68, 70, 72, 78, 80];

% Bergen test
subjects{4}=[1];

%% Sets up SPM environment and Graphics window
spm_jobman('initcfg');
spm('defaults','FMRI');
spm_figure('GetWin','Graphics');
%% The following script was retrived and modifed from https://github.com/kkurkela/KyleSPMToolbox/tree/master/gPPI
%%% gPPI Wrapper Script Template %%%
%analysis_dir = 's:\nad12\STUDYNAME\analyses\ANALYSISNAME';  % where ever we are pulling from
%gPPI_dir     = 's:\nad12\STUDYNAME\analyses\GPPIFOLDERNAME';    % where ever we are outputting to
script_dir   = '/Volumes/Anders EXT/Analysis_ToL/1stlevels/map_05/gPPI_scripts/'; % where ever this script is located
addpath(script_dir);
%cd(script_dir)
% Specify all subjects to run
%subjects.gPPI = subjects(S);

% Specify VOIs to run
% 
% VOI(1).Name = 'L_amygdala';  % Arbitrary VOI Name
% VOI(1).Peak = [-23 -2 -16]; % x,y,z, in MNI space
% VOI(1).Size = 5;          % diameter (mm)
% 
% VOI(2).Name = 'R_amygdala';  % Arbitrary VOI Name
% VOI(2).Peak = [23 0 -16]; % x,y,z, in MNI space
% VOI(2).Size = 5;          % diameter (mm)

VOI(1).Name = 'L_putamen';  % Arbitrary VOI Name
VOI(1).Peak = [-24 0 -3]; % x,y,z, in MNI space
VOI(1).Size = 3.5;          % diameter (mm)

VOI(2).Name = 'R_putamen';  % Arbitrary VOI Name
VOI(2).Peak = [24 0 -3]; % x,y,z, in MNI space
VOI(2).Size = 3.5;          % diameter (mm)
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
% for r = 1
for r = 1:3
    S = r;
%         for x = 1
        for x = subjects{1,S}
        %for x = [22, 65]
        m = [6];
        
        % % Specify folders with files
        % Specify paths to relevant directories.
        % EPI_dir = '/Volumes/Anders EXT/Analysis_ToL/Preprocessing/Preprocessing3/';
        dirrp = '/Volumes/Anders EXT/Analysis_ToL/Preprocessing/Preprocessing2/';
        inputdir = '/Volumes/Anders EXT/Analysis_ToL/Preprocessing/Preprocessing3/';
        outputdir = '/Volumes/Anders EXT/Analysis_ToL/1stlevels/';
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
            %fn = strcat(EPI_dir,'SST_0000',num2str(x),timepoint,'\swuaSST_0000',num2str(x),timepoint,'.nii');
            %             subject_dir = strcat(EPI_dir,'SST_0000',num2str(x),timepoint);
            %             first_level_dir = strcat(subject_dir,'\1st_level\');
            %             gPPI_dir = strcat(subject_dir,'\gPPI_omnibus_3conds\');
            
            fn = strcat(inputdir,'ToL_0000',num2str(x),'_', num2str(r-1),'/swuaTOL_0000',num2str(x),'_T',num2str(r-1),'.nii');
            rpfn = strcat(dirrp,'ToL_0000', num2str(x), '_', num2str(r-1), '/rp_aToL_0000', num2str(x), '_T', num2str(r-1), '.txt');
            first_level_dir = strcat(outputdir,'map_0', num2str(m),'/ToL_0000', num2str(x), '_', num2str(r-1), '/');
            gPPI_dir = strcat(first_level_dir, 'gPPI_omn7cond/');
        elseif x < 100
            fn = strcat(inputdir,'ToL_000',num2str(x),'_', num2str(r-1),'/swuaTOL_000',num2str(x),'_T',num2str(r-1),'.nii');
            rpfn = strcat(dirrp,'ToL_000', num2str(x), '_', num2str(r-1), '/rp_aToL_000', num2str(x), '_T', num2str(r-1), '.txt');
            first_level_dir = strcat(outputdir,'map_0', num2str(m),'/ToL_000', num2str(x), '_', num2str(r-1), '/');
            gPPI_dir = strcat(first_level_dir, 'gPPI_omn7cond/');
        end
        %subject_ID = num2str(x);
        %subject = strcat(subject_ID, timepoint);
        subject = strcat(num2str(x), '_', num2str(r));
        %     if isfolder(gPPI_dir)    % if this subject's gPPI directory already exists, skip this part
        %     else                                        % if the subject's gPPI directory does NOT exist
        mkdir(gPPI_dir)   % create new gPPI specific directory
        %     end
        for v = 1:length(VOI)                       % for each VOI...
            gPPI_parameters(subject, VOI(v).Name, VOI(v).Peak, VOI(v).Size, gPPI_dir,first_level_dir) % run the gPPI analysis
        end
    end
end
cd(script_dir)                                  % return to the scripts diretory, where this script is held