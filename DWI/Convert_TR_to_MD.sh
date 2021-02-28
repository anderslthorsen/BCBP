#!/bin/bash
set -euo pipefail

# Written by Anders L. Thorsen, April 2020

TR_dir=/s4ever/anwG/NP/yvdwerf/data_Bergen/DWI/tensors/between_subject/warps/warped_subjects/TR

cd ${TR_dir}

for subj in `cat TR_files.txt`; do
		fslmaths ${subj} -div 3 ${subj}
	done
