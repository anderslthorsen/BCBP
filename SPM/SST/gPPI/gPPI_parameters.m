%% The following script was retrived and modifed from https://github.com/kkurkela/KyleSPMToolbox/tree/master/gPPI
function gPPI_parameters(subject,VOI_name,VOI_XYZ,VOI_size,gPPI_dir,first_level_dir)
% parameters    function designed to work with wrapper script.
%
%   parameters(subject, VOI_name, VOI_XYZ, VOI_size, gPPI_dir, analysis_dir)
%
% See also: wrapper

%% Create a VOI mask
% Go to this subjects gPPI directory. If the mask exists, move on. If the
% masks does not exist, create it.

cd(gPPI_dir)          % Change present working directory to this subjects gPPI dir
%if exist([VOI_name '_mask.nii'], 'file') % if there is already a VOI image for this person, move on
%else                                     % if not...
    create_sphere_image(strcat(first_level_dir, 'SPM.mat'),VOI_XYZ,{VOI_name},VOI_size) % create sphere around seed and save it in this subjects gPPI dir
    
    % Use ImCalc to mask the subject VOI by the 1st level mask
    matlabbatch{1}.spm.util.imcalc.input = {
                                            strcat(first_level_dir,'mask.nii')
                                            strcat(gPPI_dir, VOI_name, '_mask.nii')
                                            };
    matlabbatch{1}.spm.util.imcalc.output = strcat(VOI_name, '_mask') ;
    matlabbatch{1}.spm.util.imcalc.outdir = {gPPI_dir};
    matlabbatch{1}.spm.util.imcalc.expression = 'i2.*(i1>0.9)';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run', matlabbatch);
 %end

%% Setting the gPPI Parameters

%%% For more details on the parameters below and what they mean, go to the
%%% gPPI website and download the guide: http://www.nitrc.org/projects/gppi

P.subject       = subject; % A string with the subjects id
P.directory     = first_level_dir; % path to the first level GLM directory
%P.VOI           = fullfile(gPPI_dir, [VOI_name '_mask_1stlevelmasked.nii']); % path to the ROI image, created above
P.VOI           = fullfile(gPPI_dir, [VOI_name '_mask.nii']); % path to the ROI image, created above
P.Region        = VOI_name; % string, basename of output folder
P.Estimate      = 1; % Yes, estimate this gPPI model
%P.contrast      = 0; % contrast to adjust for. Default is zero for no adjustment
P.contrast     = 'Omnibus F-test for PPI Analyses'; % contrast to adjust for. Default is zero for no adjustme
P.extract       = 'eig'; % method for ROI extraction. Default is eigenvariate
P.Tasks         = ['0' {'SucGo' 'SucStop' 'FailStop'}]; % Specify the tasks for this analysis. Think of these as trial types. Zero means "does not have to occur in every session"
P.Weights       = []; % Weights for each task. If you want to weight one more than another. Default is not to weight when left blank
P.maskdir       = gPPI_dir; % Where should we save the masks?
P.equalroi      = 1; % When 1, All ROI's must be of equal size. When 0, all ROIs do not have to be of equal size
P.FLmask        = 1; % restrict the ROI's by the first level mask. This is useful when ROI is close to the edge of the brain
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
P.Contrasts(1).name      = 'SucStop_minus_SucGo'; % Name of this contrast

P.Contrasts(2).left      = {'SucGo'}; % left side or positive side of contrast
P.Contrasts(2).right     = {'SucStop'}; % right side or negative side of contrast
P.Contrasts(2).STAT      = 'T'; % T contrast
P.Contrasts(2).Weighted  = 0; % Wieghting contrasts by trials
P.Contrasts(2).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(2).name      = 'SucGo_minus_SucStop'; % Name of this contrast

P.Contrasts(3).left      = {'SucStop'};
P.Contrasts(3).right     = {'SucGo'}; % right side or negative side of contrast
P.Contrasts(3).STAT      = 'F'; % T contrast
P.Contrasts(3).Weighted  = 0; % Wieghting contrasts by trials
P.Contrasts(3).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(3).name      = 'SucStop_vs_SucGo'; % Name of this contrast

P.Contrasts(4).left      = {'FailStop'}; % left side or positive side of contrast
P.Contrasts(4).right     = {'SucStop'}; % right side or negative side of contrast
P.Contrasts(4).STAT      = 'T'; % T contrast
P.Contrasts(4).Weighted  = 0; % Wieghting contrasts by trials
P.Contrasts(4).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(4).name      = 'FailStop_minus_SucStop'; % Name of this contrast

P.Contrasts(5).left      = {'SucStop'}; % left side or positive side of contrast
P.Contrasts(5).right     = {'FailStop'}; % right side or negative side of contrast
P.Contrasts(5).STAT      = 'T'; % T contrast
P.Contrasts(5).Weighted  = 0; % Wieghting contrasts by trials
P.Contrasts(5).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(5).name      = 'SucStop_minus_FailStop'; % Name of this contrast

%%% Below are parameters for gPPI. All set to zero for do not use. See website
%%% for more details on what they do.
P.FSFAST           = 0;
P.peerservevarcorr = 0;
P.wb               = 0;
P.zipfiles         = 0;
P.rWLS             = 0;

%% Actually Run PPI
PPPI(P)