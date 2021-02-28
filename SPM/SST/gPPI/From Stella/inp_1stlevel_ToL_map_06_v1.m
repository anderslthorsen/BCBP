%Script for 1stlevel analysis ToL files on my mac.
clear all;
clc;
addpath('/Applications/SPM_12/spm12');
addpath('/Applications/SPM_12/');
savepath;

%Subjects included in ToL analyses (loaded into structures per run/timepoint):
% Run1: x = [1, 3:19, 21:24, 26:29, 33:36, 38, 41:57, 59:70, 72:2:80]
% Run2: x = [1, 3:4, 6:14, 16:18, 21:22, 26, 28:29, 33:36, 42:48, 50:53, 55:57, 59:66, 68,70, 72, 78, 80]
% Run3: x = [1, 3:4, 6:11, 13:14, 16:18, 21:22, 24, 26, 28:29, 33:36, 42:48, 50:51, 53, 55:57, 60:61, 63:66, 68, 70, 72, 78, 80]
% Following IDs are mising: ID20, ID25, 30, 31, 32, 37, 39, 40,58, 71, 73, 75, 77, 79.
% Not included, because part of DCS trial: run1: 2152, 2154, 2156, 2158, 21510, 21512; ...
% run2: 2152, 2154, 2156, 2158, 21510, 21512; run3: 2152, 2154, 2156, 2158, 21510, 21512

% Bergen T0 %1removed since tryout
%subjects{1}=[1, 3:19, 21:24, 26:29, 33:36, 38, 41:57, 59:63, 65:70, 72:2:74, 78,80];

%error cond6 no inputs:run1: x=22; x=65
subjects{1}=[1, 3:19, 21, 23:24, 26:29, 33:36, 38, 41:57, 59:63, 65:70, 72:2:74, 78,80];

% Bergen T1
subjects{2}=[1, 3:4, 6:14, 16:18, 21:22, 26, 28:29, 33:36, ...
    42:48, 50:53, 55:57, 59:66, 68,70, 72, 78, 80];

% Bergen T2
subjects{3}=[1, 3:4, 6:11, 13:14, 16:18, 21:22, 24, 26, 28:29, 33:36, ...
    42:48, 50:51, 53, 55:57, 60:61, 63:66, 68, 70, 72, 78, 80];

% Bergen test
subjects{4}=[1];

% Specify folders with EPIs
inputdir = '/Volumes/Anders EXT/Analysis_ToL/Preprocessing/Preprocessing3/';

%outputdir ='/Volumes/Anders EXT/Analysis_ToL/Preprocessing/Preprocessing3/';
outputdir = '/Volumes/Anders EXT/Analysis_ToL/1stlevels/';

%% Change r (run) for which timepoint you want to preprocess. 1 = T0, 2 = T1, 3 = T2, 4 = test.
%for r = 1:3
for r = 1    
%for x = [1];
        %for x = subjects{1,r}
        for x = [22, 65] %NB run1 x22 and x65 no trials in cond plan5 so 1cond less
        m = [6];
            dirrp = '/Volumes/Anders EXT/Analysis_ToL/Preprocessing/Preprocessing2/';     
            %rp_aTOL_00001_T0.txt

        
        if x < 10
            fn =  strcat(dirrp,'ToL_0000', num2str(x), '_', num2str(r-1), '/rp_aToL_0000', num2str(x), '_T', num2str(r-1), '.txt');
            dir =  strcat(outputdir,'map_0', num2str(m),'/ToL_0000', num2str(x), '_', num2str(r-1), '/');
            odir =  strcat(inputdir,'ToL_0000', num2str(x), '_', num2str(r-1), '/');
            varsfile = strcat(dir,'ToL_iCBT_7cond_vars_00',num2str(x),'_',num2str(r-1),'.mat');
            oEPI = strcat(inputdir,'ToL_0000',num2str(x),'_', num2str(r-1),'/TOL_0000',num2str(x),'_T',num2str(r-1),'.nii');
        else
            fn =  strcat(dirrp,'ToL_000', num2str(x), '_', num2str(r-1), '/rp_aToL_000', num2str(x), '_T', num2str(r-1), '.txt');
            dir =  strcat(outputdir,'map_0', num2str(m),'/ToL_000', num2str(x), '_', num2str(r-1), '/');
            odir =  strcat(inputdir,'/ToL_000', num2str(x), '_', num2str(r-1), '/');
            varsfile = strcat(dir,'ToL_iCBT_7cond_vars_0',num2str(x),'_',num2str(r-1),'.mat');
            oEPI = strcat(inputdir,'ToL_000',num2str(x), '_',num2str(r-1),'/TOL_000',num2str(x),'_T',num2str(r-1),'.nii');
        end
        
        %change to subject-specific directory so that all files are saved there
        cd(dir);
        %define niftis
