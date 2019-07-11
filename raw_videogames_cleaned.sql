-- Create cleaned up table with datatypes

drop table cleaned;
create table cleaned as select *
from raw_videogames.raw_videogames
where
`name` is not NULL and length(regexp_replace(`name`, '\\t', '')) > 0 and
platform is not NULL and length(regexp_replace(platform, '\\t', '')) > 0 and
year_of_release is not NULL and 
genre is not NULL and length(regexp_replace(genre, '\\t', '')) > 0 and
publisher is not NULL and length(regexp_replace(publisher, '\\t', '')) > 0 and
na_sales is not NULL and
eu_sales is not NULL and
jp_sales is not NULL and
other_sales is not NULL and
global_sales is not NULL and
critic_score is not NULL and
critic_count is not NULL and
user_score is not NULL and
user_count is not NULL and
developer is not NULL and length(regexp_replace(developer, '\\t', '')) > 0 and
rating is not NULL and length(regexp_replace(rating, '\\t', '')) > 0;


-- no need to load data to table because table is external
-- load data inpath 'VideoGamesSalesNoHeader.csv'
-- overwrite into table raw_videogames;


-- Basic stats:
-- select * from raw_videogames limit 10;
-- select min(year_of_release) from raw_videogames;
-- select count(*) from raw_videogames;
-- select * from raw_videogames where critic_count=(select max(critic_count) from raw_videogames);