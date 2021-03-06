#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, March 2020
# This scripts loads up the JHU atlas labels in template space and overlays it on each subject's FA image

#########################################
# Setup relevant software and variables
#########################################

# source FSL 5.1.0
	export FSLDIR=/home/common/applications/FSL/FSL-5.0.10/
	source ${FSLDIR}/etc/fslconf/fsl.sh
	export PATH=${FSLDIR}/bin:${PATH}
	echo "FSL VERSION: 5.0.10 sourced"

# Sets up variables for folder with tensor images from all subjects and recommended template from DTI-TK
	tensor_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/warps/warped_subjects/FA

cd ${tensor_dir}

	for subj in `cat FA_files_vilde.txt`; do 
fslview ${subj} ../atlas/JHU_labels_in_template_ero_2mm.nii.gz -l "Random-Rainbow" -t 0.5
#fslview ${subj} ../atlas/JHU_labels_in_template_ero.nii.gz -l "Random-Rainbow" -t 0.5
#fslview ${subj} ../atlas/JHU_labels_thr25_in_template.nii.gz -l "Random-Rainbow" -t 0.5
#fslview ${subj} ../atlas/JHU_labels_in_template.nii.gz -l "Random-Rainbow" -t 0.5

done

fslmaths JHU_labels_in_template.nii.gz -ero JHU_labels_in_template_ero.nii.gz

fslmaths JHU_labels_in_template.nii.gz -kernel sphere 2 -ero JHU_labels_in_template_ero_2mm.nii.gz
