# bash rc file for window os

alias vifm="winpty vifm"
alias python="winpty python"
alias fzf="winpty fzf"
alias mysql="winpty mysql"
alias restic="winpty restic"
alias nvim="winpty nvim"
alias fzv="fzf --bind \"enter:execute(vim {})\""

BINARYGROUPDIR="/d/winapps/apps/"
DIRSUM=$(ls -l $BINARYGROUPDIR | grep -c "^d\|\-")

. /usr/bin/z.sh

if [[ ! -f ~/.bashCache ]]; then 
	CACHED=0; 
else
	CACHED=1;
	source ~/.bashCache;
fi

if [[ $CACHED == 0 || "${DIRSUM}" != "${DIROLDSUM}" ]]; then
	echo "reloading PATH..."
	exepath=$(find $BINARYGROUPDIR -name "*.exe" -printf "%h\n" | sort | uniq)
	for text in $(echo ${exepath[@]} | sed "s/ /:/g"); do
		BINPATH="$BINPATH$text"
	done
	export PATH=$PATH:$BINPATH

	BINARYGROUPDIRNEWLIST=($BINARYGROUPDIR)
	DIROLDSUM=$DIRSUM
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
