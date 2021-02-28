#!/bin/bash
set -euo pipefail
# Written by Vilde Brecke, May 2020
# TBSS skeletonised for non FA T0 and T2

# Sets up FSL 5.1.0
export FSLDIR=/home/common/applications/FSL/FSL-5.0.10/
source ${FSLDIR}/etc/fslconf/fsl.sh
export PATH=${FSLDIR}/bin:${PATH}
echo "FSL VERSION: 5.0.10 sourced"

for timepoint in T0 T2; do
	for metric in RD MD AD; do

		# Sets up variables for paths to directories and files
		metric_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/warps/warped_subjects/FA/stats/${timepoint}/${metric}
		echo "Current scale is ${metric}"

		# Changes working directory to where the study template is
		cd ${metric_dir}
		
		# Skeletonising metric
		tbss_skeleton -i mean_FA -p 0.2 mean_FA_skeleton_mask_dst ${FSLDIR}/data/standard/LowerCingulum_1mm all_FA all_${metric}_skeletonised -a all_${metric}_${timepoint} -s mean_FA_skeleton.nii.gz
	

	done
done


