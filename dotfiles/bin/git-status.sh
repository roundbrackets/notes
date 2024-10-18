#!/bin/bash
#

. $HOME/lib/bash/color.inc.sh
. $HOME/lib/bash/funcs.inc.sh
 #xxx

ONLY_STATUS=NO
VERBOSE=YES
DRYRUN=NO
DEBUG=NO

GIT=`which git`

# Find all .git directories that are not in . directories themselves 
# and get the dirname. This should get up the top dir of the cloned
# repo.
p="/Users/tgunnarsson/XXX/"

repos=$(find -E $p -path $HOME/Library -prune -o \( -not -regex '^.*([/][.])+.*/\.git$' -regex '^.*/\.git$' \) -exec dirname {} \; 2>/dev/null)


#repos="/Users/tgunnarsson/XXX/"
repos="/Users/tgunnarsson"
#repos=`pwd`

function _c {
  case $1 in
    r) echo -e -n "${COLOR_BLUE}$2${COLOR_NC}" ;;
    c) echo -e -n "${COLOR_PURPLE}$2${COLOR_NC}" ;;
    u) echo -e -n "${COLOR_LIGHT_BLUE}$2${COLOR_NC}" ;;
    m) echo -e -n "${COLOR_GRAY}$2${COLOR_NC}" ;;

    punct) echo -e -n "${COLOR_CYAN}${2}${COLOR_NC}" ;;

    git) echo -e -n " ${COLOR_YELLOW}+${COLOR_NC} " ;;

    y|Y|X|yes|ahead|"local changes"|nutd) echo -n -e "[${COLOR_RED}$1${COLOR_NC}]" ;;
    n|N|O|no|utd) echo -n -e "[${COLOR_GREEN}$1${COLOR_NC}]" ;;
    *) echo -n -n "$1"
  esac
}

function exec_git_cmd {
  local _cmd="${1}"

  if [[ $ONLY_STATUS = YES ]]; then
     return
  fi
  if [[ $DRYRUN = YES ]]; then 
    header g "DRYRUN: ${_cmd}\n"
    return
  fi

  git_cmd "$_cmd"
  if [[ $? != 0 ]]; then
    exit 1
  fi
}

