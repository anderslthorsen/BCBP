#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, March 2020
# This script copies within-subject templates (for subejcts with longitudinal data) and baseline images for (subjects with only baseline data) to a common folder. Images in this folder is later used for generating the study-specific between-subject template

tensordir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors

cd ${tensordir}

##########
# Copies files for subjects with longitudinal data
##########

for subj in `cat completed_intra_templates.txt`; do
	cp ${subj} ${tensordir}/between_subject
done


##########
# Copies files for subjects with only baseline data
##########

for subj in `cat subj_T0_data.txt`; do
	cp ./tensor_${subj}/DWI_${subj}_T0_dtitk.nii.gz ${tensordir}/between_subject
done
