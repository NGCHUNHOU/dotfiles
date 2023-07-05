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

# CACHED=0; 
# if [[ -f ~/.bashCache ]]; then 
# 	CACHED=1;
# 	source ~/.bashCache;
# fi
 
# reloadPath() {
# 	echo "reloading PATH..."
# 	exepath=$(find $BINARYGROUPDIR -name "*.exe" -printf "%h\n" | sort | uniq)
# 	for text in $(echo ${exepath[@]} | sed "s/ /:/g"); do
# 		BINPATH="$BINPATH$text"
# 	done
# 	export PATH=$PATH:$BINPATH
# 
# 	BINARYGROUPDIRNEWLIST=($BINARYGROUPDIR)
# 	DIROLDSUM=$DIRSUM
# 	if [[ "${CACHED}" == 1 ]]; then rm ~/.bashCache; fi
# 	typeset -p PATH BINARYGROUPDIRNEWLIST DIROLDSUM > ~/.bashCache
# }
 
# if [[ "${DIRSUM}" != "${DIROLDSUM}" ]]; then
# 	reloadPath
# else
# 	if [[ "${CACHED}" == 0 ]]; then reloadPath; fi
# fi

defaultShimPath=~/winapps/shims
defaultBinaryPath=~/winapps/apps
defaultBashCache=~/.bashShimCache
shimPath=~/winapps/shim.exe
currentDirCount=$(ls -l "$defaultBinaryPath" | grep -c ^d)
isDirCountCached() {
	if [[ ! -f "$defaultBashCache" ]]; then
		echo "$defaultBashCache not found, creating it and exit..."
		cacheDirCount=$(ls -l "$defaultBinaryPath" | grep -c ^d)
		typeset -p cacheDirCount > "$defaultBashCache"
		return 1
	fi
	return 0
}

mkshim() {
    isDirCountCached || return 1
	source "$defaultBashCache"

	# shim wont reload if defaultBinaryPath does not have new directory added
    if [[ "$currentDirCount" = "$cacheDirCount" ]]; then 
		echo "No new directory can be found at $defaultBinaryPath, aborting..."
		return 1 
	fi

    if [[ ! -d "$defaultShimPath" || ! -d "$defaultBinaryPath" || ! -f "$shimPath" ]]; then
        echo "$defaultShimPath or $defaultBinaryPath or $shimPath cannot be found, edit those variables at ~/.bashrc, aborting..."
        return 1
    fi

    if [[ -n "$1" ]]; then
        if [[ ! -f "$1" ]]; then
            echo "No such binary file can be used for shim: $1"
            return 1
        fi
		echo "making shim file for target binary..."
        binaryPath="$1"
        fileName="${binaryPath##*/}"
        fileName="${fileName%.*}"
        touch "${defaultShimPath}/${fileName}.shim"
        winpath=$(cygpath -w "$binaryPath")
        shimFileContent="path = \"$winpath\""
        echo "$shimFileContent" > "${defaultShimPath}/${fileName}.shim"
        cp "$shimPath" "${defaultShimPath}/${fileName}.exe"

		cacheDirCount="$currentDirCount"
		typeset -p cacheDirCount > "$defaultBashCache"

        return 0
    fi

	echo "start reloading shim files..."
	pathsList=$(find "$defaultBinaryPath" -name "*.exe")
	for fullpath in ${pathsList[@]}; do
		fileNameWithExt="${fullpath##*/}"
		fileName="${fileNameWithExt%.*}"
		touch "${defaultShimPath}/${fileName}.shim"
		winpath=$(cygpath -w "$fullpath")
		shimFileContent="path = \"$winpath\""
		echo "$shimFileContent" > ${defaultShimPath}/${fileName}.shim
		cp "$shimPath" "${defaultShimPath}/$fileNameWithExt"
	done

	cacheDirCount="$currentDirCount"
	typeset -p cacheDirCount > "$defaultBashCache"
    return 0
}

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
