#!/bin/bash

sudo rm -rf deuxK

mkdir deuxK
cd deuxK

# Initialize repo
git init

# Initialize annex
git annex init

# Create base commit
git commit --allow-empty --date 2015-01-01 -m "Patient $1" -m "{patient_num: $1}"

## Create bio1 branch
git checkout -b bio1 master

# Add data
echo "bio1_data" > bio1_data
git annex add bio1_data
git commit -m "Data bio1" --date 2015-01-01 -m "{type: biopsy}"

# Add result
echo "bio1_result" > bio1_result
git add bio1_result
git commit --date 2015-01-01 -m "K1"

## Create bio2 branch
git checkout -b bio2 master

# Add data
echo "bio2_data" > bio2_data
git annex add bio2_data
git commit --date 2016-01-01 -m "Data bio2" -m "{type: biopsy}"

# Add result
echo "bio2_result" > bio2_result
git add bio2_result
git commit --date 2016-01-01 -m "K2"

## Create sang branch
git checkout -b sang master

# Add data
echo "sang_data" > sang_data
git annex add sang_data
git commit --date 2017-01-01 -m "Data sang" -m "{type: blood sample}"

# Add result
echo "sang_result" > sang_result
git add sang_result
git commit --date 2017-01-01 -m "Circulating cancer"

## Create bio3 branch
git checkout -b bio3 master

# Add data
echo "bio3_data" > bio3_data
git annex add bio3_data
git commit --date 2018-01-01 -m "Data bio3" -m "{type: biopsy}"

# Add result
echo "bio3_result" > bio3_result
git add bio3_result
git commit --date 2018-01-01 -m "K3"

### git ommix building

# Go back to master
git checkout master

# Split sang
git checkout sang
git branch sang2

# Update bio1 with sang
git checkout sang
git merge bio1 -m "K1circ"

# Update bio2 with sang
git checkout sang2
git merge bio2 -m "K2circ"

# Update K1circ with bio3
git checkout bio3
git merge sang -m "Meta"
