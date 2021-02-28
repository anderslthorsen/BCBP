#!/bin/bash


dtitkdir=/home/common/applications/dtitk/dtitk-2.3.1
export PATH="/home/common/applications/dtitk/dtitk-2.3.1/bin:${PATH}"
export PATH="/home/common/applications/dtitk/dtitk-2.3.1/utilities:${PATH}"
export DTITK_ROOT=/home/common/applications/dtitk/dtitk-2.3.1/


# source FSL 5.1.0
export FSLDIR=/home/common/applications/FSL/FSL-5.0.10/
source ${FSLDIR}/etc/fslconf/fsl.sh
export PATH=${FSLDIR}/bin:${PATH}
echo "FSL VERSION: 5.0.10 sourced"


Niter=5
bshell=2000

# tell DTITK to use Qsub
#export DTITK_USE_QSUB=1

templatedir=/home/common/applications/dtitk/ixi_aging_template_v3.0/template
thuis=/s4ever/anwG/NP/yvdwerf/data_OBS/analysis/DWI_methods/b${bshell}

cd ${thuis}



#########################################
# dtifit
#########################################



echo "run dtifit on bshell = b${bshell}"

for subj in `cat subjects.txt`; do

cd ${thuis}/${subj}

echo ${subj}

if [ ! -f DWI_${subj}_b0_${bshell}_FA.nii.gz ]; then

dtifit --data=b0_b${bshell} --mask=nodif_brain_mask.nii.gz --bvecs=bvecs --bvals=bvals --out=DWI_${subj}_b0_${bshell}

fi

done

cd ${thuis}

#########################################
# Make dtifit’s dti_V{123} and dti_L{123} compatible with DTI-TK
#########################################

for subj in `cat subjects.txt`; do

cd ${thuis}/${subj}

echo ${subj}

if [ ! -f DWI_${subj}_b0_${bshell}_dtitk.nii.gz ]; then

${dtitkdir}/scripts/fsl_to_dtitk DWI_${subj}_b0_${bshell}

fi


done
#####################################


cd ${thuis}

#######################################
# create initial bootstrapped template 
#######################################
# IGNORE warning: "That particular warning is expected for the command that you are running.  So nothing to worry about."

find -name *dtitk.nii.gz > subjects.txt

for subj in `cat subjects.txt`; do mv ${subj} ${thuis}; done

ls -1 *dtitk.nii.gz > subjects.txt


if test ${bshell} -eq 1000; then


${dtitkdir}/scripts/dti_template_bootstrap ${templatedir}/ixi_aging_template.nii.gz subjects.txt

###########################################
#- registration and spatial normalization 
###########################################
# EDS = EUCLIDIAN DISTANCE 
# N iterations
${dtitkdir}/scripts/dti_affine_population mean_initial.nii.gz subjects.txt EDS ${Niter}

############################################
# - Creating a mask file, needed for further alignment 
############################################
TVtool -in mean_affine${Niter}.nii.gz -tr
BinaryThresholdImageFilter mean_affine${Niter}_tr.nii.gz mean_affine${Niter}_mask.nii.gz 0.01 100 1 0

############################################
# Deformable alignment with template refinement, optimizing the template
############################################

# this step does not seem to work with qsub. unset qsub
#unset DTITK_USE_QSUB

${dtitkdir}/scripts/dti_diffeomorphic_population mean_affine${Niter}.nii.gz subjects_aff.txt mean_affine${Niter}_mask.nii.gz 0.002
#./test_df_pop.sh mean_affine${Niter}.nii.gz subjects_aff.txt mean_affine${Niter}_mask.nii.gz 0.002


fi

#############################################
# Generate the spatially normalized DTI subject data with the isotropic 1mm3 resolution 
#############################################
#export DTITK_USE_QSUB=1


if [ ${bshell} -ne 1000 ]; then
for name in $(ls -d ????); do
ln -s ../b1000/DWI_${name}_b0_1000_dtitk_aff_diffeo.df.nii.gz DWI_${name}_b0_${bshell}_dtitk_aff_diffeo.df.nii.gz 
done

cp ../b1000/mean_final.nii.gz .
fi


${dtitkdir}/scripts/dti_warp_to_template_group subjects.txt mean_final 1 1 1

#############################################
#Generate the population-specific DTI template with the isotropic 1mm3 spacing
#############################################
#subjs_normalized.txt is an ASCII text file that contains a list of the file names of the normalized high-resolution DTI volumes from the previous step

ls -1 *dtitk_diffeo.nii.gz > subjs_normalized.txt

TVMean -in subjs_normalized.txt -out mean_final_high_res.nii.gz

#############################################
# Generate the FA map of the high-resolution population-specific DTI template
#############################################
TVtool -in mean_final_high_res.nii.gz -fa

#############################################
#Rename the FA map to be consistent with the TBSS pipeline
#############################################

mv mean_final_high_res_fa.nii.gz mean_FA.nii.gz

#############################################
#Generate the white matter skeleton from the high-resolution FA map of the DTI template
#############################################

#tbss_skeleton -i mean_FA -o mean_FA_skeleton
tbss_skeleton -i mean_FA -o mean_FA_skeleton

#############################################
# Generate the FA map of the spatially normalized high-resolution DTI data
#############################################

for subj in `cat subjs_normalized.txt`; do
TVtool -in ${subj} -fa
TVtool -in ${subj} -ad
TVtool -in ${subj} -rd
# tr = 3 times md
TVtool -in ${subj} -tr
done

fslmerge -t all_FA *dtitk_diffeo_fa.nii.gz
fslmerge -t all_RD *dtitk_diffeo_rd.nii.gz
fslmerge -t all_TR *dtitk_diffeo_tr.nii.gz
fslmerge -t all_AD *dtitk_diffeo_ad.nii.gz

fslmaths all_TR -div 3 all_MD

#############################################
#apply fslmaths to all_FA to create a combined binary mask volume called mean_FA_mask
#############################################

fslmaths all_FA -max 0 -Tmin -bin mean_FA_mask -odt char
fslmaths all_AD -max 0 -Tmin -bin mean_AD_mask -odt char
fslmaths all_RD -max 0 -Tmin -bin mean_RD_mask -odt char

fslmaths all_MD -max 0 -Tmin -bin mean_MD_mask -odt char


fslmaths mean_FA_skeleton -mas mean_FA_mask mean_FA_skeleton_mskd

#############################################
#Place the TBSS relevant files into a folder that TBSS expects
#############################################

mkdir -p tbss
cd tbss
mkdir -p stats
cd ..
cp mean_FA.nii.gz mean_FA_skeleton_mskd.nii.gz all_FA.nii.gz mean_FA_mask.nii.gz tbss/stats
cd tbss/stats
mv mean_FA_skeleton_mskd.nii.gz mean_FA_skeleton.nii.gz
cd ..

#############################################
# final tbss step before randomize
#############################################

tbss_4_prestats 0.2







