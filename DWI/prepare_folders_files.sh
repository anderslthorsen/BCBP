#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, March 2020
# This script will copy the eddy corrected DWI, eddy corrected bvec, original bvec, and bval files to a new subfolder for every subject in the Bergen study

home=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI

cd ${home}

#subj=00001_T0

for subj in `cat subjects.txt`; do

####
# Creates folder and moves files
####

echo "running subject" ${subj}
cd ${home}/${subj}

if [ ! -d "tensor" ]; then
mkdir tensor
else 
echo "tensor folder already exist for" ${subj}
fi

# Checks if files have already been copied
cd tensor
if [ ! -e DWI_${subj}_ECV.nii.gz ] && [ ! -e nodif_brain_mask.nii.gz ]; then
cd ${home}/${subj}/DWI_SS/
cp DWI_${subj}_ECV.nii.gz DWI_${subj}_ECV.eddy_rotated_bvecs ../tensor
cd ${home}/${subj}/
cp nodif_brain_mask.nii.gz ${subj}.bval ${subj}.bvec tensor

# Prints out message if files have already been copied
else
echo "eddy corrected files already exist for" ${subj}
fi

done


