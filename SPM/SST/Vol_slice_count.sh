#!/bin/bash

#set -o errexit
#set -o pipefail
#set -o nounset

for X in $(cat $1); do
echo $X $(fslval $X dim3) $(fslval $X dim4)
done

#
# Output redirected to file
#	bash -x myscript.sh BIG-FILE > my-output-file

# Output on stdout, aswell as in file
#	bash -x myscript.sh | tee my-output-file

# Write file to stdout
#	cat my-output-file

# Using pager to view file
#	less my-output-file

# Using libmagic to figure out file contents
#file INPUT-FILE
