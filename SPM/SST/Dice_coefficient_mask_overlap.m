%% Script for counting number of voxels in 1st level mask
clear
clc

% Bergen T0
subjects{1}=[1 3 4 5 6 7 8 9 10 11 12 13         ...
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

spm_jobman('initcfg');
spm('defaults','FMRI');

%% Fixed variables
EPI_dir = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\EPI_corrected_slicetiming\';
ROI_dir = '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\ROIs\';

% Defining ROIs in table
ROI_names = {'L_amygdala';'R_amygdala';'L_Pre-SMA';'R_Pre-SMA';'R_IFG_orbitalis'};
ROI_files = {strcat(ROI_dir, 'rL_amygdala.nii');strcat(ROI_dir, 'rR_amygdala.nii'); ...
    strcat(ROI_dir, 'rL_Pre-SMA.nii');strcat(ROI_dir, 'rR_Pre-SMA.nii');strcat(ROI_dir, 'rR_IFG_orbitalis.nii')};

%% Looping over subjects
for S = 3
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
        
        
        % Defining 1st level masks
        if x < 10
            mask = strcat(EPI_dir,'SST_0000',num2str(x),timepoint,'\1st_level\mask.nii');
            subject_dir = strcat(EPI_dir,'SST_0000',num2str(x),timepoint,'\voxel_count\');
        elseif x < 100
            mask = strcat(EPI_dir,'SST_000',num2str(x),timepoint,'\1st_level\mask.nii');
            subject_dir = strcat(EPI_dir,'SST_000',num2str(x),timepoint,'\voxel_count\');
        end
        
        
        subject_files = {strcat(subject_dir, 'L_amygdala.nii');strcat(subject_dir, 'R_amygdala.nii'); ...
            strcat(subject_dir, 'L_Pre-SMA.nii');strcat(subject_dir, 'R_Pre-SMA.nii');strcat(subject_dir, 'R_IFG_orbitalis.nii')};
        
        ROI = table(ROI_names,ROI_files,subject_files);
        
        cd(subject_dir);
        
        
        
        % Create subject-level ROIs masked by 1st level mask
        for i = 1:height(ROI)
            if exist(char(strcat(ROI.ROI_names(i),'.nii')), 'file') % if there is already a ROI image for this person, move on
            else
                matlabbatch{1}.spm.util.imcalc.input = {
                    mask
                    char(ROI.ROI_files(i))
                    };
                matlabbatch{1}.spm.util.imcalc.output = char(ROI.ROI_names(i));
                matlabbatch{1}.spm.util.imcalc.outdir = {subject_dir};
                matlabbatch{1}.spm.util.imcalc.expression = 'i2.*(i1>0.9)';
                matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
                matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
                matlabbatch{1}.spm.util.imcalc.options.mask = 0;
                matlabbatch{1}.spm.util.imcalc.options.interp = 0;
                matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
                spm_jobman('run', matlabbatch);
            end
        end
        
        % Count number of voxels per ROI per subjecs
        similarity{1,1} = 'Participant';
        similarity{1,2} = 'L_amygdala';
        similarity{1,3} = 'R_amygdala';
        similarity{1,4} = 'L_Pre-SMA';
        similarity{1,5} = 'R_Pre-SMA';
        similarity{1,6} = 'R_IFG_orbitalis';
        
        
        %         voxel_count{2,1} = 'Resliced AAL template 3mm';
        %         voxel_count{2,2} = sum(char(ROI.ROI_files(1)));
        %         voxel_count{2,3} = sum(char(ROI.ROI_files(2)));
        %         voxel_count{2,4} = sum(char(ROI.ROI_files(3)));
        %         voxel_count{2,5} = sum(char(ROI.ROI_files(4)));
        
        for i = 1:height(ROI)
            similarity{x+2,1} = strcat(num2str(x), timepoint);
            similarity{x+2,i+1} = nii_dice((char(ROI.ROI_files(i))), (char(ROI.subject_files(i))));
        end
    end
end

results = similarity;
    cd(EPI_dir);
    time = datestr(now,'dd.mm.yyyy-HH.MM');
    mask_similarity = strcat('Similarity logfile',timepoint,'-',time,'.xlsx');
    xlswrite(mask_similarity,similarity);
