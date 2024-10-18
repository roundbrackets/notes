. $HOME/lib/bash/color.inc.sh

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

GIT=`which git`

function git_cmd {
  local _cmd="${GIT} ${1}"
  local _prefix=" ${COLOR_YELLOW}+${COLOR_NC} "

  [[ $DEBUG = "YES" ]] && echo -e "${_prefix} ${_cmd}" 1>&2
  eval "${_cmd}"
}

function git_in_repo {
  git_cmd "branch --show-current" &>/dev/null
  if [ $? != 0 ]; then
    echo "git_get_head: not in a git repo" >&2
  fi
  return $?
}

function git_get_head {
  _h=`git_cmd "remote show origin" | sed -n '/HEAD branch/s/.*: //p'`
  echo "origin/$_h"
  # echo "origin/$($git remote show origin | sed -n '/HEAD branch/s/.*: //p')"
}

function git_get_current {
  git_cmd "branch --show-current"
}

function git_get_upstream {
  git_cmd "rev-parse --abbrev-ref --symbolic-full-name @{u}"
}

# Takes a branch as argument.
function git_local_changes {
  if [[ ! $1 ]]; then
    echo "git_local_changes: local branch required" >&2
    exit 1
  fi

  XXXXXX

  # Local uncommited changes
  # git diff --numstat -- will give output
  #
  # Local commited changes
  # git diff --numstat origin/master

  # Commited but not pushed.
  local x=`git_cmd "log $1 --numstat --no-color --not --remotes --oneline --name-status --format="`

#  git log main ^origin/main --cherry-pick --right-only --no-merges --compact-summary --format=

  # Uncommited including untracked, staged, etc 
	local y=`git_cmd "status --short"`
  if [[ $x || $y ]]; then
    echo y
  else
    echo n
  fi
}

function git_show_local_changes {
  if [[ ! $1 ]]; then
    echo "git_show_local_changes: local branch required" >&2
    exit 1
  fi

  echo "git log main --compact-summary --not --remotes --format="
  git log main --compact-summary --not --remotes --format=
  echo "git log main ^origin/main --cherry-pick --left-only --no-merges --compact-summary --format="
  git log main ^origin/main --cherry-pick --left-only --no-merges --compact-summary --format=


	echo -e "  ${COLOR_CYAN}##${COLOR_NC} Commited"
  git_cmd "log $1 --numstat --not --remotes --oneline --name-status --format=" | sed 's/^[ ]*/    /'
	echo -e "  ${COLOR_CYAN}##${COLOR_NC} Untracked, staged, unstaged, .."
  # $git status --short --porcelain | sed 's/^[ ]*/    /'
  git_cmd "-c color.status=always status --short" | sed 's/^[ ]*/    /'
}

# Compares the current branch to the remote head.
function git_remote_changes {
  local u=git_get_upstream
  local b=git_get_current

  git_cmd "fetch --all &>/dev/null"

  x=$(git_cmd "log $u --numstat --no-color --not --branches $b --oneline --name-status --format=")
  if [[ $x ]]; then
    echo y
  else
    echo n
  fi 
}

function git_show_remote_changes {
  local u=git_get_upstream
  local b=git_get_current
  git_cmd "fetch --all &>/dev/null"
  git_cmd "log $u --numstat --not --branches $b --oneline --name-status")
}

function git_current_eq_head {
  local c=$(git_get_current)
  local d=$(git_get_head)

  if [[ $c = $d ]]; then
    echo y
  else
    echo n
  fi
}
