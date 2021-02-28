dit#!/bin/bash
set -euo pipefail
# Written by Vilde Brecke, May 2020   #
# randomise for non-FA and timepoints #
#######################################

#NOTE TO SELF: 03.06: Something makes the script stop at RD T0. Have not looked over.


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

		
		# randomise T0 og T2  ROI
		randomise -i all_${metric}_skeletonised.nii.gz -o ROI -m mean_FA_skeleton_mask_ROI_Bergen.nii.gz -d design_ocd_vs_hc.mat -t contrast_ocd_vs_hc.con -n 5000 --T2 -x 


		# randomise T0 og T2  WB
		randomise -i all_${metric}_skeletonised.nii.gz -o WB -m mean_FA_skeleton_mask.nii.gz -d design_ocd_vs_hc.mat${timepoint} -t contrast_ocd_vs_hc${metric}.con -n 5000 --T2 -x
	

	done
done
