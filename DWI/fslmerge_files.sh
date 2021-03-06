#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, May 2020
# This script reads in predefined text files containing image files and merges them together using fslmerge

# Sets up FSL 5.1.0
export FSLDIR=/home/common/applications/FSL/FSL-5.0.10/
source ${FSLDIR}/etc/fslconf/fsl.sh
export PATH=${FSLDIR}/bin:${PATH}
echo "FSL VERSION: 5.0.10 sourced"

for metric in RD MD AD; do

	# Sets up variables for paths to directories and files
	metric_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/warps/warped_subjects/${metric}
	echo "Current scale is ${metric}"

	# Changes working directory to where the study template is
	cd ${metric_dir}

	# Input text files with all images, where subjects are seperated by one space and NOT a new line
	subject_files_T0=`cat ${metric}_T0_oneline.txt`
	subject_files_T2=`cat ${metric}_T2_oneline.txt`

	#Merge subject images into 4D files
	if [ ! -e "all_${metric}_T0.nii.gz" ]; then
		echo "making all_${metric}_T0"			
		fslmerge -t all_${metric}_T0 ${subject_files_T0}
	else
		echo "all_${metric}_T0 already exists"		
	fi

	if [ ! -e "all_${metric}_T2.nii.gz" ]; then
		echo "making all_${metric}_T2"	
		fslmerge -t all_${metric}_T2 ${subject_files_T2}
	else
		echo "all_${metric}_T2 already exists"	
	fi

done


