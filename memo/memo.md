# モナレッジの記事を保存するDBを作る【SQLite3】

　自分の記事さえ保存できればいいので少しは楽になるはず。

<!-- more -->

# ブツ

* [リポジトリ][]

[リポジトリ]:https://github.com/ytyaru/Sqlite3.Monaledge.MyArticles.20221009092136

# 実行

```sh
NAME='Sqlite3.Monaledge.MyArticles.20221009092136'
git clone https://github.com/ytyaru/$NAME
$NAME/src/run.sh
```

# 方法

　[モナレッジAPIを調べた][]ときコードにあるJSONから必要な列と型と名前を抜き出してSQLテーブルに落とし込む。

[モナレッジAPIを調べた]:

# DB

## Table

* `users`
* `articles`
* `comments`
* `categories`

# SQL

## users

```sql
create table if not exists users(
    id integer not null primary key,
    address text not null unique,
    created integer not null,
    updated integer not null,
    name text not null,
    icon_image_path text
);
```

## articles

```sql
create table if not exists articles(
    id integer not null primary key,
    created text not null,
    updated text not null,
    title text not null,
    sent_mona text not null,
    access integer not null,
    ogp_path text not null,
    category integer not null,
    content text not null
);
```

## comments

```sql
PRAGMA foreign_keys=true;
create table if not exists comments(
    id integer not null primary key,
    --comment_id integer not null unique,
    article_id integer not null,
    created integer not null,
    updated integer not null,
    user_id integer not null,
    content text not null,
    foreign key (article_id) references articles(id)
);
```

## categories

```sql
create table if not exists categories(
    id integer not null primary key,
    name text not null unique
);
insert into categories(id,name) values (0,'未分類'),(1,'その他'),(2,'暗号通貨'),(3,'モナコイン'),(4,'温泉'),(5,'神社・お寺'),(6,'趣味'),(10,'カーライフ'),(7,'日記'),(8,'IT技術'),(9,'ガジェット'),(11,'本'),(12,'創作話'),(13,'怖い話');
```

　[categoryUtils.js][]を参考にした。

[categoryUtils.js]:https://github.com/Raiu1210/omaemona_front/blob/8174d5d0ff5f37370a7f7f9fd8fdb60daca4ddd1/myModules/categoryUtils.js

# テストデータ挿入

　ちゃんと挿入できるか試してみた。article APIを発行して得たJSONをテキストファイルに保存し、そこからデータを抽出して`insert`文を発行する。

```sh
Escape() { echo "$(cat -)" | sed -e "s/'/''/g"; }
InsertArticle() {
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
    SQL="select * from articles;"
    sqlite3 "$DB" "$SQL"
}
InsertArticle
```

　成功した。

## 失敗例

## SQLのメタ文字`'`が本文にあると構文エラーになる

　SQLのメタ文字であるシングルクォーテーション`'`が記事本文のマークダウン内に存在していたとき、そのマークダウンをSQLで`insert`しようとすると構文エラーになる。

```sql
SQL="insert into articles(article_id,created,updated,title,sent_mona,access,ogp_path,category,content) values($ARTICLE_ID,'$CREATED','$UPDATED','$TITLE',$SENT_MONA,$ACCESS,'$OGP_PATH',$CATEGORY,'$CONTENT')"
sqlite3 "$DB" "$SQL"
```

```sh
Error: in prepare, near "MEHCqJbgiNERCH3bRAtNSSD9uxPViEX1nu": syntax error
  \n```javascript\nconst cpParams = {\n    source: 'MEHCqJbgiNERCH3bRAtNSSD9uxPV
                                      error here ---^
```

　これはマークダウン内にJavaScriptのソースコードが書かれていて、その中で文字列を表現するときにシングルクォートが使われている。こうしたことはよくあることなので、シングルクォートがあっても動作するようにしたい。

　そこでシングルクォートをエスケープする必要がある。`''`のように2つ連続にすることでエスケープできる。

```sh
sed -e "s/'/''/g"
```

　関数化したのが以下。パイプで受け取ったテキストに対してエスケープをかける。

```sh
Escape() { echo "$(cat -)" | sed -e "s/'/''/g"; }
```

-->

