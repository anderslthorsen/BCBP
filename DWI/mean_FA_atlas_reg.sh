# Script to use FLIRT and FNIRT to register study template and atlas FA images together


# From Megan Herting - SEEMS TO WORK!
fsl_reg mean_final_high_res_fa.nii.gz JHU-ICBM-FA-1mm.nii.gz template_in_JHU.nii.gz -FA

invwarp -w template_in_JHU.nii.gz_warp.nii.gz -o JHU_to_template_warp.nii.gz -r mean_final_high_res_fa.nii.gz

# using default options - WORKS BEST
applywarp -i JHU-ICBM-FA-1mm.nii.gz -o JHU_in_template.nii.gz -r mean_final_high_res_fa.nii.gz  -w JHU_to_template_warp.nii.gz

# using default options on JHU labels - IT WORKS!
applywarp -i JHU-ICBM-labels-1mm.nii.gz -o JHU_labels_in_template.nii.gz -r mean_final_high_res_fa.nii.gz  -w JHU_to_template_warp.nii.gz

# use default options on JHU labels version threshold 25
applywarp -i JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz -o JHU_labels_thr25_in_template.nii.gz -r mean_final_high_res_fa.nii.gz  -w JHU_to_template_warp.nii.gz