%         nii = 430;
%         niftis2stat = cell(nii,1);
%         [pathstr1, name1, ext1] = fileparts(oEPI);
%         %niftis2stat1 = strcat(odir,'swua',name1,ext1);
%         %copyfile(niftis2stat1, dir);
%         for i = 1:1:nii
%             niftis2stat{i} = {num2str([odir,'swua',name1,ext1,',' num2str(i)])}';
%         end
%         %niftis(i) = {num2str([odir,'swua',name1,ext1,',' num2str(i)])}';
        %FORMAT [files,dirs] = spm_select('FPList',direc,filt)
        %f = spm_select('FPList', fullfile(data_path,'RawEPI'), '^sM.*\.img$');
        f = spm_select('FPlist', fullfile(odir), '^swua');
        
        %% Sets up SPM environment and Graphics window
        %initialize spm
        spm('Defaults','fMRI');;
        spm_jobman('initcfg');
        %spm('defaults','FMRI');
        spm_figure('GetWin','Graphics');
        
        %         inputs = cell(1,3);
        %         jobs = {'/Volumes/Anders EXT/Analysis_ToL/1stlevels/map_01/firstlevel_map01_ToL_con13_job.m'};
        %
        %         inputs{1} = cellstr(dir);
        %         inputs{2} = niftis2stat; %swuat
        %         inputs{3} = cellstr(varsfile); %cond
        
        %         cellstr(spm_file(f,'prefix','swar'));
        
        % Job saved on 20-May-2019 19:14:01 by cfg_util (rev $Rev: 7345 $)
        % spm SPM - SPM12 (7487)
        % cfg_basicio BasicIO - Unknown
        %-----------------------------------------------------------------------
        %change dir
        matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(dir);
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.1;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
        matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(f);
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess.multi = cellstr(varsfile);
        matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(fn);
        matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
        matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'all plan > baseline';
        if ((x == 22) | (x == 65)) & (r == 1)
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [-4 1 1 1 1 0];
        else
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [-5 1 1 1 1 1 0];
        end
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'plan 1 > baseline';
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'plan 2 > baseline';
        matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [-1 0 1];
        matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'plan 3> baseline:';
        matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [-1 0 0 1];
        matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'plan4 >baseline';
        matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [-1 0 0 0 1];
        matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';   
        matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'plan 5> baseline';
        if ((x == 22) | (x == 65)) & (r == 1)
        matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [-1 0 0 0 1];
        else
        matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [-1 0 0 0 0 1];
        end
        matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'plan1';
        matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [0 1];
        matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'plan2';
        matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [0 0 1];
        matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'plan3';
        matlabbatch{3}.spm.stats.con.consess{9}.tcon.weights = [0 0 0 1];
        matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'plan4';
        matlabbatch{3}.spm.stats.con.consess{10}.tcon.weights = [0 0 0 0 1];
        matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none'; 
        matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 'plan5';
        if ((x == 22) | (x == 65)) & (r == 1)
        matlabbatch{3}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 0 1]
        else
        matlabbatch{3}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 0 0 1];
        end
        matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 'count';
        matlabbatch{3}.spm.stats.con.consess{12}.tcon.weights = 1;
        matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{13}.tcon.name = 'incorrect';
        if ((x == 22) | (x == 65)) & (r == 1)
        matlabbatch{3}.spm.stats.con.consess{13}.tcon.weights = [0 0 0 0 0 1];    
        else
        matlabbatch{3}.spm.stats.con.consess{13}.tcon.weights = [0 0 0 0 0 0 1];
        end
        matlabbatch{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
        %check cons
        matlabbatch{3}.spm.stats.con.consess{14}.tcon.name = 'plan 2>1';
        matlabbatch{3}.spm.stats.con.consess{14}.tcon.weights = [0 -1 1];
        matlabbatch{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{15}.tcon.name = 'plan 3>2';
        matlabbatch{3}.spm.stats.con.consess{15}.tcon.weights = [0 0 -1 1];
        matlabbatch{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{16}.tcon.name = 'plan 4>3';
        matlabbatch{3}.spm.stats.con.consess{16}.tcon.weights = [0 0 0 -1 1];
        matlabbatch{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{17}.tcon.name = 'plan5>4';
        if ((x == 22) | (x == 65)) & (r == 1)
            matlabbatch{3}.spm.stats.con.consess{17}.tcon.weights = [0 0 0 -1 1];
        else
            matlabbatch{3}.spm.stats.con.consess{17}.tcon.weights = [0 0 0 0 -1 1];
        end
        matlabbatch{3}.spm.stats.con.consess{17}.tcon.sessrep = 'none';

        matlabbatch{3}.spm.stats.con.consess{18}.tcon.name = 'par load';
        if ((x == 22) | (x == 65)) & (r == 1)
            matlabbatch{3}.spm.stats.con.consess{18}.tcon.weights = [0 -1.5 -0.5 0.5 1.5 0];
        else
            matlabbatch{3}.spm.stats.con.consess{18}.tcon.weights = [0 -2.5 -1.5 -0.5 1 3.5];
        end
        matlabbatch{3}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
        %matlabbatch{1}.spm.stats.con.delete = 0;
        matlabbatch{3}.spm.stats.con.consess{19}.tcon.name = 'high vs low load';
        if ((x == 22) | (x == 65)) & (r == 1)
            matlabbatch{3}.spm.stats.con.consess{19}.tcon.weights = [0 -1 -1 -1 3];
        else
            matlabbatch{3}.spm.stats.con.consess{19}.tcon.weights = [0 -1 -1 -1 1.5 1.5];
        end
        matlabbatch{3}.spm.stats.con.consess{19}.tcon.sessrep = 'none';   
        matlabbatch{3}.spm.stats.con.consess{20}.tcon.name = 'plan 1>2';
        matlabbatch{3}.spm.stats.con.consess{20}.tcon.weights = [0 1 -1];
        matlabbatch{3}.spm.stats.con.consess{20}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{21}.tcon.name = 'plan 2>3';
        matlabbatch{3}.spm.stats.con.consess{21}.tcon.weights = [0 0 1 -1];
        matlabbatch{3}.spm.stats.con.consess{21}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{22}.tcon.name = 'plan 3>4';
        matlabbatch{3}.spm.stats.con.consess{22}.tcon.weights = [0 0 0 1 -1];
        matlabbatch{3}.spm.stats.con.consess{22}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{23}.tcon.name = 'plan4>5';
        if ((x == 22) | (x == 65)) & (r == 1)
            matlabbatch{3}.spm.stats.con.consess{23}.tcon.weights = [0 0 0 1 -1];
        else
            matlabbatch{3}.spm.stats.con.consess{23}.tcon.weights = [0 0 0 0 1 -1];
        end
        matlabbatch{3}.spm.stats.con.consess{23}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{24}.tcon.name = 'low vs high load';
        if ((x == 22) | (x == 65)) & (r == 1)
            matlabbatch{3}.spm.stats.con.consess{24}.tcon.weights = [0 1 1 1 -3];
        else
            matlabbatch{3}.spm.stats.con.consess{24}.tcon.weights = [0 1 1 1 -1.5 -1.5];
        end
        matlabbatch{3}.spm.stats.con.consess{24}.tcon.sessrep = 'none';  
       
        matlabbatch{3}.spm.stats.con.consess{25}.tcon.name = 'inv par load';
        if ((x == 22) | (x == 65)) & (r == 1)
            matlabbatch{3}.spm.stats.con.consess{25}.tcon.weights = [0 1.5 0.5 -0.5 -1.5 0];
        else
            matlabbatch{3}.spm.stats.con.consess{25}.tcon.weights = [0 2.5 1.5 0.5 -1 -3.5];
        end
        matlabbatch{3}.spm.stats.con.consess{25}.tcon.sessrep = 'none';
        %inv from here
        matlabbatch{3}.spm.stats.con.consess{26}.tcon.name = 'baseline>all plan';
        if ((x == 22) | (x == 65)) & (r == 1)
        matlabbatch{3}.spm.stats.con.consess{26}.tcon.weights = [4 -1 -1 -1 -1 0];
        else
        matlabbatch{3}.spm.stats.con.consess{26}.tcon.weights = [5 -1 -1 -1 -1 -1 0];
        end
        matlabbatch{3}.spm.stats.con.consess{26}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{27}.tcon.name = 'baseline>plan1';
        matlabbatch{3}.spm.stats.con.consess{27}.tcon.weights = [1 -1];
        matlabbatch{3}.spm.stats.con.consess{27}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{28}.tcon.name = 'baseline>plan2';
        matlabbatch{3}.spm.stats.con.consess{28}.tcon.weights = [1 0 -1];
        matlabbatch{3}.spm.stats.con.consess{28}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{29}.tcon.name = 'baseline>plan 3';
        matlabbatch{3}.spm.stats.con.consess{29}.tcon.weights = [1 0 0 -1];
        matlabbatch{3}.spm.stats.con.consess{29}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{30}.tcon.name = 'baseline>plan4';
        matlabbatch{3}.spm.stats.con.consess{30}.tcon.weights = [1 0 0 0 -1];
        matlabbatch{3}.spm.stats.con.consess{30}.tcon.sessrep = 'none';   
        matlabbatch{3}.spm.stats.con.consess{31}.tcon.name = 'baseline>plan 5 ';
        if ((x == 22) | (x == 65)) & (r == 1)
        matlabbatch{3}.spm.stats.con.consess{31}.tcon.weights = [1 0 0 0 -1];
        else
        matlabbatch{3}.spm.stats.con.consess{31}.tcon.weights = [1 0 0 0 0 -1];
        end
        matlabbatch{3}.spm.stats.con.consess{31}.tcon.sessrep = 'none';
        
        
        matlabbatch{3}.spm.stats.con.delete = 0;
        spm_jobman('run',matlabbatch);
        
        %spm_jobman('run', jobs, inputs{:});
        
        clearvars -except subjects inputdir outputdir r x m;
    end
end