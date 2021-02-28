%% Script for iteratively displaying 1st level mask on MNI template in MRIcron on Windows
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
subjects{4}=[9];

%% Fixed variables
EPI_dir = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\EPI_corrected_slicetiming\';
mricron = '%respfdir%\pwrgate.exe 3242';
template = ' .\templates\ch2better.nii.gz';

%% Loop for defining variables and starting MRIcron
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
            mask = strcat(EPI_dir,'SST_0000',num2str(x),timepoint,'\1st_level\mask.nii');
            overlay = char(strcat(' -o',{' '},mask)); 
        elseif x < 100
            mask = strcat(EPI_dir,'SST_000',num2str(x),timepoint,'\1st_level\mask.nii');
            overlay = char(strcat(' -o',{' '},mask)); 
        end
        
     % Starts MRICron and displays participant number and timepoint   
     dos(strcat(mricron, template, overlay));
     disp(strcat(num2str(x),timepoint))
    end
end