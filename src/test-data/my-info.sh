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
	[ $# -eq 0 ] && ADDRESS=MEHCqJbgiNERCH3bRAtNSSD9uxPViEX1nu || ADDRESS=$1
	URL=https://monaledge.com:8443
	API_MYINFO=$URL/myInfo
	DATA_MYINFO='{"address":"'$ADDRESS'"}'
	HEADER='Content-Type:application/json'

	API=$API_MYINFO
	DATA=$DATA_MYINFO
	#curl -X POST -H $HEADER -d "$DATA" $API
	JSON="$(curl -X POST -H $HEADER -d "$DATA" $API)"
	AUTHOR_ID="$(echo "$JSON" | jq .id)"
	echo "$JSON" > "my-info-${AUTHOR_ID}.json"
}
Run "$@"
