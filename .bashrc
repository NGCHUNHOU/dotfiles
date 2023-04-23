# bash rc file for window os

alias vifm="winpty vifm"
alias python="winpty python"
alias fzf="winpty fzf"
alias mysql="winpty mysql"
alias restic="winpty restic"
alias nvim="winpty nvim"
alias fzv="fzf --bind \"enter:execute(vim {})\""

# enable ctrl-u and ctrl-d to move up and down when fzf
export FZF_DEFAULT_OPTS='--bind ctrl-u:page-up,ctrl-d:page-down'

BINARYGROUPDIR="/d/winapps/apps/"
DIRSUM=$(ls -l $BINARYGROUPDIR | grep -c "^d\|\-")

. /usr/bin/z.sh

CACHED=0; 
if [[ ! -f ~/.bashCache ]]; then 
	CACHED=1;
	source ~/.bashCache;
fi

if [[ "${DIRSUM}" != "${DIROLDSUM}" ]]; then
	echo "reloading PATH..."
	exepath=$(find $BINARYGROUPDIR -name "*.exe" -printf "%h\n" | sort | uniq)
	for text in $(echo ${exepath[@]} | sed "s/ /:/g"); do
		BINPATH="$BINPATH$text"
	done
	export PATH=$PATH:$BINPATH

	BINARYGROUPDIRNEWLIST=($BINARYGROUPDIR)
	DIROLDSUM=$DIRSUM
	if [[ "${CACHED}" == 1 ]]; then rm ~/.bashCache; fi
	typeset -p PATH BINARYGROUPDIRNEWLIST DIROLDSUM > ~/.bashCache
fi

PROGDEPS="vim fzf rg z"
MISSINGPROGS=""

for PROG in ${PROGDEPS[@]}; do
	if ! command -v $PROG &> /dev/null; then
		MISSINGPROGS+=" $PROG"
	fi
done

if [[ $MISSINGPROGS != "" ]];then 
	echo $MISSINGPROGS "required for vim extra features";
fi

# custom command function
function rgv() { vim -c "silent grep \"$@\"" -c "copen"; }

source /d/winapps/apps/alacritty/alacritty.bash

if command -v fff &> /dev/null; then
	f() {
	    fff "$@"
	    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
	}
fi

pathFixfileName="msysCmdPathFix.cmd"
makeMsysCmdPath() {
if [ ! -f "/usr/bin/$pathFixfileName" ]; then
echo "$pathFixfileName not found. creating default $pathFixfileName"
cat << EOF > "/usr/bin/$pathFixfileName"
@ECHO OFF
IF defined ORIGINAL_PATH (
SET "PATH=%ORIGINAL_PATH%"
)
IF "%1"=="" cmd
@ECHO ON
%*
EOF
fi
}

makeMsysCmdPath "$pathFixfileName"

alias cmd="$pathFixfileName"
alias npm="cmd npm $@"
alias pnpm="cmd pnpm $@"
