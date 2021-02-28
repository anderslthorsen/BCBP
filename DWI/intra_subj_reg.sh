#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, March 2020
# This script will register two longitudinal DTI volumes to a common within-subject template. The within-subject template can then be used to register mutliple subjects to each other. A key benefit of this approach is that you minimize the number of transformations of the data, rather than adding extra interpolations when tranforming between time points (within subject) and between subjects. URL of manual is available here (http://dti-tk.sourceforge.net/pmwiki/pmwiki.php?n=Documentation.HomePage) and useful online discussion with code is available here (https://groups.google.com/forum/#!topic/dtitk/ciF3INwnGt8)

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
	tensor_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors
	templatedir=/home/common/applications/dtitk/ixi_aging_template_v3.0/template

# load list of participants for within-subject registration. This list points to subject-specific text files with filenames required by DTI-TK.
	cd ${tensor_dir}

	for subj in `cat subj_complete_data.txt`; do 

	cd ${tensor_dir}/tensor_${subj}

#########################################
# Performs initial construction of the subject-specific template
#########################################

if [ ! -e "${subj}_mean_initial.nii.gz" ]; then
	dti_template_bootstrap ${templatedir}/ixi_aging_template.nii.gz ${subj}.txt EDS
	mv mean_initial.nii.gz ${subj}_mean_initial.nii.gz
	echo "running intial template construction"	
	else
	echo "template bootstrapping has already been run"
fi

#########################################
# Performs first affine (linear) registration of subject images to subject-specific template (named ${subj}_mean_affine3.nii.gz)
#########################################

if [ ! -e "${subj}_mean_affine3.nii.gz" ]; then
	dti_affine_population ${subj}_mean_initial.nii.gz ${subj}.txt EDS 3
	mv mean_affine3.nii.gz ${subj}_mean_affine3.nii.gz
	echo "running affine registration to initial template"	
	else
	echo "affine registration has already been run"
fi

# Creates a binary mask of the affine subject-specific template
if [ ! -e "${subj}_mask.nii.gz" ]; then
	TVtool -in ${subj}_mean_affine3.nii.gz -tr
	BinaryThresholdImageFilter ${subj}_mean_affine3_tr.nii.gz ${subj}_mask.nii.gz 0.01 100 1 0
	echo "making binary mask for intial template construction"	
	else
	echo "binary mask has already been made"
fi

#########################################
# Improves the subject-specific template and creates deformation field, stores aligned volumes and puts their filenames in "{subj_aff_diffeo.txt"
#########################################

if [ ! -e "${subj}_diffeomorphic.nii.gz" ]; then
	dti_diffeomorphic_population ${subj}_mean_affine3.nii.gz ${subj}_aff.txt ${subj}_mask.nii.gz 0.002
	mv mean_diffeomorphic_initial6.nii.gz ${subj}_diffeomorphic.nii.gz
	echo "making diffeomorphic warps"
	else
	echo "diffeomorphic warps already made"
fi


#########################################
# Creates non-linear transform from individual timepoint to subject-specific template
#########################################

if [ ! -e "DWI_${subj}_T0_combined.df.nii.gz" ]; then					
	dfRightComposeAffine -aff DWI_${subj}_T0_dtitk.aff -df DWI_${subj}_T0_dtitk_aff_diffeo.df.nii.gz -out DWI_${subj}_T0_combined.df.nii.gz
	echo "Making non-inear transform for first timepoint"
	else
	echo "Transfrom to subject-specific template already exists"
fi

if [ ! -e "DWI_${subj}_T2_combined.df.nii.gz" ]; then	
	dfRightComposeAffine -aff DWI_${subj}_T2_dtitk.aff -df DWI_${subj}_T2_dtitk_aff_diffeo.df.nii.gz -out DWI_${subj}_T2_combined.df.nii.gz
	echo "Making non-inear transform for second timepoint"
	else
	echo "Transfrom to subject-specific template already exists"
fi

#########################################
# Warps individual timepoint to subject-specific template
#########################################

if [ ! -e "${subj}_T0_combined.nii.gz" ]; then	
	deformationSymTensor3DVolume -in DWI_${subj}_T0_dtitk.nii.gz -trans DWI_${subj}_T0_combined.df.nii.gz -target ${subj}_mean_initial.nii.gz -out ${subj}_T0_combined.nii.gz
	echo "warping first timepoint to subject-specific template"
	else
	echo "Warped timepoint to subject-specific template already exists for first timepoint"
fi

if [ ! -e "${subj}_T2_combined.nii.gz" ]; then	
	deformationSymTensor3DVolume -in DWI_${subj}_T2_dtitk.nii.gz -trans DWI_${subj}_T2_combined.df.nii.gz -target ${subj}_mean_initial.nii.gz -out ${subj}_T2_combined.nii.gz
	echo "warping second timepoint to subject-specific template"
	else
	echo "Warped timepoint to subject-specific template already exists for second timepoint"
fi

#########################################
# Calculates mean  image for both time points in subject-template space
#########################################

if [ ! -e "${subj}_mean_intra_template.nii.gz" ]; then
	ls ${subj}_T*_combined.nii.gz > ${subj}_intra_reg_volumes.txt
	TVMean -in ${subj}_intra_reg_volumes.txt -out ${subj}_mean_intra_template.nii.gz
	echo "creating mean image of both time points in subject-specific template space"
	else
	echo "mean image of both timepoints in subject-specific template space already exists"
fi

done

#########################################
# IGNORE below this line
#########################################

#########################################
# 
#########################################

###
# ${subj}_diffeomorphic.nii.gz is the refined subject-wise template
# ${subj}_TX_combined.nii.gz is the subject time point warped to the subject-wise template
# ${subj}_mean_intra.nii.gz is the mean warped image of the subject, which can be used to construct a between-subject template
# INTER-SUBJECT registration: here you can put in all the individual subject templates (for longitudinal data), as well as tensor images for subjects who only have the first timepoint
###
