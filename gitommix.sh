#!/usr/bin/env bash

# More safety, by turning some bugs into errors.
# Without `errexit` you don’t need ! and can replace
# PIPESTATUS with a simple $?, but I don’t do that.
set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

# Define options and long options
OPTIONS=dfo:v
LONGOPTS=debug,force,output:,verbose

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

d=n f=n v=n outFile=-
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -d|--debug)
            d=y
            shift
            ;;
        -f|--force)
            f=y
            shift
            ;;
        -v|--verbose)
            v=y
            shift
            ;;
        -o|--output)
            outFile="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# handle non-option arguments
if [[ $# -ne 1 ]]; then
    echo "$0: A single input file is required."
    exit 4
fi

echo "verbose: $v, force: $f, debug: $d, in: $1, out: $outFile"

# Helper functions

usage()
{
    echo "Welcome to Git Ommix !"
    echo "Usage: git <repo> <function> <args>"
    echo "Query functions :"
    echo "-list : list all samples (branches)"
    echo "-result <sample> : get the result generated by <sample>"
    exit
}

# Git ommix creation functions

## New patient

## New sample

## Split sample

## Invalidate sample

## Update sample

# Git ommix query functions

## List samples
list()
{
    # List all branches but master an git-annex
    git branch | grep -v 'master' | grep -v 'git-annex'
}

## Get up-to-date result of a sample
result()
{
    [[ -n $1 ]] || usage

    git checkout $1
    git log -n 1 --pretty="format:%s"
}

## Get up-to-date results from any ref



## Get all Data commits

# git checkout 1807_S12
# git log --grep "^Data"

## Timeline from any ref

# for branch in `git branch --contains <hash>`
# do
    # git checkout branch
    # git log -n 1
# done

# If no repo given, bail out
[[ -n $1 ]] || usage

# Enter the repo
cd $1

# Set pager to cat
git config core.pager cat

# Execute function
case $2 in
     list) list;;
     result) result $3;;
     *) usage;;
esac

# Always go back to master
git checkout master 2> /dev/null
