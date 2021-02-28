#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, April 2020
# This script will combine the transformations from native space -> intra-subjecte template space -> inter-subjecte template space. It will then warp the images for T0 and T2 time points to inter-subjecte template space with 1mm³ voxel dimensions.

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
	tensor_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors
	warp_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/warps
	between_subject_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject
	subj_complete_data=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/subj_complete_data.txt
	subj_T0_data=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/subj_T0_data.txt

	test_00001=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/subjects_intra.txt

# changes working directory to where the study template is
cd ${between_subject_dir}

# Do for subjects with baseline data only
for subj in `cat ${subj_T0_data}`; do

	# Combine affine and diffeomorphic warp fields from intra-subject space -> inter-subject template space
	dfRightComposeAffine -aff DWI_${subj}_T0_dtitk.aff -df DWI_${subj}_T0_dtitk_aff_diffeo.df.nii.gz -out ./warps/${subj}_T0_native_to_inter_subject_combined.df.nii.gz

	# Warp image for T0 from native -> inter-subjecte space
	deformationSymTensor3DVolume -in ${tensor_dir}/tensor_${subj}/DWI_${subj}_T0_dtitk.nii.gz -trans ${warp_dir}/${subj}_T0_native_to_inter_subject_combined.df.nii.gz -target mean_diffeomorphic_initial6.nii.gz -out ${warp_dir}/warped_subjects/warped_${subj}_T0.dtitk.nii.gz -vsize 1 1 1

done

# Do for subjects with longitudinal data
for subj in `cat ${subj_complete_data}`; do

	# Combine affine and diffeomorphic warp fields from intra-subject space -> inter-subject template space
	dfRightComposeAffine -aff ${subj}_mean_intra_template.aff -df ${subj}_mean_intra_template_aff_diffeo.df.nii.gz -out ./warps/${subj}_inter_subject_combined.df.nii.gz

	# Combine warp fields from T0 intra-subject space -> inter-subject template space
	dfComposition -df1 ${tensor_dir}/tensor_${subj}/DWI_${subj}_T0_combined.df.nii.gz -df2 ${warp_dir}/${subj}_inter_subject_combined.df.nii.gz -out ${warp_dir}/${subj}_T0_native_to_inter_subject_combined.df.nii.gz

	# Combine warp fields from T2 intra-subject space -> inter-subject template space
	dfComposition -df1 ${tensor_dir}/tensor_${subj}/DWI_${subj}_T2_combined.df.nii.gz -df2 ${warp_dir}/${subj}_inter_subject_combined.df.nii.gz -out ${warp_dir}/${subj}_T2_native_to_inter_subject_combined.df.nii.gz

	# Warp image for T0 from native -> inter-subjecte space
	deformationSymTensor3DVolume -in ${tensor_dir}/tensor_${subj}/DWI_${subj}_T0_dtitk.nii.gz -trans ${warp_dir}/${subj}_T0_native_to_inter_subject_combined.df.nii.gz -target mean_diffeomorphic_initial6.nii.gz -out ${warp_dir}/warped_subjects/warped_${subj}_T0.dtitk.nii.gz -vsize 1 1 1

	# Warping image for T2 from native -> inter-subjecte space
	deformationSymTensor3DVolume -in ${tensor_dir}/tensor_${subj}/DWI_${subj}_T2_dtitk.nii.gz -trans ${warp_dir}/${subj}_T2_native_to_inter_subject_combined.df.nii.gz -target mean_diffeomorphic_initial6.nii.gz -out ${warp_dir}/warped_subjects/warped_${subj}_T2.dtitk.nii.gz -vsize 1 1 1

done
