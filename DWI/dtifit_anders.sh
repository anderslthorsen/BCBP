#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, March 2020
# This script will run dtifit and harmonize the tensor volumes with DTI-TK for every subject
# Note: this script runs each step for every participant, and only then moves onto the next step

# Sets up DTI-TK and FSL
dtitkdir=/home/common/applications/dtitk/dtitk-2.3.1
export PATH="/home/common/applications/dtitk/dtitk-2.3.1/bin:${PATH}"
export PATH="/home/common/applications/dtitk/dtitk-2.3.1/utilities:${PATH}"
export DTITK_ROOT=/home/common/applications/dtitk/dtitk-2.3.1/
echo "DTI-TK sourced"

# source FSL 5.1.0
export FSLDIR=/home/common/applications/FSL/FSL-5.0.10/
source ${FSLDIR}/etc/fslconf/fsl.sh
export PATH=${FSLDIR}/bin:${PATH}
echo "FSL VERSION: 5.0.10 sourced"


# directory where there should be subject and time specific subfolders with eddy corrected DWI volumes
DWI_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI

cd ${DWI_dir}

# Requires text file with list of directories for each subject/timepoint
for subj in `cat subjects.txt`; do

#########################################
# Runs dtifit
#########################################

echo "running subject" ${subj}
cd ${DWI_dir}/${subj}/tensor

if [ ! -e "DWI_${subj}_FA.nii.gz" ]; then
dtifit --data=DWI_${subj}_ECV.nii.gz --mask=nodif_brain_mask.nii.gz --bvecs=DWI_${subj}_ECV.eddy_rotated_bvecs --bvals=${subj}.bval --out=DWI_${subj}
else
echo "dtifit has alreay been run"
fi

done


#########################################
# Make dtifit’s dti_V{123} and dti_L{123} files compatible with DTI-TK
#########################################

cd ${DWI_dir}
for subj in `cat subjects.txt`; do

echo "running subject" ${subj}
cd ${DWI_dir}/${subj}/tensor

if [ ! -e "DWI_${subj}_dtitk.nii.gz" ]; then
${dtitkdir}/scripts/fsl_to_dtitk DWI_${subj}
else
echo "fsl_to_dtitk has alreay been run"
fi

done


#########################################
# Performs numerical quality control on DTI-TK image by calculating mean and extreme values
#########################################

cd ${DWI_dir}
for subj in `cat subjects.txt`; do
cd ${DWI_dir}/${subj}/tensor

if [ ! -e "${subj}_tensornorm.txt" ]; then
echo "running QC on subject" ${subj}
SVtool -in DWI_${subj}_dtitk_norm.nii.gz -stats >> ${subj}_tensornorm.txt
else
echo "QC numbers for tensor have already been calculated"
fi

done

#########################################
# Extracts mean and extreme values for each participant and puts it into a text file. You should check that the mean and extreme values are appproximately the same for all participants. See link for more information (http://dti-tk.sourceforge.net/pmwiki/pmwiki.php?n=Documentation.BeforeReg)
#########################################

cd ${DWI_dir}
for subj in `cat subjects.txt`; do
if [ ! -e "${DWI_dir}/tensornorm.txt" ]; then
(echo $subj && sed -n '4p' < ${DWI_dir}/${subj}/tensor/${subj}_tensornorm.txt) >> tensornorm.txt
else
echo "QC file for the participants already exists"
fi
done

#########################################
# Visual quality control of DTI-TK volumes
# At this stage you should load up a subject _dtitk.nii.gz file and ensure that CSF has an approximate value of 2-3. If not, this indicates problem with the conversion between FSL and DTI-TK
#########################################


