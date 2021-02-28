%% The following script was retrived and modifed from https://github.com/kkurkela/KyleSPMToolbox/tree/master/gPPI
function gPPI_parameters(subject,VOI_name,VOI_XYZ,VOI_size,gPPI_dir,first_level_dir)
% parameters    function designed to work with wrapper script.
%
%   parameters(subject, VOI_name, VOI_XYZ, VOI_size, gPPI_dir, analysis_dir)
%
% See also: wrapper

% global x
% global r

%% Create a VOI mask
% Go to this subjects gPPI directory. If the mask exists, move on. If the
% masks does not exist, create it.

cd(gPPI_dir);          % Change present working directory to this subjects gPPI dir
%if exist([VOI_name '_mask.nii'], 'file') % if there is already a VOI image for this person, move on
%else                                     % if not...
create_sphere_image(strcat(first_level_dir, 'SPM.mat'),VOI_XYZ,{VOI_name},VOI_size); % create sphere around seed and save it in this subjects gPPI dir

% Use ImCalc to mask the subject VOI by the 1st level mask
matlabbatch{1}.spm.util.imcalc.input = {
    strcat(first_level_dir,'mask.nii')
    strcat(gPPI_dir, VOI_name, '_mask.nii')
    };
matlabbatch{1}.spm.util.imcalc.output = strcat(VOI_name, '_mask');
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
% P.Tasks         = ['0' {'count' 'plan1' 'plan2' 'plan3' 'plan4' 'incorrect'}];
P.Tasks         = ['0' {'count' 'plan1' 'plan2' 'plan3' 'plan4' 'plan5' 'incorrect'}]; % Specify the tasks for this analysis. Think of these as trial types. Zero means "does not have to occur in every session"
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

P.Contrasts(1).left      = {'plan1'}; % left side or positive side of contrast
P.Contrasts(1).right     = {'count'}; % right side or negative side of contrast
P.Contrasts(1).STAT      = 'T'; % T contrast
P.Contrasts(1).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(1).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(1).name      = 'Plan1_BL'; % Name of this contrast

P.Contrasts(2).left      = {'count'}; % left side or positive side of contrast
P.Contrasts(2).right     = {'plan1'}; % right side or negative side of contrast
P.Contrasts(2).STAT      = 'T'; % T contrast
P.Contrasts(2).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(2).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(2).name      = 'BL_plan1'; % Name of this contrast

P.Contrasts(3).left      = {'plan2'}; % left side or positive side of contrast
P.Contrasts(3).right     = {'plan1'}; % right side or negative side of contrast
P.Contrasts(3).STAT      = 'T'; % T contrast
P.Contrasts(3).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(3).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(3).name      = 'Plan2_1'; % Name of this contrast

P.Contrasts(4).left      = {'plan3'}; % left side or positive side of contrast
P.Contrasts(4).right     = {'plan2'}; % right side or negative side of contrast
P.Contrasts(4).STAT      = 'T'; % T contrast
P.Contrasts(4).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(4).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(4).name      = 'Plan3_2'; % Name of this contrast

P.Contrasts(5).left      = {'plan4'}; % left side or positive side of contrast
P.Contrasts(5).right     = {'plan3'}; % right side or negative side of contrast
P.Contrasts(5).STAT      = 'T'; % T contrast
P.Contrasts(5).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(5).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(5).name      = 'Plan4_3'; % Name of this contrast

%for x = 22 en 65 r1 thuis is again 4_3
P.Contrasts(6).left      = {'plan5'}; % left side or positive side of contrast
P.Contrasts(6).right     = {'plan4'}; % right side or negative side of contrast
P.Contrasts(6).STAT      = 'T'; % T contrast
P.Contrasts(6).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(6).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(6).name      = 'Plan5_4'; % Name of this contrast

P.Contrasts(7).left      = {'plan2'}; % left side or positive side of contrast
P.Contrasts(7).right     = {'count'}; % right side or negative side of contrast
P.Contrasts(7).STAT      = 'T'; % T contrast
P.Contrasts(7).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(7).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(7).name      = 'Plan2_BL'; % Name of this contrast

P.Contrasts(8).left      = {'plan3'}; % left side or positive side of contrast
P.Contrasts(8).right     = {'count'}; % right side or negative side of contrast
P.Contrasts(8).STAT      = 'T'; % T contrast
P.Contrasts(8).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(8).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(8).name      = 'Plan3_BL'; % Name of this contrast

