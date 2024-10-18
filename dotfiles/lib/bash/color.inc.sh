COLOR_NC='\033[0m' # No Color
COLOR_BLACK='\033[0;30m'
function cblack {
  echo -e -n "${COLOR_BLACK}$1${COLOR_NC}"
}
COLOR_GRAY='\033[1;30m'
function cgray {
  echo -e -n "${COLOR_GRAY}$1${COLOR_NC}"
}
COLOR_RED='\033[0;31m'
function cred {
  echo -e -n "${COLOR_RED}$1${COLOR_NC}"
}
COLOR_LIGHT_RED='\033[1;31m'
function clight_red {
  echo -e -n "${COLOR_LIGHT_RED}$1${COLOR_NC}"
}
COLOR_GREEN='\033[0;32m'
function cgreen {
  echo -e -n "${COLOR_GREEN}$1${COLOR_NC}"
}
COLOR_LIGHT_GREEN='\033[1;32m'
function clight_green {
  echo -e -n "${COLOR_LIGHT_GREEN}$1${COLOR_NC}"
}
COLOR_BROWN='\033[0;33m'
function cbrown {
  echo -e -n "${COLOR_BROWN}$1${COLOR_NC}"
}
COLOR_YELLOW='\033[1;33m'
function cyellow {
  echo -e -n "${COLOR_YELLOW}$1${COLOR_NC}"
}
COLOR_BLUE='\033[0;34m'
function cblue {
  echo -e -n "${COLOR_BLUE}$1${COLOR_NC}"
}
COLOR_LIGHT_BLUE='\033[1;34m'
function clight_blue {
  echo -e -n "${COLOR_LIGHT_BLUE}$1${COLOR_NC}"
}
COLOR_PURPLE='\033[0;35m'
function cpurple {
  echo -e -n "${COLOR_PURPLE}$1${COLOR_NC}"
}
COLOR_LIGHT_PURPLE='\033[1;35m'
function clight_purple {
  echo -e -n "${COLOR_LIGHT_PURPLE}$1${COLOR_NC}"
}
COLOR_CYAN='\033[0;36m'
function ccyan {
  echo -e -n "${COLOR_CYAN}$1${COLOR_NC}"
}
COLOR_LIGHT_CYAN='\033[1;36m'
function clight_cyan {
  echo -e -n "${COLOR_LIGHT_CYAN}$1${COLOR_NC}"
}
COLOR_LIGHT_GRAY='\033[0;37m'
function cgray {
  echo -e -n "${COLOR_GRAY}$1${COLOR_NC}"
}
COLOR_WHITE='\033[1;37m'
function cwhite {
  echo -e -n "${COLOR_WHITE}$1${COLOR_NC}"
}
