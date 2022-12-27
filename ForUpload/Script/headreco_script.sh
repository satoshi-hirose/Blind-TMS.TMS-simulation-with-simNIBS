#!bin/bash
mkdir ../Analyze

while read -r f; do
  sub=${f##*/}
  if [[ $sub != "."* ]]; then
    echo "Subject: $sub"
    mkdir "../Analyze/$sub"
    cd "../Analyze/$sub"

# replace .hdr with .nii or .nii.gz if needed.
# add T2 file's path if needed.
    headreco all $sub ../../Rawdata/$sub/T1.hdr
    cd ..
  fi
done < <(find ../Rawdata -mindepth 1 -maxdepth 1)