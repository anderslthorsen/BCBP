clear
clc
addpath('C:\Midlertidig_Lagring\spm12\toolbox\PPPI');

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
    14 16 17 18 21 22 24 26 28 29 33 34 35      ...
    36 42 43 44 45 46 47 48 50 51 53 55 56 57   ...
    59 60 61 63 64 65 66 68 70 72 78 80];

% Bergen test
subjects{4}=[3 4 5 6 7 8 9 10 11];

% Specify folders with EPIs
EPI_dir = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\EPI\';

%% Change S for which timepoint you want to preprocess. 1 = T0, 2 = T1, 3 = T2, 4 = test.
for S = 4
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
            gPPI_dir = strcat(subject_dir,'\gPPI\');
        elseif x < 100
            fn = strcat(EPI_dir,'SST_000',num2str(x),timepoint,'\swuaSST_000',num2str(x),timepoint,'.nii');
            subject_dir = strcat(EPI_dir,'SST_000',num2str(x),timepoint);
            first_level_dir = strcat(subject_dir,'\1st_level\');
            gPPI_dir = strcat(subject_dir,'\gPPI\');
        end

        subject = num2str(x);
cd(subject_dir);        
%% Sets up SPM environment and Graphics window
    spm_jobman('initcfg');
    spm('defaults','FMRI');
    spm_figure('GetWin','Graphics');
    
%% The following script was retrived and modifed from https://github.com/kkurkela/KyleSPMToolbox/tree/master/gPPI
%% Create a VOI mask
% Go to this subjects gPPI directory. If the mask exists, move on. If the
% masks does not exist, create it.

%MNI coordinates for seed regions derived from 2nd level analyses
% Right Insula/IFG = 42, 23, -1
% Left amygdala = -30, 5, -16
% Right amygdala = 30, 5, -16

cd(fullfile(gPPI_dir))          % Change present working directory to this subjects gPPI dir
if exist(['R_IFG_mask.nii'], 'file') % if there is already a VOI image for this person, move on
else                                     % if not...
    create_sphere_image(strcat(first_level_dir,'SPM.mat'),[42,23,-1],{'R_IFG'},10) % create sphere around seed and save it in this subjects gPPI dir
    
    % Use ImCalc to mask the subject VOI by the 1st level mask
    matlabbatch{1}.spm.util.imcalc.input = {
                                            strcat(first_level_dir,'mask.nii')
                                            strcat(gPPI_dir, 'R_IFG_mask.nii')
                                            };
    matlabbatch{1}.spm.util.imcalc.output = 'R_IFG_mask';
    matlabbatch{1}.spm.util.imcalc.outdir = {gPPI_dir};
    matlabbatch{1}.spm.util.imcalc.expression = 'i2.*(i1>0.9)';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run', matlabbatch);

    % Does not create amygdala ROIs for now, as they might noe be included
    % in 1st or 2nd level results
    %create_sphere_image('SPM.mat',VOI_XYZ,{L_amygdala},10)
    %create_sphere_image('SPM.mat',VOI_XYZ,{R_amygdala},10)
end

%% Load first level univariate parameters and remove 'Run#_' from the beginning of regressor names
% In order to avoid a concatenation bug, go to this subject's
% first level analysis directory and edit his/her first level SPM
% parameters file ('SPM.mat') by removing "Run#_" from the front of
% regressor names. For example, if the first level model has
% "Run1_TRIALTYPE" and "Run2_TRIALTYPE". See WIKI for further explanation.
%
%first_level_dir = fullfile(analysis_dir, subject);                      % Path to subjects GLM analysis dir
%load(fullfile(first_level_dir,'SPM.mat'))                               % Load this subject's SPM parameters
%for k = 1:length(SPM.Sess) %#ok<NODEF>                                  % for each Session...
%    for u = 1:length(SPM.Sess(k).U)                                     % for each Trial Type in Session k...
%        if strcmp(SPM.Sess(k).U(u).name{1}(1:3),'Run')                  % If this regressor has "Run" as the first 3 characters...
%            SPM.Sess(k).U(u).name{1} = SPM.Sess(k).U(u).name{1}(6:end); % Remove the first 5 characters of the regressor's name
%            disp(SPM.Sess(k).U(u).name{1})                              % Display the changeed regressor name in the MATLAB Command Window
%        else
%        end
%    end
%end
%save('SPM.mat','SPM') % Save the SPM parameters loaded above to a file called "SPM.mat" in this subject's first level analysis directory.
%                      % Note this overwrites the SPM.mat file which already exists
%
%% Setting the gPPI Parameters
%%% For more details on the parameters below and what they mean, go to the
%%% gPPI website and download the guide: http://www.nitrc.org/projects/gppi

P.subject       = subject; % A string with the subjects id
P.directory     = first_level_dir; % path to the first level GLM directory
P.VOI           = fullfile(gPPI_dir, ['R_IFG_mask.nii']); % path to the ROI image, created above
P.Region        = 'R_IFG'; % string, basename of output folder
P.Estimate      = 1; % Yes, estimate this gPPI model
P.contrast      = 0; % contrast to adjust for. Default is zero for no adjustment
%P.contrast     = 'Omnibus F-test for PPI Analyses'; % contrast to adjust for. Default is zero for no adjustment
P.extract       = 'eig'; % method for ROI extraction. Default is eigenvariate
P.Tasks         = {'0' 'SucGo' 'SucStop'}; % Specify the tasks for this analysis. Think of these as trial types. Zero means "does not have to occur in every session"
P.Weights       = []; % Weights for each task. If you want to weight one more than another. Default is not to weight when left blank
P.maskdir       = gPPI_dir; % Where should we save the masks?
P.equalroi      = 0; % When 1, All ROI's must be of equal size. When 0, all ROIs do not have to be of equal size
P.FLmask        = 0; % restrict the ROI's by the first level mask. This is useful when ROI is close to the edge of the brain
P.VOI2          = 0; % specifiy a second ROI. Only used for "physiophysiological interaction"
P.analysis      = 'psy'; % for "psychophysiological interaction"
P.method        = 'cond'; % "cond" for gPPI and "trad" for traditional PPI
P.CompContrasts = 1; % 1 to estimate contrasts
P.Weighted      = 0; % Weight tasks by number of trials. Default is 0 for do not weight
P.outdir        = gPPI_dir; % Output directory
P.ConcatR       = 0; % Tells gPPI toolbox to concatenate runs

P.Contrasts(1).left      = {'SucStop'}; % left side or positive side of contrast
P.Contrasts(1).right     = {'SucGo'}; % right side or negative side of contrast
P.Contrasts(1).STAT      = 'T'; % T contrast
P.Contrasts(1).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(1).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(1).name      = 'Positive_coupling'; % Name of this contrast

P.Contrasts(2).left      = {'SucGo'}; % left side or positive side of contrast
P.Contrasts(2).right     = {'SucStop'}; % right side or negative side of contrast
P.Contrasts(2).STAT      = 'T'; % T contrast
P.Contrasts(2).Weighted  = 0; % Wieghting contrasts by trials
P.Contrasts(2).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(2).name      = 'Negative_coupling'; % Name of this contrast

%%% Below are parameters for gPPI. All set to zero for do not use. See website
%%% for more details on what they do.
P.FSFAST           = 0;
P.peerservevarcorr = 0;
P.wb               = 0;
P.zipfiles         = 0;
P.rWLS             = 0;

%% Actually Run PPI
PPPI(P)
    end    
end