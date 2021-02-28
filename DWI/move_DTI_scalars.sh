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

#Make text files containing list of relevant images
	ls *_tr.nii.gz > TR_files.txt
	ls *_ad.nii.gz > AD_files.txt
	ls *_rd.nii.gz > RD_files.txt
	ls *_pd.nii.gz > PD_files.txt
	ls *_rgb.nii.gz > RGB_files.txt

for scalar in TR AD RD PD RGB; do
	for subj in `cat ${scalar}_files.txt`; do
		cp ${subj} ./${scalar}
	done
done
