#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, March 2020
# This script will rerun affine and diffeomorphic registrations between a set of images to a predefined template(intra- or inter-subject). This can be used if you need to re-register a subject to a template without rerunning full template reconstruction.

#########################################
# Setup relevant software and variables
#########################################

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

# Sets up variables for folder with tensor images from all subjects and recommended template from DTI-TK
	tensor_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject
	template=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/mean_diffeomorphic_initial6.nii.gz

# load list of participants for within-subject registration. This list points to subject-specific text files with filenames required by DTI-TK.
	cd ${tensor_dir}

	
	#if [-e "subjs_aff.txt" ]; then
	#rm subjs_aff.txt
	#fi

	#for subj in 00001 00016; do 

	#dti_rigid_sn ${template} ${subj}.txt EDS
	
	#ls | grep "${subj}_mean_intra_template_aff.nii.gz" >> subjs_aff.txt
	
	#done
	
dti_diffeomorphic_sn ${template} subjs_aff.txt mask.nii.gz 6 0.002
	
	


	


