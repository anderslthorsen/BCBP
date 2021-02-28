#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, April 2020


# Sets up DTI-TK and FSL
dtitkdir=/home/common/applications/dtitk/dtitk-2.3.1
export PATH="/home/common/applications/dtitk/dtitk-2.3.1/bin:${PATH}"
export PATH="/home/common/applications/dtitk/dtitk-2.3.1/utilities:${PATH}"
export PATH="/home/common/applications/dtitk/dtitk-2.3.1/scripts:${PATH}"
export DTITK_ROOT=/home/common/applications/dtitk/dtitk-2.3.1/
echo "DTI-TK sourced"

# source FSL 5.1.0
export FSLDIR=/home/common/applications/FSL/FSL-5.0.10/
source ${FSLDIR}/etc/fslconf/fsl.sh
export PATH=${FSLDIR}/bin:${PATH}
echo "FSL VERSION: 5.0.10 sourced"

# Sets up variables for paths to directories and files
warped_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/warps/warped_subjects

# changes working directory to where the study template is
cd ${warped_dir}

# Creates mean DTI-TK image and converts it to FA
#TVMean -in warped_subjects.txt -out mean_final_high_res.nii.gz
#TVtool -in mean_final_high_res.nii.gz -fa

# Do for all warped images
for subj in `cat warped_subjects.txt`; do

	# Convert DTI-TK images to each DTI scalar
	#TVtool -in ${subj} -fa
	TVtool -in ${subj} -tr
	TVtool -in ${subj} -ad
	TVtool -in ${subj} -rd
	TVtool -in ${subj} -pd
	TVtool -in ${subj} -rgb


done
