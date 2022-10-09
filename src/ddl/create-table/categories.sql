-- https://github.com/Raiu1210/omaemona_front/blob/8174d5d0ff5f37370a7f7f9fd8fdb60daca4ddd1/myModules/categoryUtils.js
create table if not exists categories(
    id integer not null primary key,
    name text not null unique
);
