% Script for preprocessing SST files in Bergen. This is a standard pipeline
% with slice time correction, realignment and unwarping, normalizing to MNI
% via the mean EPI (3mm voxels), and smoothing (8mm kernel). All other
% settings are default.

% REMEMBER THAT SST_00004_T2 og SST_00013_T2 have 35 slices (this also affects the TA). 
% All EPIs have 430 volumes.

clear
clc

% Bergen T0
subjects{1}=[1 3 4 5 6 7 8 9 10 11 12 13        ...
            14 15 16 17 18 19 21 22 23 24 26    ...
            27 28 29 33 34 35 36                ...
            38 41 42 43 44 45 46 47 48 49       ...
            50 51 52 53 54 55 56 57 59 60       ...
            61 62 63 64 65 66 67 68 69 70       ...
            72 74 78 80];

% Bergen T1
subjects{2}=[1 3 4 6 7 8 9 10 11            ...
    12 13 14 16 17 18 21 22 26 28 29 33 34  ...
    35 36 42 43 44 46 47 48 50 51 52        ...
    53 55 56 57 59 60 61 62 63 64 65 66     ...
    68 70 72 78 80];

% Bergen T2
subjects{3}=[1 3 4 6 7 8 9 10 11 13             ...
    14 16 17 18 21 22 24 26 28 29 33 34 35      ...
    36 42 43 44 45 46 47 48 50 51 53 55 56      ...
    57 59 60 61 63 64 65 66 68 70 72 78 80];

% Bergen test
subjects{4}=[3];

% Specify folders with EPIs
EPI_dir = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\EPI_corrected_slicetiming\';
T1_dir = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\T1\';

