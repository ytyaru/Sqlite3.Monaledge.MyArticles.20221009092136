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

