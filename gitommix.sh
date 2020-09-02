#!/usr/bin/env bash

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
