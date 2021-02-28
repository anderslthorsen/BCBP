#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, March 2020
# This script will register two longitudinal DTI volumes to a common within-subject template. The within-subject template can then be used to register mutliple subjects to each other. A key benefit of this approach is that you minimize the number of transformations of the data, rather than adding extra interpolations when tranforming between time points (within subject) and between subjects. URL of manual is available here (http://dti-tk.sourceforge.net/pmwiki/pmwiki.php?n=Documentation.HomePage) and useful online discussion with code is available here (https://groups.google.com/forum/#!topic/dtitk/ciF3INwnGt8)

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
tensor_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/version_160420
templatedir=/home/common/applications/dtitk/ixi_aging_template_v3.0/template


#########################################
# UNDER DEVELOPMENT
#########################################

cd ${tensor_dir}

#########################################
# Creates intial group template from within-subject templates
#########################################

if [ ! -e "mean_initial.nii.gz" ]; then
	dti_template_bootstrap ${templatedir}/ixi_aging_template.nii.gz Inter_subject.txt EDS
	echo "Running intial template construction"
	else
	echo "Initial template already exists"
fi

#########################################
# Create affine (linear) warps for each subject to group template
#########################################

if [ ! -e "mean_affine3.nii.gz" ]; then
	dti_affine_population mean_initial.nii.gz Inter_subject.txt EDS 3
	echo "Running affine registration to initial template"
	else
	echo "Affine registrations already exists"
fi

#########################################
# Create mask of initial template to exclude voxels outside the brain
#########################################

if [ ! -e "mask.nii.gz" ]; then
	TVtool -in mean_affine3.nii.gz -tr
	BinaryThresholdImageFilter mean_affine3_tr.nii.gz mask.nii.gz 0.01 100 1 0
	echo "Creating binary mask of initial template"
	else
	echo "Binary mask already exists"
fi

#########################################
# Improves the subject-specific template and creates deformation fields, stores aligned volumes and puts their filenames in "subj_aff_diffeo.txt"
#########################################

if [ ! -e "mean_diffeomorphic_initial6.nii.gz" ]; then
	dti_diffeomorphic_population mean_affine3.nii.gz Inter_subject_aff.txt mask.nii.gz 0.002
	echo "making diffeomorphic warps"
	else
	echo "diffeomorphic warps already made"
fi

#########################################
#
#########################################

: <<'END'

dfRightComposeAffine -aff MC_002_mean_diffeomorphic_initial6.aff -df MC_002_mean_diffeomorphic_initial6_aff_diffeo.df.nii.gz -out MC_002_Inter_Subject_Combined.df.nii.gz

dfRightComposeAffine -aff MC_003_mean_diffeomorphic_initial6.aff -df MC_003_mean_diffeomorphic_initial6_aff_diffeo.df.nii.gz -out MC_003_Inter_Subject_Combined.df.nii.gz

END
