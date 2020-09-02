#!/bin/bash

# [[ -n $1 ]] || echo "Needs a patient id"
# [[ -n $1 ]] || exit
# mkdir $1
# cd $1

sudo rm -rf grand

mkdir grand
cd grand

# Initialize repo
git init

# Initialize annex
git annex init

# Create base commit
git commit --allow-empty --date 2016-01-01 -m "Patient $1" -m "{patient_num: $1}"

# Create S23 branch
git checkout -b 1606_S23 master

# Add data
echo "S23_data" > S23_data
git annex add S23_data
git commit -m "Data S23" --date 2016-06-01 -m "{type: biopsy, loc: anus}"

# Add result
echo "S23_result" > S23_result
git add S23_result
git commit --date 2016-06-02 -m "HGAIN"

# Create plasmanov17 branch
git checkout -b 1711_PlasmaNov17 master

# Add data
echo "PlasmaNov17_data" > PlasmaNov17_data
git annex add PlasmaNov17_data
git commit --date 2017-11-01 -m "Data PlasmaNov17" -m "{type: blood sample}"

# Add result
echo "PlasmaNov17_result" > PlasmaNov17_result
git add PlasmaNov17_result
git commit --date 2017-11-02 -m "Circulating HPV"

# Create plasmamai18 branch
git checkout -b 1805_PlasmaMai18 master

# Add data
echo "PlasmaMai18_data" > PlasmaMai18_data
git annex add PlasmaMai18_data
git commit --date 2018-05-01 -m "Data PlasmaMai18" -m "{type: blood sample}"

# Add result
echo "PlasmaMai18_result" > PlasmaMai18_result
git add PlasmaMai18_result
git commit --date 2018-05-02 -m "Circulating HPV"

# Create S19 branch
git checkout -b 1807_S19 master

# Add data
echo "S19_data" > S19_data
git annex add S19_data
git commit --date 2018-07-01 -m "Data S19" -m "{type: biopsy, loc: anus}"

# Add result
echo "S19_result" > S19_result
git add S19_result
git commit --date 2018-07-02 -m "Failed"

# Create S20 branch
git checkout -b 1807_S20 master

# Add data
echo "S20_data" > S20_data
git annex add S20_data
git commit --date 2018-07-03 -m "Data S20" -m "{type: biopsy, loc: anus}"

# Add result
echo "S20_result" > S20_result
git add S20_result
git commit --date 2018-07-04 -m "HGAIN"

# Create S12 branch
git checkout -b 1807_S12 master

# Add data
echo "S12_data" > S12_data
git annex add S12_data
git commit --date 2018-07-01 -m "Data S12" -m "{type: biopsy, loc: vertebrae}"

# Add result
echo "S12_result" > S12_result
git add S12_result
git commit --date 2018-07-02 -m "Vertebrae lesion"

### git ommix building

# Go back to master
git checkout master

# Invalidate S19 with S20
git checkout 1807_S20
git merge 1807_S19 -m "Invalidate S19"
git branch -d 1807_S19

# Update S23 with plasmanov17
git checkout 1711_PlasmaNov17
git merge 1606_S23 -m "Circulating HGAIN"

# Update plasmanov17 with plasmamai18
git checkout 1805_PlasmaMai18
git merge 1711_PlasmaNov17 -m "Circulating HGAIN"

# Update plasmamai18 with S20
git checkout 1807_S20
git merge 1805_PlasmaMai18 -m "Local relapse"

# Update S20 with S12
git checkout 1807_S12
git merge 1807_S20 -m "Metastasis"
