# older prompts comes here, the newest is the bottom
#export PS1='\W$(__git_ps1 "(%s)") () \> '
#export PS1='USER \w \n$(__git_ps1 "(%s)") > '
# the \n does not work for new line after branch information, so I left the branch info on a new line
# last prompt used:
#export PS1='\[\033]0;$MSYSTEM:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[32m\]MarceloBRAmaral \[\033[33m\]\w\n\[\033[00m\]$(__git_ps1 "(%s)")> '

###############################
# COLOR TABLE:                #
#COLOR_NONE='\[\033[0m\]'     #
# MAGENTA="\[\033[0;35m\]"    #
# YELLOW="\[\033[01;32m\]"    #
#YELLOW='\[\033[1;33m\]'      #
# BLUE="\[\033[00;34m\]"      #
#LIGHT_BLUE='\[\033[1;34m\]'  #
# LIGHT_GRAY="\[\033[0;37m\]" #
# CYAN="\[\033[0;36m\]"       #
#LIGHT_CYAN='\[\033[1;36m\]'  #
# GREEN="\[\033[00m\]"        #
#GREEN='\[\033[0;32m\]'       #
#LIGHT_GREEN='\[\033[1;32m\]' #
# RED="\[\033[0;31m\]"        #
#LIGHT_RED='\[\033[1;31m\]'   #
# VIOLET='\[\033[01;35m\]'    #
#WHITE='\[\033[1;37m\]'       #
#BLACK='\[\033[0;30m\]'       #
#PURPLE='\[\033[0;35m\]'      #
#LIGHT_PURPLE='\[\033[1;35m\]'#
#GRAY='\[\033[1;30m\]'        #
#LIGHT_GRAY='\[\033[0;37m\]'  #
###############################


# new propt based on site http://ezprompt.net/
# mods added:
# 1. replace \u for MarceloBRAmaral (github user)
# 2. green color for user
# 3. yellow for path
# 4. white for branch
# 5. added > before prompt
# 6. moved branch to new line
# 7. color red for untracked status
# 8. color green for new file
# 9. color red for deleted


# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	#COLOR="\033[31m"
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		COLOR=`get_color`
		echo -e "$COLOR[${BRANCH}${STAT}]\033[0m"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then		
		bits="?${bits}"		
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

#get color for branch status
function get_color {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	color=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		color="\033[0;32m${color}"
	fi
	if [ "${untracked}" == "0" ]; then
		color="\033[31m${color}"				
	fi
	if [ "${deleted}" == "0" ]; then
		color="\033[31m${color}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${color}" == "" ]; then
		echo "${color}"
	else
		echo ""
	fi
}

export PS1="\[\033[32m\]MarceloBRAmaral \[\033[33m\]\w \n\[\033[00m\]\`parse_git_branch\` >"
