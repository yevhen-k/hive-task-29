-- in two queries with temporary table

-- create table tmp as
--   with topsales as (select max(eu_sales) as m, dt as d from ads_eu group by dt)
--   select name, pid, eu_sales, dt from ads_eu
--   join topsales on topsales.m = ads_eu.eu_sales and topsales.d = ads_eu.dt
-- ;

-- with mapper as (select id, platform from md_videogames.platformsid)
-- select name, pid, eu_sales, dt, platform from
-- tmp join mapper on mapper.id = pid;

-- in one query w/o temporary table

with topsales as (select max(eu_sales) as m, dt as d from ads_eu group by dt),
joined as (
  select name, pid, eu_sales, dt from ads_eu
  join topsales on topsales.m = ads_eu.eu_sales and topsales.d = ads_eu.dt
),
mapper as (select id, platform from md_videogames.platformsid)
select name, platform, eu_sales, dt from
topsales join mapper on mapper.id = pid;