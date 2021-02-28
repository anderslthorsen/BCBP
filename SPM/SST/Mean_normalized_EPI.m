clear
spm('defaults','fmri');
spm_jobman('initcfg');
%%
matlabbatch{1}.spm.util.imcalc.input = {
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00001_T0\swuaSST_00001_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00003_T0\swuaSST_00003_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00004_T0\swuaSST_00004_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00005_T0\swuaSST_00005_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00006_T0\swuaSST_00006_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00007_T0\swuaSST_00007_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00008_T0\swuaSST_00008_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00009_T0\swuaSST_00009_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00010_T0\swuaSST_00010_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00011_T0\swuaSST_00011_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00012_T0\swuaSST_00012_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00013_T0\swuaSST_00013_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00014_T0\swuaSST_00014_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00015_T0\swuaSST_00015_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00016_T0\swuaSST_00016_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00017_T0\swuaSST_00017_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00018_T0\swuaSST_00018_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00019_T0\swuaSST_00019_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00021_T0\swuaSST_00021_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00022_T0\swuaSST_00022_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00023_T0\swuaSST_00023_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00024_T0\swuaSST_00024_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00026_T0\swuaSST_00026_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00027_T0\swuaSST_00027_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00028_T0\swuaSST_00028_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00029_T0\swuaSST_00029_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00033_T0\swuaSST_00033_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00034_T0\swuaSST_00034_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00035_T0\swuaSST_00035_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00036_T0\swuaSST_00036_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00038_T0\swuaSST_00038_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00041_T0\swuaSST_00041_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00042_T0\swuaSST_00042_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00043_T0\swuaSST_00043_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00044_T0\swuaSST_00044_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00045_T0\swuaSST_00045_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00046_T0\swuaSST_00046_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00047_T0\swuaSST_00047_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00048_T0\swuaSST_00048_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00049_T0\swuaSST_00049_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00050_T0\swuaSST_00050_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00051_T0\swuaSST_00051_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00052_T0\swuaSST_00052_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00053_T0\swuaSST_00053_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00054_T0\swuaSST_00054_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00055_T0\swuaSST_00055_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00056_T0\swuaSST_00056_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00057_T0\swuaSST_00057_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00059_T0\swuaSST_00059_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00060_T0\swuaSST_00060_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00061_T0\swuaSST_00061_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00062_T0\swuaSST_00062_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00063_T0\swuaSST_00063_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00064_T0\swuaSST_00064_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00065_T0\swuaSST_00065_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00066_T0\swuaSST_00066_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00067_T0\swuaSST_00067_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00068_T0\swuaSST_00068_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00069_T0\swuaSST_00069_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00070_T0\swuaSST_00070_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00072_T0\swuaSST_00072_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00074_T0\swuaSST_00074_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00078_T0\swuaSST_00078_T0.nii,1'
                                        '\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\EPI\SST_00080_T0\swuaSST_00080_T0.nii,1'
                                        };
%%
matlabbatch{1}.spm.util.imcalc.output = 'summed_EPIs';
matlabbatch{1}.spm.util.imcalc.outdir = {'\\ihelse.net\forskning\HBE\2015-00936\Data_analysis\SST\QC'};
matlabbatch{1}.spm.util.imcalc.expression = 'sum(X)';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
%%
spm_jobman('run', matlabbatch);