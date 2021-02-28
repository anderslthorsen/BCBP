#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, March 2020
# This script will transform the voxel size and bounding box to be in the power of 2, which is required by DTI-TK

tensor_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors

cd ${tensor_dir}

if [ ! -e "dtitk_files.txt" ]; then
	ls DWI_*_T*_dtitk.nii.gz > dtitk_files.txt
	for subj in `cat dtitk_files.txt`; do 
	TVResample -in ${subj} -align center -size 128 128 64 -vsize 1.5 1.75 2.25 
else
	echo "Tensor files may already have been transformed, please check that voxel size 1.5 1.75 2.25 is with the command 'VolumeInfo tensorfile.nii.gz'"

fi
