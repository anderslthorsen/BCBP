clear
clc
%% Script changes the paths in SPM batches to reflect new modelig of three conditions, as well as modeling FailStop>SucStop contrast for connectivity
matfiles.SucStop_minus_SucGo = {
    '\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Analyses_for_publication\Batches\gPPI\3_conds\SucStop_minus_SucGo\Amygdala_ANOVA_OCD31_HC28.mat', ...
    '\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Analyses_for_publication\Batches\gPPI\3_conds\SucStop_minus_SucGo\L_Amygdala_T0_OCD31_HC28.mat', ...
    '\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Analyses_for_publication\Batches\gPPI\3_conds\SucStop_minus_SucGo\MRM_Amygdala_OCD24_HC19.mat', ...
    '\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Analyses_for_publication\Batches\gPPI\3_conds\SucStop_minus_SucGo\R_Amygdala_T0_OCD31_HC28.mat', ...
    '\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Analyses_for_publication\Batches\gPPI\3_conds\SucStop_minus_SucGo\SPM_Bil_Amygdala_Completers_OCD24_HC19.mat'};

matfiles.FailStop_minus_SucStop = {
'\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Analyses_for_publication\Batches\gPPI\3_conds\FailStop_minus_SucStop\Amygdala_ANOVA_OCD31_HC28.mat' ...
'\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Analyses_for_publication\Batches\gPPI\3_conds\FailStop_minus_SucStop\L_Amygdala_T0_OCD31_HC28.mat' ...
'\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Analyses_for_publication\Batches\gPPI\3_conds\FailStop_minus_SucStop\MRM_Amygdala_OCD24_HC19.mat' ...
'\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Analyses_for_publication\Batches\gPPI\3_conds\FailStop_minus_SucStop\R_Amygdala_T0_OCD31_HC28.mat' ...
'\\ihelse.net\forskning\hbe\2015-00936\Data_analysis\SST\Analyses_for_publication\Batches\gPPI\3_conds\FailStop_minus_SucStop\SPM_Bil_Amygdala_Completers_OCD24_HC19.mat'};

% % Changes path to reflect modeling of three condtions
% for i = 1:length(matfiles.SucStop_minus_SucGo)
%     oldpath = 'gPPI_omnibus';
%     newpath = 'gPPI_omnibus_3conds';
%     spm_changepath(char(matfiles.SucStop_minus_SucGo(i)), oldpath, newpath);
%     
%     %disp(matfiles.SucStop_minus_SucGo(i))
% end

% Changes path to reflect modeling of three condtions
for i = 1:length(matfiles.FailStop_minus_SucStop)
    oldpath = 'gPPI_omnibus';
    newpath = 'gPPI_omnibus_3conds';
    spm_changepath(char(matfiles.FailStop_minus_SucStop(i)), oldpath, newpath);
end

% Changes path to reflect modeling of FailStop>SucStop contrast
for i = 1:length(matfiles.FailStop_minus_SucStop)
    oldpath = 'con_PPI_SucStop_minus_SucGo_subject.nii';
    newpath = 'con_PPI_FailStop_minus_SucStop_subject.nii';
    spm_changepath(char(matfiles.FailStop_minus_SucStop(i)), oldpath, newpath);
end