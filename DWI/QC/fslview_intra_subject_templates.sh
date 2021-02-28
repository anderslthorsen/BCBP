#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, March 2020
# This scripts loads up the two registered DWI images for each subject overlaid on the within-subject template

#########################################
# Setup relevant software and variables
#########################################

# Sets up DTI-TK and FSL
#	dtitkdir=/home/common/applications/dtitk/dtitk-2.3.1
#	export PATH="/home/common/applications/dtitk/dtitk-2.3.1/bin:${PATH}"
#	export PATH="/home/common/applications/dtitk/dtitk-2.3.1/utilities:${PATH}"
#	export PATH="/home/common/applications/dtitk/dtitk-2.3.1/scripts:${PATH}"
#	export DTITK_ROOT=/home/common/applications/dtitk/dtitk-2.3.1/
#	echo "DTI-TK sourced"

# source FSL 5.1.0
	export FSLDIR=/home/common/applications/FSL/FSL-5.0.10/
	source ${FSLDIR}/etc/fslconf/fsl.sh
	export PATH=${FSLDIR}/bin:${PATH}
	echo "FSL VERSION: 5.0.10 sourced"

# Sets up variables for folder with tensor images from all subjects and recommended template from DTI-TK
	tensor_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors

cd ${tensor_dir}

	for subj in `cat subj_complete_data.txt`; do 
#	for subj in `cat subjects_intra.txt`; do 

	cd ${tensor_dir}/tensor_${subj}

#fslview ${subj} 00001_mean_intra_template.nii.gz 00001_T0_combined.nii.gz 00001_T2_combined.nii.gz

fslview ${subj}_mean_intra_template.nii.gz ${subj}_T0_combined.nii.gz -l "Blue" -t 0.5 ${subj}_T2_combined.nii.gz -l "Red" -t 0.5

done
