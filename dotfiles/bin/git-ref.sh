#!/bin/bash

source ~/lib/bash/color.inc.sh

echo -e ${COLOR_GREEN}'Rebase recent commits: '${COLOR_CYAN}'git rebase -i <after-this-commit>'${COLOR_NC}
echo -e "${COLOR_GREEN}Rebase recent commits: ${COLOR_CYAN}git rebase -i <after-this-commit>${COLOR_NC}"
printf '%sRebase recent commits: %sgit rebase -i <after-this-commit>%s\n' ${COLOR_GREEN} ${COLOR_CYAN} ${COLOR_NC}
printf '%sRebase recent commits: %sgit rebase -i <after-this-commit>%s\n' "${COLOR_GREEN}" "${COLOR_CYAN}" "${COLOR_NC}"
