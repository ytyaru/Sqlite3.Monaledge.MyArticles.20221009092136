create table if not exists articles(
    id integer not null primary key,
    --article_id integer not null unique,
    created text not null,
    updated text not null,
    title text not null,
    --sent_mona decimal not null,
    --sent_mona integer not null,
    sent_mona text not null,
    access integer not null,
    ogp_path text not null,
    category integer not null,
    content text not null
);

