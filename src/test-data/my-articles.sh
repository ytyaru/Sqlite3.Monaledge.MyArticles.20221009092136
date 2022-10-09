#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# モナレッジAPIの動作確認をする。
# CreatedAt: 2022-10-07
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	[ -f 'error.sh' ] && . error.sh
	AUTHOR_ID=92
	PAGE=1
	[ 1 -eq $# ] && { PAGE=$1; }
	[ 2 -le $# ] && { AUTHOR_ID=$1; PAGE=$2; }

	URL=https://monaledge.com:8443
	API_MYARTICLES=$URL/myArticles
	DATA_MYARTICLES='{"page":'$PAGE',"author_id":'$AUTHOR_ID'}'
	HEADER='Content-Type:application/json'

	API=$API_MYARTICLES
	DATA=$DATA_MYARTICLES
	#curl -X POST -H $HEADER -d "$DATA" $API
	JSON="$(curl -X POST -H $HEADER -d "$DATA" $API)"
	echo "$JSON" > "my-articles.json"
}
Run "$@"
