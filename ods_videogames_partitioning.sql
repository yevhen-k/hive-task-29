-- https://stackoverflow.com/questions/52034614/dynamic-partition-insert-hive
-- https://stackoverflow.com/questions/27535363/hive-creating-a-table-but-getting-failed-semanticexception-error-10035-colum/31427598
-- Different number of columns in raw and ods!!!!!


set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

insert overwrite table ods_videogames
partition(dt)
select
*,
source.year_of_release as dt
from raw_videogames.cleaned as source
;


-- Basic stats:
-- show partitions ods_videogames;
-- desc formatted ods_videogames.ods_videogames;
-- select * from ods_videogames limit 10;
-- select max(user_score) from ods_videogames;
-- select * from ods_videogames where user_score=(select max(user_score) from ods_videogames);
-- select count(*) from ods_videogames where `platform` is NULL limit 10;
-- select critic_score, length(cast(critic_score as string)) from ods_videogames where critic_score is NULL limit 10;
-- select rating, length(rating) from ods_videogames where rating is NULL or length(rating)=1 limit 10;