P.Contrasts(9).left      = {'plan4'}; % left side or positive side of contrast
P.Contrasts(9).right     = {'count'}; % right side or negative side of contrast
P.Contrasts(9).STAT      = 'T'; % T contrast
P.Contrasts(9).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(9).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(9).name      = 'Plan4_BL'; % Name of this contrast

%for x = 22 en 65 r1 thuis is again 4_bl
P.Contrasts(10).left      = {'plan5'}; % left side or positive side of contrast
P.Contrasts(10).right     = {'count'}; % right side or negative side of contrast
P.Contrasts(10).STAT      = 'T'; % T contrast
P.Contrasts(10).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(10).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(10).name      = 'Plan5_BL'; % Name of this contrast

P.Contrasts(11).left      = {'count'}; % left side or positive side of contrast
P.Contrasts(11).right     = {'plan2'}; % right side or negative side of contrast
P.Contrasts(11).STAT      = 'T'; % T contrast
P.Contrasts(11).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(11).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(11).name      = 'BL_plan2'; % Name of this contrast

P.Contrasts(12).left      = {'count'}; % left side or positive side of contrast
P.Contrasts(12).right     = {'plan3'}; % right side or negative side of contrast
P.Contrasts(12).STAT      = 'T'; % T contrast
P.Contrasts(12).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(12).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(12).name      = 'BL_plan3'; % Name of this contrast

P.Contrasts(13).left      = {'count'}; % left side or positive side of contrast
P.Contrasts(13).right     = {'plan4'}; % right side or negative side of contrast
P.Contrasts(13).STAT      = 'T'; % T contrast
P.Contrasts(13).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(13).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(13).name      = 'BL_plan4'; % Name of this contrast

%for x = 22 en 65 r1 thuis is again bl_4
P.Contrasts(14).left      = {'count'}; % left side or positive side of contrast
P.Contrasts(14).right     = {'plan5'}; % right side or negative side of contrast
P.Contrasts(14).STAT      = 'T'; % T contrast
P.Contrasts(14).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(14).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(14).name      = 'BL_plan5'; % Name of this contrast

P.Contrasts(15).left      = {'plan1'}; % left side or positive side of contrast
P.Contrasts(15).right     = {'plan2'}; % right side or negative side of contrast
P.Contrasts(15).STAT      = 'T'; % T contrast
P.Contrasts(15).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(15).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(15).name      = 'Plan1_2'; % Name of this contrast

P.Contrasts(16).left      = {'plan2'}; % left side or positive side of contrast
P.Contrasts(16).right     = {'plan3'}; % right side or negative side of contrast
P.Contrasts(16).STAT      = 'T'; % T contrast
P.Contrasts(16).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(16).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(16).name      = 'Plan2_3'; % Name of this contrast

P.Contrasts(17).left      = {'plan3'}; % left side or positive side of contrast
P.Contrasts(17).right     = {'plan4'}; % right side or negative side of contrast
P.Contrasts(17).STAT      = 'T'; % T contrast
P.Contrasts(17).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(17).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(17).name      = 'Plan3_4'; % Name of this contrast

%for x = 22 en 65 r1 thuis is again 3_4
P.Contrasts(18).left      = {'plan4'}; % left side or positive side of contrast
P.Contrasts(18).right     = {'plan5'}; % right side or negative side of contrast
P.Contrasts(18).STAT      = 'T'; % T contrast
P.Contrasts(18).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(18).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(18).name      = 'Plan4_5'; % Name of this contrast

