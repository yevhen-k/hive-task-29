-- Create ODS data table with ORC and partitioning by year_of_release

create database if not exists ods_videogames;
use ods_videogames;
CREATE TABLE IF NOT EXISTS ods_videogames.ods_videogames 
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
COMMENT 'table for ods video games data. cleaned up of NULLs'
-- PARTITIONED BY (dt int) <- because of serde
PARTITIONED BY (dt int)
ROW FORMAT delimited
fields terminated by ','
stored as orc 
tblproperties ('orc.compress'='ZLIB', 'serialization.null.format'='')
-- TBLPROPERTIES('serialization.null.format'='')
;


-- Basic stats:
-- show partitions ods_videogames;
-- show columns from ods_videogames;