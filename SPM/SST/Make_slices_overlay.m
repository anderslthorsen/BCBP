%% Script to generate slices of an image overlaid on structural/template T1
%clear
%clc

% EPI = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\EPI_corrected_slicetiming\SST_00001_T2\SST_00001_T2.nii';
% T1 =     '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\T1\T1_00001_T2\T1_00001_T0.nii';

%input = {T1, EPI};


%so = slover(input);
%paint(so)


%slover(EPI)

% %%
% P1 = spm_get(1,'*.img','Specify background image');
% P2 = spm_get(1,'*.img','Specify blobs image');
%  
% % Clear graphics window..
% spm_clf
%  
% % Display background image..
% h = spm_orthviews('Image', P1,[0.05 0.05 0.9 0.9]);
%  
% % Display blobs in red.  Use [0 1 0] for green, [0 0 1] for blue
% % [0.6 0 0.8] for purple etc..
% spm_orthviews('AddColouredImage', h, P2,[1 0 0]);
%  
% % Update the display..
% spm_orthviews('Redraw');

%%
clear
EPI_dir = '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\SST\EPI_corrected_slicetiming\SST_00001_T0';
T1_dir =  '\\ihelse.net\Forskning\HBE\2015-00936\Data_analysis\T1\T1_00001_T0';


%spm_get('Files', T1_dir, 'T1*.nii')
%spm_get('Files', EPI_dir, 'uaSST*.nii')


P1 = spm_get('Files', T1_dir, 'T1*.nii');
P2 = spm_get('Files', EPI_dir, 'uaSST*.nii,1');
 
% Clear graphics window..
spm_clf
 
% Display background image..
%h = spm_orthviews('Image', P1,[0.05 0.05 0.9 0.9]);
h = spm_orthviews('Image', P1);
 
% Display blobs in red.  Use [0 1 0] for green, [0 0 1] for blue
% [0.6 0 0.8] for purple etc..
spm_orthviews('AddColouredImage', h, P2,[1 0 0]);
 
% Update the display..
spm_orthviews('Redraw');