% % if ((x == 22) | (x == 65)) & (r == 1)
% % P.Contrasts(20).left      = {[0 0 0 0 0 0 0 -4 1 1 1 1 0]}; % left side or positive side of contrast
% % else
% P.Contrasts(19).left      = {[0 0 0 0 0 0 0 -5 1 1 1 1 1]}; % left side or positive side of contrast
% % end
% P.Contrasts(19).right     = {'none'}; % right side or negative side of contrast
% P.Contrasts(19).STAT      = 'T'; % T contrast
% P.Contrasts(19).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
% P.Contrasts(19).MinEvents = 1; % min number of event need to compute this contrast
% P.Contrasts(19).name      = 'AllPlan_BL'; % Name of this contrast
% 
% % if ((x == 22) | (x == 65)) & (r == 1)
% % P.Contrasts(21).left      = {[0 0 0 0 0 0 0 4 -1 -1 -1 -1 0]}; % left side or positive side of contrast
% % else
% P.Contrasts(20).left      = {[0 0 0 0 0 0 0 5 -1 -1 -1 -1 -1]}; % left side or positive side of contrast
% % end
% P.Contrasts(20).right     = {'none'}; % right side or negative side of contrast
% P.Contrasts(20).STAT      = 'T'; % T contrast
% P.Contrasts(20).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
% P.Contrasts(20).MinEvents = 1; % min number of event need to compute this contrast
% P.Contrasts(20).name      = 'BL_AllPlan'; % Name of this contrast
% 
% % if ((x == 22) | (x == 65)) & (r == 1)
% % P.Contrasts(22).left      = {[0 0 0 0 0 0 0 0 -1.5 -0.5 0.5 1.5 0]}; % left side or positive side of contrast
% % else
% P.Contrasts(21).left      = {[0 0 0 0 0 0 0 0 -2.5 -1.5 -0.5 1 3.5]}; % left side or positive side of contrast
% % end
% P.Contrasts(21).right     = {'none'}; % right side or negative side of contrast
% P.Contrasts(21).STAT      = 'T'; % T contrast
% P.Contrasts(21).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
% P.Contrasts(21).MinEvents = 1; % min number of event need to compute this contrast
% P.Contrasts(21).name      = 'ParamLoad'; % Name of this contrast
% 
% % if ((x == 22) | (x == 65)) & (r == 1)
% % P.Contrasts(23).left      = {[0 0 0 0 0 0 0 0 1.5 0.5 -0.5 -1.5 0]}; % left side or positive side of contrast
% % else
% P.Contrasts(22).left      = {[0 0 0 0 0 0 0 0 2.5 1.5 0.5 -1 -3.5]}; % left side or positive side of contrast
% % end
% P.Contrasts(22).right     = {'none'}; % right side or negative side of contrast
% P.Contrasts(22).STAT      = 'T'; % T contrast
% P.Contrasts(22).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
% P.Contrasts(22).MinEvents = 1; % min number of event need to compute this contrast
% P.Contrasts(22).name      = 'InvParamLoad'; % Name of this contrast
% 
% % if ((x == 22) | (x == 65)) & (r == 1)
% % P.Contrasts(24).left      = {[0 0 0 0 0 0 0  0 -1 -1 -1 3 0]}; % left side or positive side of contrast
% % else
% P.Contrasts(23).left      = {[0 0 0 0 0 0 0 0 -1 -1 -1 1.5 1.5]}; % left side or positive side of contrast
% % end
% P.Contrasts(23).right     = {'none'}; % right side or negative side of contrast
% P.Contrasts(23).STAT      = 'T'; % T contrast
% P.Contrasts(23).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
% P.Contrasts(23).MinEvents = 1; % min number of event need to compute this contrast
% P.Contrasts(23).name      = 'Plan45_123'; % Name of this contrast
% 
% % if ((x == 22) | (x == 65)) & (r == 1)
% % P.Contrasts(25).left      = {[0 0 0 0 0 0 0  0 1 1 1 -3 0]}; % left side or positive side of contrast
% % else
% P.Contrasts(24).left      = {[0 0 0 0 0 0 0 0 1 1 1 -1.5 -1.5]}; % left side or positive side of contrast
% % end
% P.Contrasts(24).right     = {'none'}; % right side or negative side of contrast
% P.Contrasts(24).STAT      = 'T'; % T contrast
% P.Contrasts(24).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
% P.Contrasts(24).MinEvents = 1; % min number of event need to compute this contrast
% P.Contrasts(24).name      = 'Plan123_45'; % Name of this contrast
% 


%  names{1} = ['count'];
%             names{2} = ['plan1'];
%             names{3} = ['plan2'];
%             names{4} = ['plan3'];
%             names{5} = ['plan4'];
%  names{6} = ['plan5'];
%     names{nr} = ['incorrect'];




%%% Below are parameters for gPPI. All set to zero for do not use. See website
%%% for more details on what they do.
P.FSFAST           = 0;
P.peerservevarcorr = 0;
P.wb               = 0;
P.zipfiles         = 0;
P.rWLS             = 0;

%% Actually Run PPI
PPPI(P)