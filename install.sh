#!/usr/bin/env bash

# set -euo pipefail

function die
{
    clr red "$@"
    exit 2
}

function clr
{
    local col

    case "$1" in
        grey) col="30m";;
        red) col="31m";;
        green) col="32m";;
        blue) col="34m";;
        *) col="m";;
    esac

    shift

    echo -e "\033[0;$col$@\033[0m"
}

# status_code {0=pass,1=fail} text
function status
{
    echo -n "[ "
    if [[ "$1" == "0" ]];then
        echo -ne "\033[0;32mPASS" 
    else
        echo -ne "\033[0;31mFAIL" 
    fi
    echo -e "\0033[0m ] $2"
}

function check
{
    check_os
    check_deps
}

function check_os
{
    echo -n "Checking system… "
    localos=$(uname -s)
    case $localos in
        Linux*) clr green "Linux";;
        Darwin*) clr green "OSX";;
        *) clr red "$localos is not supported"; exit 2 ;;
    esac
}

function check_deps
{
    # bash --version : GNU bash, version 5.1.16(1)-release (x86_64-linux-gnu) + lines
    check_dep bash "5.1.16"
    # bash-completion : ${BASH_COMPLETION_VERSINFO[@]} = (2 11)
    check_dep bash-completion "2.11" "echo ${BASH_COMPLETION_VERSINFO[0]}.${BASH_COMPLETION_VERSINFO[1]}"
    # getopt --version : getopt from|de util-linux 2.37.2
    check_dep getopt "2.37.2"
    # grep --version : grep (GNU grep) 3.7 + lines
    check_dep grep "3.7"
    # sed --version : sed (GNU sed) 4.8 + lines
    check_dep sed "4.8"
    # git --version : git version 2.34.1
    check_dep git "2.34.1"
    # git-annex version : git-annex version: 10.20231227-...... + lines
    check_dep git-annex "10.20231227" "git-annex version"
    # rapper --version : 2.0.15
    check_dep rapper "2.0.15"
    # roqet --version : 0.9.33
    check_dep roqet "0.9.33"
    # dot -V : dot - graphviz version 2.43.0 (0)
    check_dep dot "2.43.0" "dot -V 2&>/dev/stdout"
}

# program verson_arg version_pattern
function check_dep
{
    if check_dep_ver $1 $2 "$3";then
        status 0 "$1 version $2"
    else
        case $? in
            1) status 1 "$1 not found"; return 1 ;;
            2) status 1 "$1 seems to exist but did not behave as excepted"; return 1;;
            3) status 1 "$1 needs to be at least version $2"; return 1;;
        esac
    fi
}

# program min_version [command]
function check_dep_ver
{
    local version
    if [[ "$3" ]];then
        # version="$($3 | grep -Pom1 '\d+\.\d+(\.\d+)?')" || return 2
        echo "$($3 | grep -Pom1 '\d+\.\d+(\.\d+)?')"
    else
        command -v "$1" &>/dev/null || return 1
        version="$($1 --version | grep -Pom1 '\d+\.\d+(\.\d+)?')" || return 2
    fi

    semver $2 $version || return 3

    return 0
}

# ver1 ≤ ver2 ?
function semver
{
    local major1
    local major1
    local minor1
    local patch2
    local minor2
    local patch2

    if [[ $1 =~ ([0-9]+)([.]([0-9]+)([.]([0-9]+))?)? ]];then
        major1="${BASH_REMATCH[1]}"
        minor1="${BASH_REMATCH[3]}"
        patch1="${BASH_REMATCH[5]}"
    fi

    if [[ $2 =~ ([0-9]+)([.]([0-9]+)([.]([0-9]+))?)? ]];then
        major2="${BASH_REMATCH[1]}"
        minor2="${BASH_REMATCH[3]}"
        patch2="${BASH_REMATCH[5]}"
    fi

    [[ $major1 -lt $major2 ]] && return 0
    [[ $major1 -gt $major2 ]] && return 1
    [[ $minor1 -lt $minor2 ]] && return 0
    [[ $minor1 -gt $minor2 ]] && return 1
    [[ $patch1 -lt $patch2 ]] && return 0
    [[ $patch1 -gt $patch2 ]] && return 1
    return 0
}

function install
{
	@echo "Installing git ommix !"
	install -m755 git-ommix /usr/local/bin/git-ommix
	install -m644 example.conf /etc/gitommix.conf

	[ -d /usr/local/share/bash-completion/completions ] && install -m644 gitommix-completions /usr/local/share/bash-completion/completions/git-ommix
}

function uninstall
{
	@echo "Uninstalling…"
	rm -rf /usr/local/bin/git-ommix
	[ -d /usr/local/share/bash-completion/completions ] && rm -rf /usr/local/share/bash-completion/completions/git-ommix
}
