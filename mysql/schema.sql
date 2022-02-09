create schema if not exists devmysql;

CREATE TABLE IF NOT EXISTS devmysql.ARTICLES(
    id          INTEGER PRIMARY KEY,
    title      VARCHAR(100) ,
    author      VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS devmysql.artists(
    artist_id          INTEGER PRIMARY KEY,
    name      VARCHAR(100) ,
    nationality      VARCHAR(20) ,
    gender      VARCHAR(20) ,
    birth_year      VARCHAR(20) ,
    death_year      VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS devmysql.artworks(
    artwork_id          INTEGER PRIMARY KEY,
    title      VARCHAR(50) ,
    artist_id      INTEGER ,
    name      VARCHAR(200) ,
    date      VARCHAR(50) ,
    medium      VARCHAR(50),
    dimensions      VARCHAR(50),
    acquisition_date      VARCHAR(50),
    credit      VARCHAR(50),
    catalogue      VARCHAR(50),
    department      VARCHAR(50),
    classification      VARCHAR(50),
    object_number      VARCHAR(50),
    diameter_cm      VARCHAR(50),
    circumference_cm      VARCHAR(50),
    height_cm      VARCHAR(50),
    length_cm      VARCHAR(50),
    width_cm      VARCHAR(50),
    depth_cm      VARCHAR(50),
    weight_kg      VARCHAR(50),
    durations      VARCHAR(50)
);