%% Change S for which timepoint you want to preprocess. 1 = T0, 2 = T1, 3 = T2, 4 = test.
for S = 1
    for x = subjects{1,S}
         clearvars -except subjects EPI_dir T1_dir S x logfile
        
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
            fn = strcat(EPI_dir,'SST_0000',num2str(x),timepoint,'\SST_0000',num2str(x),timepoint,'.nii');
            subject_dir = strcat(EPI_dir,'SST_0000',num2str(x),timepoint);
            T1 = strcat(T1_dir,'T1_0000',num2str(x),timepoint,'\T1_0000',num2str(x),timepoint,'.nii');
            onset_file = strcat(EPI_dir,'SST_0000',num2str(x),timepoint,'\behavior_0000',num2str(x),timepoint,'.mat');
            T1_MNI_warps = strcat(T1_dir,'T1_0000',num2str(x),timepoint,'\y_T1_0000',num2str(x),timepoint,'.nii');
        elseif x < 100
            fn = strcat(EPI_dir,'SST_000',num2str(x),timepoint,'\SST_000',num2str(x),timepoint,'.nii');
            subject_dir = strcat(EPI_dir,'SST_000',num2str(x),timepoint);
            T1 = strcat(T1_dir,'T1_000',num2str(x),timepoint,'\T1_000',num2str(x),timepoint,'.nii');
            onset_file = strcat(EPI_dir,'SST_000',num2str(x),timepoint,'\behavior_000',num2str(x),timepoint,'.mat');
            T1_MNI_warps = strcat(T1_dir,'T1_000',num2str(x),timepoint,'\y_T1_000',num2str(x),timepoint,'.nii');
        end
        
        
        % Sets TA, slice order and reference slice to accomdate two
        % participants with 35 slices.
        if S == 3 && x == 4
            nslices = 35;
            TA = 2.04;
            sliceorder = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34];
            ref_slice = 35;
            
        elseif S == 3 && x == 13
            nslices = 35;
            TA = 2.04;
            sliceorder = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34];
            ref_slice = 35;
            
        else
            nslices = 34;
            TA = 2.03823529411765;
            sliceorder = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34];
            ref_slice = 33;
        end
        
        
        % Sets up list of nifti files, otherwise SPM will add the mean EPI
        % to the pipeline which disrupts estimating the 1st level model
        nii = 430;
        niftis = cell(nii,1);
        niftistonormalize = cell(nii,1);
        niftis2stat = cell(nii,1);

        name = strcat('SST_0000',num2str(x),timepoint);
        ext = '.nii';

        for i = 1:1:nii
            niftis(i) = {num2str([subject_dir,'\',name,ext,',' num2str(i)])}';
            niftistonormalize(i) = {num2str([subject_dir,'\ua',name,ext,',' num2str(i)])}';
            niftis2stat(i) = {num2str([subject_dir,'\swua',name,ext,',' num2str(i)])}';
        end
        
        % Creates log for quality checking/debugging
        logfile{x,1} = strcat(num2str(x), timepoint);
        logfile{x,2} = fn;
        logfile{x,3} = niftis2stat(1,1);
        logfile{x,4} = subject_dir;
        logfile{x,5} = T1;
        logfile{x,6} = onset_file;
        logfile{x,7} = nslices;
        logfile{x,8} = ref_slice;

% Changes working directory to corrrect subject        
cd(subject_dir);        
        
%% Sets up SPM environment and Graphics window
    spm_jobman('initcfg');
    spm('defaults','FMRI');
    spm_figure('GetWin','Graphics'); 
%% Reorient T1 and EPI to AC-PC line based on T1 image (Chris Rorden's script)        
%nii_setOrigin12({T1}, 1, false);
%%
matlabbatch{1}.spm.temporal.st.scans = {niftis};
%%
matlabbatch{1}.spm.temporal.st.nslices = nslices;
matlabbatch{1}.spm.temporal.st.tr = 2.1;
matlabbatch{1}.spm.temporal.st.ta = TA;
matlabbatch{1}.spm.temporal.st.so = sliceorder;
matlabbatch{1}.spm.temporal.st.refslice = ref_slice;
matlabbatch{1}.spm.temporal.st.prefix = 'a';
matlabbatch{2}.spm.spatial.realignunwarp.data.scans(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{2}.spm.spatial.realignunwarp.data.pmscan = '';
matlabbatch{2}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
matlabbatch{2}.spm.spatial.realignunwarp.eoptions.sep = 4;
matlabbatch{2}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
matlabbatch{2}.spm.spatial.realignunwarp.eoptions.rtm = 0;
matlabbatch{2}.spm.spatial.realignunwarp.eoptions.einterp = 2;
matlabbatch{2}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
matlabbatch{2}.spm.spatial.realignunwarp.eoptions.weight = '';
matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.jm = 0;
matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.sot = [];
matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.rem = 1;
matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.noi = 5;
matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
matlabbatch{2}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
matlabbatch{2}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
matlabbatch{2}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realignunwarp.uwroptions.mask = 1;
matlabbatch{2}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';

% Coregistration uses T1-image as reference, coregisteres mean EPI to the
% T1, and then uses the same transformation to all the realigned EPI images

matlabbatch{3}.spm.spatial.coreg.estimate.ref = {strcat(T1,',1')};
matlabbatch{3}.spm.spatial.coreg.estimate.source(1) = cfg_dep('Realign & Unwarp: Unwarped Mean Image', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','meanuwr'));
matlabbatch{3}.spm.spatial.coreg.estimate.other(1) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','uwrfiles'));
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{4}.spm.spatial.preproc.channel.vols = {strcat(T1,',1')};
matlabbatch{4}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{4}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{4}.spm.spatial.preproc.channel.write = [0 1];
matlabbatch{4}.spm.spatial.preproc.tissue(1).tpm = {'C:\Midlertidig_Lagring\spm12\tpm\TPM.nii,1'};
matlabbatch{4}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{4}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{4}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(2).tpm = {'C:\Midlertidig_Lagring\spm12\tpm\TPM.nii,2'};
matlabbatch{4}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{4}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{4}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(3).tpm = {'C:\Midlertidig_Lagring\spm12\tpm\TPM.nii,3'};
matlabbatch{4}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{4}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{4}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(4).tpm = {'C:\Midlertidig_Lagring\spm12\tpm\TPM.nii,4'};
matlabbatch{4}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{4}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{4}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(5).tpm = {'C:\Midlertidig_Lagring\spm12\tpm\TPM.nii,5'};
matlabbatch{4}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{4}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{4}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(6).tpm = {'C:\Midlertidig_Lagring\spm12\tpm\TPM.nii,6'};
matlabbatch{4}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{4}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{4}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{4}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{4}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{4}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{4}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{4}.spm.spatial.preproc.warp.write = [0 1];
matlabbatch{5}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{5}.spm.spatial.normalise.write.subj.resample = niftistonormalize;
matlabbatch{5}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{5}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
matlabbatch{5}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{6}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{6}.spm.spatial.smooth.dtype = 0;
matlabbatch{6}.spm.spatial.smooth.im = 0;
matlabbatch{6}.spm.spatial.smooth.prefix = 's';
matlabbatch{7}.spm.stats.fmri_spec.dir = {strcat(subject_dir,'\1st_level')};
matlabbatch{7}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{7}.spm.stats.fmri_spec.timing.RT = 2.1;
matlabbatch{7}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{7}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
matlabbatch{7}.spm.stats.fmri_spec.sess.scans = niftis2stat;
matlabbatch{7}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{7}.spm.stats.fmri_spec.sess.multi = {onset_file};
matlabbatch{7}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{7}.spm.stats.fmri_spec.sess.multi_reg(1) = cfg_dep('Realign & Unwarp: Realignment Param File (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rpfile'));
matlabbatch{7}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{7}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{7}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{7}.spm.stats.fmri_spec.volt = 1;
matlabbatch{7}.spm.stats.fmri_spec.global = 'None';
matlabbatch{7}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{7}.spm.stats.fmri_spec.mask = {''};
matlabbatch{7}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{8}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{8}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{8}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{9}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{9}.spm.stats.con.consess{1}.tcon.name = 'SucGo';
matlabbatch{9}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{9}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{9}.spm.stats.con.consess{2}.tcon.name = 'SucStop';
matlabbatch{9}.spm.stats.con.consess{2}.tcon.weights = [0 1];
matlabbatch{9}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{9}.spm.stats.con.consess{3}.tcon.name = 'FailStop';
matlabbatch{9}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
matlabbatch{9}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{9}.spm.stats.con.consess{4}.tcon.name = 'SucStop > SucGo';
matlabbatch{9}.spm.stats.con.consess{4}.tcon.weights = [-1 1];
matlabbatch{9}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{9}.spm.stats.con.consess{5}.tcon.name = 'SucGo < SucStop';
matlabbatch{9}.spm.stats.con.consess{5}.tcon.weights = [1 -1];
matlabbatch{9}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{9}.spm.stats.con.consess{6}.tcon.name = 'FailStop < SucGo';
matlabbatch{9}.spm.stats.con.consess{6}.tcon.weights = [-1 0 1];
matlabbatch{9}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{9}.spm.stats.con.consess{7}.tcon.name = 'SucStop < FailStop';
matlabbatch{9}.spm.stats.con.consess{7}.tcon.weights = [0 1 -1];
matlabbatch{9}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{9}.spm.stats.con.consess{8}.tcon.name = 'FailStop < SucStop';
matlabbatch{9}.spm.stats.con.consess{8}.tcon.weights = [0 -1 1];
matlabbatch{9}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
matlabbatch{9}.spm.stats.con.delete = 0;
%%
spm_jobman('run', matlabbatch);
    end
end
%% Saves log file to EPI directory
    cd(EPI_dir);
    QC_filname = strcat('Logfile',timepoint,'.xlsx');
    xlswrite(QC_filname,logfile);