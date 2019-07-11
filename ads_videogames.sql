-- Create ADS layer

create database if not exists asd_videogames;
use asd_videogames;

create table if not exists ads_eu
(
  `name` string,
  pid int,
  eu_sales float 
)
PARTITIONED BY (dt int)
ROW FORMAT delimited
fields terminated by ','
stored as orc 
tblproperties ('orc.compress'='ZLIB', 'serialization.null.format'='')


insert overwrite table ads_eu
partition(dt)
select
o.name,
p.id,
o.eu_sales,
o.year_of_release as dt
from
ods_videogames.ods_videogames o
JOIN
md_videogames.platformsid p
ON
(o.platform = p.platform)
;


select * from ads_eu limit 10;
show partitions ads_eu;
desc formatted asd_videogames.ads_eu;