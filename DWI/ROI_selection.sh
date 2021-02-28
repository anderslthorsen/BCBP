#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, April 2020
# Extracts ROI images from erodede JHU atlas, merges them togehter, and visualizes ROI on mean FA image

cd /s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/warps/warped_subjects/atlas/ROI

# Extract and binarize bilateral regions of the cingulum bundle
#fslmaths JHU_labels_in_template_ero_2mm.nii.gz -thr 35 -uthr 38 -bin JHU_labels_in_template_ero_2mm_cingulum.nii.gz

	fslmaths JHU_labels_in_template_ero_2mm.nii.gz -thr 35 -uthr 35 -bin R_dorsal_cingulum.nii.gz
	fslmaths JHU_labels_in_template_ero_2mm.nii.gz -thr 36 -uthr 36 -bin L_dorsal_cingulum.nii.gz

	fslmaths JHU_labels_in_template_ero_2mm.nii.gz -thr 37 -uthr 37 -bin R_ventral_cingulum.nii.gz
	fslmaths JHU_labels_in_template_ero_2mm.nii.gz -thr 38 -uthr 38 -bin L_ventral_cingulum.nii.gz

		# Combines both sides into one bilateral mask
		fslmaths R_dorsal_cingulum.nii.gz -add L_dorsal_cingulum.nii.gz -add R_ventral_cingulum.nii.gz -add L_ventral_cingulum.nii.gz bil_cingulum.nii.gz

# Extract and binarize bilateral regions of the sagital stratum
#fslmaths JHU_labels_in_template_ero_2mm.nii.gz -thr 31 -uthr 3 -bin JHU_labels_in_template_ero_2mm_sag_stratum.nii.gz

	fslmaths JHU_labels_in_template_ero_2mm.nii.gz -thr 31 -uthr 31 -bin R_sag_stratum.nii.gz

	fslmaths JHU_labels_in_template_ero_2mm.nii.gz -thr 32 -uthr 32 -bin L_sag_stratum.nii.gz

		# Combines both sides into one bilateral mask
		fslmaths R_sag_stratum.nii.gz -add L_sag_stratum.nii.gz bil_sag_stratum.nii.gz

# Extract and binarize bilateral regions of the posterior thalamic radiation
#fslmaths JHU_labels_in_template_ero_2mm.nii.gz -thr 29 -uthr 30 -bin JHU_labels_in_template_ero_2mm_post_thalamic_rad.nii.gz

	fslmaths JHU_labels_in_template_ero_2mm.nii.gz -thr 29 -uthr 29 -bin R_post_thalamic_rad.nii.gz
	fslmaths JHU_labels_in_template_ero_2mm.nii.gz -thr 30 -uthr 30 -bin L_post_thalamic_rad.nii.gz

		# Combines both sides into one bilateral mask
		fslmaths R_post_thalamic_rad.nii.gz -add L_post_thalamic_rad.nii.gz bil_post_thalamic_rad.nii.gz

# Combine all ROI into one mask
	fslmaths bil_cingulum.nii.gz -add bil_sag_stratum.nii.gz -add bil_post_thalamic_rad.nii.gz ROI_Bergen.nii.gz

# View ROI images on the mean FA image

fslview ../mean_final_high_res_fa.nii.gz -b 0.2,0.8 bil_cingulum.nii.gz -l "Blue"  bil_sag_stratum.nii.gz -l "Red" bil_post_thalamic_rad.nii.gz -l "Green"

