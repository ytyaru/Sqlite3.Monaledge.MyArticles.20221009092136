create table if not exists users(
    id integer not null primary key,
    --user_id integer not null unique,
    address text not null unique,
    created integer not null,
    updated integer not null,
    name text not null,
    icon_image_path text
);

