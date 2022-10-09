#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# モナレッジで自分の記事をバックアップするためのDBやテーブルを作る。
# CreatedAt: 2022-10-09
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	# 必要コマンドのインストール
	IsExistCmd() { type "$1" > /dev/null 2>&1; }
	Install() { IsExistCmd "$1" || sudo apt install -y "$1"; }
	for cmd in {sqlite3,jq}; do { Install "$cmd"; } done;
	# DBファイルとテーブルの作成
	[ 0 -lt $# ] && DB="$1" || DB='monaledge.db'
	CreateTable() {
		echo '===== DBファイルとテーブルの作成 ====='
		IS_INS=0
		[ -f "$DB" ] || IS_ISN=1
		while read -r path; do
			echo "file: $path"
			sqlite3 "$DB" < $path
		done < <(find ./ddl/create-table/*.sql )
		SQL='select * from sqlite_master;'
		sqlite3 "$DB" "$SQL" 
		[ 1 -eq $IS_INS ] && sqlite3 "$DB" < './dml/insert/categories.sql' || :
	}
	CreateTable
	# テストデータ挿入
	Escape() { echo "$(cat -)" | sed -e "s/'/''/g"; }
	enclose() { echo "$(cat -)" | sed -e 's/^/(/' | sed -e 's/$/)/'; }
	InsertArticle() {
		echo '===== テストデータ挿入 ====='
		SQL="select count(*) from articles where id = 454;"
		EXISTS="$(sqlite3 "$DB" "$SQL")"
		echo "$EXISTS"
		[ 0 -eq $EXISTS ] && {
			JSON="$(cat 'test-data/article-454.json')"
			ARTICLE_ID="$(echo "$JSON" | jq .id)"
			TITLE="$(echo "$JSON" | jq -r .title | Escape)"
			CONTENT="$(echo "$JSON" | jq -r .content | Escape)"
			SENT_MONA="$(echo "$JSON" | jq -r .sent_mona)"
			ACCESS="$(echo "$JSON" | jq -r .access)"
			OGP_PATH="$(echo "$JSON" | jq -r .ogp_path | Escape)"
			CATEGORY="$(echo "$JSON" | jq -r .category)"
			CREATED="$(echo "$JSON" | jq -r .createdAt)"
			UPDATED="$(echo "$JSON" | jq -r .updatedAt)"
			SQL="insert into articles(id,created,updated,title,sent_mona,access,ogp_path,category,content) values($ARTICLE_ID,'$CREATED','$UPDATED','$TITLE',$SENT_MONA,$ACCESS,'$OGP_PATH',$CATEGORY,'$CONTENT')"
			echo "$SQL"
			sqlite3 "$DB" "$SQL"
		}
		SQL="select * from articles;"
		sqlite3 "$DB" "$SQL"
	}
	InsertArticle
#	InsertComments() {
#		JSON="$(cat 'test-data/article-454.json')"
#		COMMENT_ID="$(echo "$JSON" | jq comments[].id)"
#		="$(echo "$JSON" | jq .)"
#		="$(echo "$JSON" | jq .)"
#		="$(echo "$JSON" | jq .)"
#		="$(echo "$JSON" | jq .)"
#		="$(echo "$JSON" | jq .)"
#		="$(echo "$JSON" | jq .)"
#		="$(echo "$JSON" | jq .)"
#		="$(echo "$JSON" | jq .)"
#	}
	#done < <(find ./hoge -mindepth 1 -maxdepth 1)
	# https://qiita.com/m-sakano/items/7f1afc7eb452a1a57015
	# select edit('AAA', 'vim'); したあと表示が壊れるので
	stty sane
}
Run "$@"
