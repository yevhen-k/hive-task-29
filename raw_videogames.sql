-- Create RAW data table
create database if not exists raw_videogames;
USE raw_videogames;
CREATE EXTERNAL TABLE IF NOT EXISTS raw_videogames.raw_videogames 
(
    name string
  , platform string
  , year_of_release int
  , genre string
  , publisher string
  , na_sales float
  , eu_sales float
  , jp_sales float
  , other_sales float
  , global_sales float
  , critic_score int
  , critic_count int
  , user_score int
  , user_count int
  , developer string
  , rating string
)
COMMENT 'table for raw input data about game markenig'
ROW FORMAT delimited
fields terminated by '|'
-- ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
-- WITH SERDEPROPERTIES
-- (
--     'separatorChar'=',',
--     'quoteChar'='\"'
-- )
stored as textfile
location '/user/tg/raw-output-games'
TBLPROPERTIES('serialization.null.format'='');


-- Basic stats

-- show databases;
-- show tables in raw_videogames;
-- desc raw_videogames;
-- desc raw_videogames.raw_videogames;
-- desc formatted raw_videogames.raw_videogames;
-- select * from raw_videogames where name like '%,%';
-- select developer from raw_videogames where developer is NULL limit 10;
