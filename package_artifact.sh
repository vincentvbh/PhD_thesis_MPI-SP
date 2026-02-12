#!/bin/bash

rm -rf artifact_tmp
cp -a artifact artifact_tmp
cd artifact_tmp
bash ./clean_up.sh
find . -name '.git*' -exec rm -rf {} \;
cd ../
rm -f artifact.zip
zip -r artifact.zip artifact_tmp
