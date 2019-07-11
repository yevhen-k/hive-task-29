
-- Create MD data table

create database if not exists md_videogames;
use md_videogames;

-- two steps solution
-- select distinct platform from ods_videogames;
-- SELECT *, ROW_NUMBER() OVER () AS row_num from ods_videogames limit 10;

-- one step solution
create table platformsid as select *, ROW_NUMBER() OVER() as id 
from (select distinct platform from ods_videogames.ods_videogames)distinct_platforms;

