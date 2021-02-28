#!/bin/bash
set -euo pipefail
# Written by Anders L. Thorsen, April 2020

# Sets up variables for paths to directories and files
FA_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/warps/warped_subjects/FA/

# changes working directory to where the FA images are
cd ${FA_dir}

# Do for all warped images
for subj in `cat FA_files.txt`; do

	cp ../${subj} ${FA_dir}

done
