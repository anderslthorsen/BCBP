% Script for preprocessing SST files in Bergen. This is a standard pipeline
% with slice time correction, realignment and unwarping, normalizing to MNI
% via the mean EPI (3mm voxels), and smoothing (8mm kernel). All other
% settings are default.

% REMEMBER THAT SST_00004_T2 og SST_00013_T2 have 35 slices (this also affects the TA). 
% All EPIs have 430 volumes.

clear

% Bergen T0
subjects{1}=[23 24 26 27 28 29 33 34 35 36       ...
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
subjects{4}=[1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 21 22 23 24 26 27 28 29 33 34 35 36       ...
    38 41 42 43 44 45 46 47 48 49       ...
    50 51 52 53 54 55 56 57 59 60       ...
    61 62 63 64 65 66 67 68 69 70       ...
    72 74 78 80];

% Specify folders with EPIs
EPI_dir = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\EPI_reorient_MNI\';
%EPI_dir = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\EPI_unified_retest_20March19\';

%% Change S for which timepoint you want to preprocess. 1 = T0, 2 = T1, 3 = T2, 4 = test.
for S = 4
    for x = subjects{1,S}
        clearvars -except subjects EPI_dir S x
        
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
            onset_file = strcat(EPI_dir,'SST_0000',num2str(x),timepoint,'\behavior_0000',num2str(x),timepoint,'.mat');
            movement_file = strcat(EPI_dir,'SST_0000',num2str(x),timepoint,'\rp_aSST_0000',num2str(x),timepoint,'.txt');
        elseif x < 100
            fn = strcat(EPI_dir,'SST_000',num2str(x),timepoint,'\swuaSST_000',num2str(x),timepoint,'.nii');
            subject_dir = strcat(EPI_dir,'SST_000',num2str(x),timepoint);
            onset_file = strcat(EPI_dir,'SST_000',num2str(x),timepoint,'\behavior_000',num2str(x),timepoint,'.mat');
            movement_file = strcat(EPI_dir,'SST_000',num2str(x),timepoint,'\rp_aSST_000',num2str(x),timepoint,'.txt');
        end
        
cd(subject_dir);        
        
%% Sets up SPM environment and Graphics window
    spm_jobman('initcfg');
    spm('defaults','FMRI');
    spm_figure('GetWin','Graphics');
%%
matlabbatch{1}.spm.stats.fmri_spec.dir = {strcat(subject_dir,'\1st_level')};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.1;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
%%
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {
                                        strcat(fn,',1')
                                        strcat(fn,',2')
                                        strcat(fn,',3')
                                        strcat(fn,',4')
                                        strcat(fn,',5')
                                        strcat(fn,',6')
                                        strcat(fn,',7')
                                        strcat(fn,',8')
                                        strcat(fn,',9')
                                        strcat(fn,',10')
                                        strcat(fn,',11')
                                        strcat(fn,',12')
                                        strcat(fn,',13')
                                        strcat(fn,',14')
                                        strcat(fn,',15')
                                        strcat(fn,',16')
                                        strcat(fn,',17')
                                        strcat(fn,',18')
                                        strcat(fn,',19')
                                        strcat(fn,',20')
                                        strcat(fn,',21')
                                        strcat(fn,',22')
                                        strcat(fn,',23')
                                        strcat(fn,',24')
                                        strcat(fn,',25')
                                        strcat(fn,',26')
                                        strcat(fn,',27')
                                        strcat(fn,',28')
                                        strcat(fn,',29')
                                        strcat(fn,',30')
                                        strcat(fn,',31')
                                        strcat(fn,',32')
                                        strcat(fn,',33')
                                        strcat(fn,',34')
                                        strcat(fn,',35')
                                        strcat(fn,',36')
                                        strcat(fn,',37')
                                        strcat(fn,',38')
                                        strcat(fn,',39')
                                        strcat(fn,',40')
                                        strcat(fn,',41')
                                        strcat(fn,',42')
                                        strcat(fn,',43')
                                        strcat(fn,',44')
                                        strcat(fn,',45')
                                        strcat(fn,',46')
                                        strcat(fn,',47')
                                        strcat(fn,',48')
                                        strcat(fn,',49')
                                        strcat(fn,',50')
                                        strcat(fn,',51')
                                        strcat(fn,',52')
                                        strcat(fn,',53')
                                        strcat(fn,',54')
                                        strcat(fn,',55')
                                        strcat(fn,',56')
                                        strcat(fn,',57')
                                        strcat(fn,',58')
                                        strcat(fn,',59')
                                        strcat(fn,',60')
                                        strcat(fn,',61')
                                        strcat(fn,',62')
                                        strcat(fn,',63')
                                        strcat(fn,',64')
                                        strcat(fn,',65')
                                        strcat(fn,',66')
                                        strcat(fn,',67')
                                        strcat(fn,',68')
                                        strcat(fn,',69')
                                        strcat(fn,',70')
                                        strcat(fn,',71')
                                        strcat(fn,',72')
                                        strcat(fn,',73')
                                        strcat(fn,',74')
                                        strcat(fn,',75')
                                        strcat(fn,',76')
                                        strcat(fn,',77')
                                        strcat(fn,',78')
                                        strcat(fn,',79')
                                        strcat(fn,',80')
                                        strcat(fn,',81')
                                        strcat(fn,',82')
                                        strcat(fn,',83')
                                        strcat(fn,',84')
                                        strcat(fn,',85')
                                        strcat(fn,',86')
                                        strcat(fn,',87')
                                        strcat(fn,',88')
                                        strcat(fn,',89')
                                        strcat(fn,',90')
                                        strcat(fn,',91')
                                        strcat(fn,',92')
                                        strcat(fn,',93')
                                        strcat(fn,',94')
                                        strcat(fn,',95')
                                        strcat(fn,',96')
                                        strcat(fn,',97')
                                        strcat(fn,',98')
                                        strcat(fn,',99')
                                        strcat(fn,',100')
                                        strcat(fn,',101')
                                        strcat(fn,',102')
                                        strcat(fn,',103')
                                        strcat(fn,',104')
                                        strcat(fn,',105')
                                        strcat(fn,',106')
                                        strcat(fn,',107')
                                        strcat(fn,',108')
                                        strcat(fn,',109')
                                        strcat(fn,',110')
                                        strcat(fn,',111')
                                        strcat(fn,',112')
                                        strcat(fn,',113')
                                        strcat(fn,',114')
                                        strcat(fn,',115')
                                        strcat(fn,',116')
                                        strcat(fn,',117')
                                        strcat(fn,',118')
                                        strcat(fn,',119')
                                        strcat(fn,',120')
                                        strcat(fn,',121')
                                        strcat(fn,',122')
                                        strcat(fn,',123')
                                        strcat(fn,',124')
                                        strcat(fn,',125')
                                        strcat(fn,',126')
                                        strcat(fn,',127')
                                        strcat(fn,',128')
                                        strcat(fn,',129')
                                        strcat(fn,',130')
                                        strcat(fn,',131')
                                        strcat(fn,',132')
                                        strcat(fn,',133')
                                        strcat(fn,',134')
                                        strcat(fn,',135')
                                        strcat(fn,',136')
                                        strcat(fn,',137')
                                        strcat(fn,',138')
                                        strcat(fn,',139')
                                        strcat(fn,',140')
                                        strcat(fn,',141')
                                        strcat(fn,',142')
                                        strcat(fn,',143')
                                        strcat(fn,',144')
                                        strcat(fn,',145')
                                        strcat(fn,',146')
                                        strcat(fn,',147')
                                        strcat(fn,',148')
                                        strcat(fn,',149')
                                        strcat(fn,',150')
                                        strcat(fn,',151')
                                        strcat(fn,',152')
                                        strcat(fn,',153')
                                        strcat(fn,',154')
                                        strcat(fn,',155')
                                        strcat(fn,',156')
                                        strcat(fn,',157')
                                        strcat(fn,',158')
                                        strcat(fn,',159')
                                        strcat(fn,',160')
                                        strcat(fn,',161')
                                        strcat(fn,',162')
                                        strcat(fn,',163')
                                        strcat(fn,',164')
                                        strcat(fn,',165')
                                        strcat(fn,',166')
                                        strcat(fn,',167')
                                        strcat(fn,',168')
                                        strcat(fn,',169')
                                        strcat(fn,',170')
                                        strcat(fn,',171')
                                        strcat(fn,',172')
                                        strcat(fn,',173')
                                        strcat(fn,',174')
                                        strcat(fn,',175')
                                        strcat(fn,',176')
                                        strcat(fn,',177')
                                        strcat(fn,',178')
                                        strcat(fn,',179')
                                        strcat(fn,',180')
                                        strcat(fn,',181')
                                        strcat(fn,',182')
                                        strcat(fn,',183')
                                        strcat(fn,',184')
                                        strcat(fn,',185')
                                        strcat(fn,',186')
                                        strcat(fn,',187')
                                        strcat(fn,',188')
                                        strcat(fn,',189')
                                        strcat(fn,',190')
                                        strcat(fn,',191')
                                        strcat(fn,',192')
                                        strcat(fn,',193')
                                        strcat(fn,',194')
                                        strcat(fn,',195')
                                        strcat(fn,',196')
                                        strcat(fn,',197')
                                        strcat(fn,',198')
                                        strcat(fn,',199')
                                        strcat(fn,',200')
                                        strcat(fn,',201')
                                        strcat(fn,',202')
                                        strcat(fn,',203')
                                        strcat(fn,',204')
                                        strcat(fn,',205')
                                        strcat(fn,',206')
                                        strcat(fn,',207')
                                        strcat(fn,',208')
                                        strcat(fn,',209')
                                        strcat(fn,',210')
                                        strcat(fn,',211')
                                        strcat(fn,',212')
                                        strcat(fn,',213')
                                        strcat(fn,',214')
                                        strcat(fn,',215')
                                        strcat(fn,',216')
                                        strcat(fn,',217')
                                        strcat(fn,',218')
                                        strcat(fn,',219')
                                        strcat(fn,',220')
                                        strcat(fn,',221')
                                        strcat(fn,',222')
                                        strcat(fn,',223')
                                        strcat(fn,',224')
                                        strcat(fn,',225')
                                        strcat(fn,',226')
                                        strcat(fn,',227')
                                        strcat(fn,',228')
                                        strcat(fn,',229')
                                        strcat(fn,',230')
                                        strcat(fn,',231')
                                        strcat(fn,',232')
                                        strcat(fn,',233')
                                        strcat(fn,',234')
                                        strcat(fn,',235')
                                        strcat(fn,',236')
                                        strcat(fn,',237')
                                        strcat(fn,',238')
                                        strcat(fn,',239')
                                        strcat(fn,',240')
                                        strcat(fn,',241')
                                        strcat(fn,',242')
                                        strcat(fn,',243')
                                        strcat(fn,',244')
                                        strcat(fn,',245')
                                        strcat(fn,',246')
                                        strcat(fn,',247')
                                        strcat(fn,',248')
                                        strcat(fn,',249')
                                        strcat(fn,',250')
                                        strcat(fn,',251')
                                        strcat(fn,',252')
                                        strcat(fn,',253')
                                        strcat(fn,',254')
                                        strcat(fn,',255')
                                        strcat(fn,',256')
                                        strcat(fn,',257')
                                        strcat(fn,',258')
                                        strcat(fn,',259')
                                        strcat(fn,',260')
                                        strcat(fn,',261')
                                        strcat(fn,',262')
                                        strcat(fn,',263')
                                        strcat(fn,',264')
                                        strcat(fn,',265')
                                        strcat(fn,',266')
                                        strcat(fn,',267')
                                        strcat(fn,',268')
                                        strcat(fn,',269')
                                        strcat(fn,',270')
                                        strcat(fn,',271')
                                        strcat(fn,',272')
                                        strcat(fn,',273')
                                        strcat(fn,',274')
                                        strcat(fn,',275')
                                        strcat(fn,',276')
                                        strcat(fn,',277')
                                        strcat(fn,',278')
                                        strcat(fn,',279')
                                        strcat(fn,',280')
                                        strcat(fn,',281')
                                        strcat(fn,',282')
                                        strcat(fn,',283')
                                        strcat(fn,',284')
                                        strcat(fn,',285')
                                        strcat(fn,',286')
                                        strcat(fn,',287')
                                        strcat(fn,',288')
                                        strcat(fn,',289')
                                        strcat(fn,',290')
                                        strcat(fn,',291')
                                        strcat(fn,',292')
                                        strcat(fn,',293')
                                        strcat(fn,',294')
                                        strcat(fn,',295')
                                        strcat(fn,',296')
                                        strcat(fn,',297')
                                        strcat(fn,',298')
                                        strcat(fn,',299')
                                        strcat(fn,',300')
                                        strcat(fn,',301')
                                        strcat(fn,',302')
                                        strcat(fn,',303')
                                        strcat(fn,',304')
                                        strcat(fn,',305')
                                        strcat(fn,',306')
                                        strcat(fn,',307')
                                        strcat(fn,',308')
                                        strcat(fn,',309')
                                        strcat(fn,',310')
                                        strcat(fn,',311')
                                        strcat(fn,',312')
                                        strcat(fn,',313')
                                        strcat(fn,',314')
                                        strcat(fn,',315')
                                        strcat(fn,',316')
                                        strcat(fn,',317')
                                        strcat(fn,',318')
                                        strcat(fn,',319')
                                        strcat(fn,',320')
                                        strcat(fn,',321')
                                        strcat(fn,',322')
                                        strcat(fn,',323')
                                        strcat(fn,',324')
                                        strcat(fn,',325')
                                        strcat(fn,',326')
                                        strcat(fn,',327')
                                        strcat(fn,',328')
                                        strcat(fn,',329')
                                        strcat(fn,',330')
                                        strcat(fn,',331')
                                        strcat(fn,',332')
                                        strcat(fn,',333')
                                        strcat(fn,',334')
                                        strcat(fn,',335')
                                        strcat(fn,',336')
                                        strcat(fn,',337')
                                        strcat(fn,',338')
                                        strcat(fn,',339')
                                        strcat(fn,',340')
                                        strcat(fn,',341')
                                        strcat(fn,',342')
                                        strcat(fn,',343')
                                        strcat(fn,',344')
                                        strcat(fn,',345')
                                        strcat(fn,',346')
                                        strcat(fn,',347')
                                        strcat(fn,',348')
                                        strcat(fn,',349')
                                        strcat(fn,',350')
                                        strcat(fn,',351')
                                        strcat(fn,',352')
                                        strcat(fn,',353')
                                        strcat(fn,',354')
                                        strcat(fn,',355')
                                        strcat(fn,',356')
                                        strcat(fn,',357')
                                        strcat(fn,',358')
                                        strcat(fn,',359')
                                        strcat(fn,',360')
                                        strcat(fn,',361')
                                        strcat(fn,',362')
                                        strcat(fn,',363')
                                        strcat(fn,',364')
                                        strcat(fn,',365')
                                        strcat(fn,',366')
                                        strcat(fn,',367')
                                        strcat(fn,',368')
                                        strcat(fn,',369')
                                        strcat(fn,',370')
                                        strcat(fn,',371')
                                        strcat(fn,',372')
                                        strcat(fn,',373')
                                        strcat(fn,',374')
                                        strcat(fn,',375')
                                        strcat(fn,',376')
                                        strcat(fn,',377')
                                        strcat(fn,',378')
                                        strcat(fn,',379')
                                        strcat(fn,',380')
                                        strcat(fn,',381')
                                        strcat(fn,',382')
                                        strcat(fn,',383')
                                        strcat(fn,',384')
                                        strcat(fn,',385')
                                        strcat(fn,',386')
                                        strcat(fn,',387')
                                        strcat(fn,',388')
                                        strcat(fn,',389')
                                        strcat(fn,',390')
                                        strcat(fn,',391')
                                        strcat(fn,',392')
                                        strcat(fn,',393')
                                        strcat(fn,',394')
                                        strcat(fn,',395')
                                        strcat(fn,',396')
                                        strcat(fn,',397')
                                        strcat(fn,',398')
                                        strcat(fn,',399')
                                        strcat(fn,',400')
                                        strcat(fn,',401')
                                        strcat(fn,',402')
                                        strcat(fn,',403')
                                        strcat(fn,',404')
                                        strcat(fn,',405')
                                        strcat(fn,',406')
                                        strcat(fn,',407')
                                        strcat(fn,',408')
                                        strcat(fn,',409')
                                        strcat(fn,',410')
                                        strcat(fn,',411')
                                        strcat(fn,',412')
                                        strcat(fn,',413')
                                        strcat(fn,',414')
                                        strcat(fn,',415')
                                        strcat(fn,',416')
                                        strcat(fn,',417')
                                        strcat(fn,',418')
                                        strcat(fn,',419')
                                        strcat(fn,',420')
                                        strcat(fn,',421')
                                        strcat(fn,',422')
                                        strcat(fn,',423')
                                        strcat(fn,',424')
                                        strcat(fn,',425')
                                        strcat(fn,',426')
                                        strcat(fn,',427')
                                        strcat(fn,',428')
                                        strcat(fn,',429')
                                        strcat(fn,',430')
                                                 };
%%
matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {onset_file};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {movement_file};
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
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'SucGo';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'SucStop';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'FailStop';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'SucStop > SucGo';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'SucGo < SucStop';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'FailStop < SucGo';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [-1 0 1];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'SucStop < FailStop';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [0 1 -1];
matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'FailStop < SucStop';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [0 -1 1];
matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
%%
    spm_jobman('run', matlabbatch);
    end
end