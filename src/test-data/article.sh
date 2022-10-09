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

	ARTICLE_ID=454
	#ARTICLE_ID=558
	[ 0 -gt $# ] && { ARTICLE_ID=$1; } || :;

	URL=https://monaledge.com:8443
	API_ARTICLE=$URL/article?id=$ARTICLE_ID
	HEADER='Content-Type:application/json'

	API=$API_ARTICLE
	#curl  -H $HEADER $API
	JSON="$(curl  -H $HEADER $API)"
	ARTICLE_ID="$(echo "$JSON" | jq .id)"
	echo "$JSON" > "article-${ARTICLE_ID}.json"
}
Run "$@"
