#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, April 2020
# This script uses FLIRT and FNIRT to register the JHU atlas to the study-specific template (as recommended by Mahoney et al, 2015, Ann Neurol).

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
	atlasdir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/atlas
	template=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/atlas/mean_diffeomorphic_initial6_fa.nii.gz
	JHU_atlas=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/atlas/JHU/JHU-ICBM-FA-1mm.nii.gz

	# Uses the 

	cd ${atlasdir}


	# Affine registers the JHU FA image to the study template
	flirt -ref ${template} -in  -out JHU_study_template.nii.gz -omat JHU_study_template.mat

	# Affine registers the JHU FA image to the study template AND keeps the JHU FA images as 1mm isotropic 	voxels
	flirt -ref mean_diffeomorphic_initial6_fa_1mm.nii.gz -in JHU-ICBM-FA-1mm.nii.gz -out JHU_study_template_1mm.nii.gz -omat JHU_study_template_1mm.mat
	
	# reslices study template to 1mm
	flirt -ref mean_diffeomorphic_initial6_fa.nii.gz -in mean_diffeomorphic_initial6_fa.nii.gz -out mean_diffeomorphic_initial6_fa_1mm.nii.gz -applyisoxfm 1
	
	# fnirt in native voxel sizes for study template
	fnirt --ref=mean_diffeomorphic_initial6_fa.nii.gz --in=JHU-ICBM-FA-1mm.nii.gz --aff=JHU_study_template.mat --iout=JHU_study_template_FNIRT.nii.gz --cout=JHU_study_template_FNIRT --config=FA_2_FMRIB58_1mm.cnf

	# fnirt for 1mm voxel sizes for study template, without config file
	fnirt --ref=mean_diffeomorphic_initial6_fa_1mm.nii.gz --in=JHU-ICBM-FA-1mm.nii.gz --aff=JHU_study_template_1mm.mat --iout=JHU_study_template_FNIRT_1mm.nii.gz --cout=JHU_study_template_FNIRT_1mm

	# fnirt for 1mm voxel sizes for study template, with config file
	fnirt --ref=mean_diffeomorphic_initial6_fa_1mm.nii.gz --in=JHU-ICBM-FA-1mm.nii.gz --aff=JHU_study_template_1mm.mat --iout=JHU_study_template_FNIRT_1mm_config.nii.gz --cout=JHU_study_template_FNIRT_1mm_config --config=FA_2_FMRIB58_1mm.cnf


#########################################
#	Attempt to use DTI-TK's tools instead of FSL
#########################################

dti_rigid_reg mean_diffeomorphic_initial6_fa_1mm.nii.gz JHU-ICBM-FA-1mm.nii.gz EDS 4 4 4 0.001


#########################################
#	Using fsl_reg with JHU as reference. Gathered from https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=ind1108&L=FSL&P=R29363
#########################################

# From Megan Herting - SEEMS TO WORK!
fsl_reg mean_diffeomorphic_initial6_fa_1mm.nii.gz JHU-ICBM-FA-1mm.nii.gz diffeomorphic_fa_1mm_JHU.nii.gz -FA &

invwarp -w diffeomorphic_fa_1mm_JHU.nii.gz_warp.nii.gz -o JHU_to_diffeomorphic.nii_warp.nii.gz -r mean_diffeomorphic_initial6_fa_1mm.nii.gz

# using default options - WORKS BEST
applywarp -i JHU-ICBM-FA-1mm.nii.gz -o JHU_in_diffeo_space_default.nii.gz -r mean_diffeomorphic_initial6_fa_1mm.nii.gz  -w JHU_to_diffeomorphic.nii_warp.nii.gz

# using default options on JHU labels - IT WORKS!
applywarp -i ../JHU/JHU-ICBM-labels-1mm.nii.gz -o JHU_labels_in_diffeo_space_default.nii.gz -r mean_diffeomorphic_initial6_fa_1mm.nii.gz  -w JHU_to_diffeomorphic.nii_warp.nii.gz

# using extra setting and nearest neighbour interpolation
applywarp -i JHU-ICBM-FA-1mm.nii.gz -o JHU_in_diffeo_space_extra.nii.gz -r mean_diffeomorphic_initial6_fa_1mm.nii.gz  -w JHU_to_diffeomorphic.nii_warp.nii.gz --interp=nn -d float -s --superlevel=a

# using extra settings and trilinear interpolation
applywarp -i JHU-ICBM-FA-1mm.nii.gz -o JHU_in_diffeo_space_extra_interp_tri.nii.gz -r mean_diffeomorphic_initial6_fa_1mm.nii.gz  -w JHU_to_diffeomorphic.nii_warp.nii.gz --interp=trilinear -d float -s --superlevel=a




#########################################
#	Using fsl_reg with study template as reference
#########################################

fsl_reg JHU-ICBM-FA-1mm.nii.gz mean_diffeomorphic_initial6_fa_1mm.nii.gz JHU_diffemorphic_1mm_fa.nii.gz -FA &