function header {
  local _type=$1
  local _id=
  local _msg=$3
  local _prefix="`_c punct`"

  [ $_type = g ] && _prefix="`_c git`"

  if [ $# -eq 2 ]; then
    _msg="$2"
  elif [ $# -eq 3 ]; then
    _id=$2
    _msg="$3"
  else
    unset _id; unset _msg
    _prefix="I don't understand."
  fi

  if [[ $VERBOSE != YES ]]; then
    [ $_type = "c" ] && _id=local
    [ $_type = "m" ] && _id=master
    [ $_type = "u" ] && _id=upstream
  fi

  [[ $_id != "" ]] && _id=`_c $_type $_id`

  echo -e -n "${_prefix}${_id} ${_msg}"
}

function fetch_all {
  exec_git_cmd "fetch --all"
}

function stash {
  local _verb=$1

  if [[ $_verb = push ]]; then
    exec_git_cmd "stash --include-untracked"
  elif [[ $_verb = pop ]]; then
    exec_git_cmd "pop"
  else
    header g "${COLOR_LIGHT_RED}WARNING: stash '$_verb' is not valid.${COLOR_NC}\n"
    return 1
  fi
  return 0
}

function rebase {
  exec_git_cmd "rebase $1"
  if [ $? -ne 0 ]; then
    exec_git_cmd "rebase --abort"
    exit 1
  fi
}

function ahead_of_local {
  local _branch=$1 

  if [[ "$(git_remote_changes $_branch)" = "y" ]]; then
    _c ahead
    [[ $VERBOSE = "YES" ]] && git_show_remote_changes $_branch
  else
    return 1
  fi

}


# Loop threough to get the status of each repo.
# Ahead, behaind, behind master and local uncommited changes.
for dir in $repos; do
  pushd $dir

  # No local changes and not a branch.
  _can_update=y

  # Theoretically the find works, but let's make sure
  # git thinks we're in a repo.
  [ ! git_in_repo ] && continue

  repo=`basename $dir`
  fetch_all

  # Get the current branch.
  # I guess you could just read .git/HEAD
  current=`git_get_current`
  if [[ $? -ne 0 ]] || [[ $current = "" ]]; then
    echo -e "${COLOR_RED}ERROR: can't determine current local branch ($dir).${COLOR_NC}"
    continue
  fi
  # Get upstream for our branch.
  upstream=`git_get_upstream`
  if [[ $? -ne 0 ]] || [[ $upstream = "" ]]; then
    echo -e "${COLOR_RED}ERROR: can't determine upstream ($dir).${COLOR_NC}"
    continue
  fi
  # Is this always .git/refs/remotes/origin/HEAD?
  _head=`git_get_head`
  if [[ $? -ne 0 ]] || [[ $_head = "" ]]; then
    echo -e "${COLOR_RED}ERROR: can't determine n branch ($dir).${COLOR_NC}"
    continue
  fi

  # Info about the repo
  printf "%s %s %s %s\n" `_c punct '>'` `_c r $repo` `_c punct '@'` `_c r $dir`
  printf "%s %s " `_c punct '>>'` `_c c $current`

  # Look for local changes, committed but not pushed and
  # staged and unstged.
  # header c "local" "has changed ..."
  if [[ "$(git_local_changes $current)" = "y" ]]; then
    _c "local changes"
    _can_update=n
    [[ $VERBOSE = "YES" ]] && git_show_local_changes $current
  fi

  printf "%s %s " `_c punct '<>'` `_c u $upstream`
  ahead_of_local $upstream

  # upstream isn't head, ie it's a branch
  if [[ $upstream != $_head ]]; then
    printf "%s %s " `_c punct '<<'` `_c m $_head`
    ahead_of_local $_head 
    #_can_update=n
  fi


  # Now let's do the update bit
  # fetch_all

  # Changes on origin/current
  #header u $upstream "ahead of `_c c local` ..."
  #ahead_of_local $upstream
  # if ahead_of_local $upstream; then
    #[[ $_local_changes = y ]] && stash push && _stashed=y
    #rebase $upstream
    #[[ $_local_changes = y ]] && [[ $_stashed = y ]] && stash pop
  # fi

  # if upstream isn't head then we rebase head onto our branch
  if [[ $_can_update = y ]]; then
    echo "HELLO"
    rebase $upstream
  fi

  echo
    continue

  # If we're on a branch check for changes on origin/"master"
  # We're on a branch so
  if [[ $STATUS_ONLY = NO  ]] && [[ $upstream != $_head ]]; then
    _stashed=n

    # check if master ia ahead
    header m $_head "ahead of `_c c local` ..."
    ahead_of_local $_head 
    #if ahead_of_local $_head; then 
      # Let's rebase, but stash first if we need to
      #[[ $_local_changes = y ]] && stash push && _stashed=y

      #rebase $_head
    #fi

    # Commit and push local changes
    if [[ $_local_changes = y ]]; then
      # but pop the stash first
      [[ $_stashed = y ]] && stash pop

      # Commit
       header g "${COLOR_LIGHT_RED}WARNING: Auto commiting local changes.${COLOR_NC}\n"
      exec_git_cmd "commit -m 'git-status auto commit.'"
      if [ $? != 0 ]; then
        header g "${COLOR_RED}ERROR: $_cmd failed${COLOR_NC}\n"
        exit 1
      fi

      # Push
      header g "${COLOR_LIGHT_RED}WARNING: Auto pushing to remote.${COLOR_NC}\n"
      exec_git_cmd "push"
      if [ $? != 0 ]; then
        header g "${COLOR_RED}ERROR: $_cmd failed${COLOR_NC}\n"
        exit 1
      fi
    fi
  fi
  exit
  echo
  popd
done
