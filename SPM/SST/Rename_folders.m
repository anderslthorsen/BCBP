clear;
cd('\\ihelse.net\forskning\HBE\2015-00936\fMRI-data\T1\T1')
files = dir('*.nii');

for x = 1:length(files)
oldname = files(x,1).name;
newname = oldname(1:11);
movefile(oldname,newname)

end