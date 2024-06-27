create database cran;
use cran;
alter table cran.`cran_logs_2015-01-01` rename TO CRAN;


-- 9.1 give the total number of recordings in this table.
select count(IP_ID) FROM cran;

-- 9.2 the number of packages listed in this table?
select count(distinct(package)) FROM cran;

-- 9.3 How many times the package "Rcpp" was downloaded?
select count(package) from cran
where package = 'Rcpp';

-- 9.4 How many recordings are from China ("CN")?
select count(country) from cran
where country = 'CN';

-- 9.5 Give the package name and how many times they're downloaded. Order by the 2nd column descently.
select package as "Package Name", count(package) as "Number of Downloads" from cran
group by package
order by count(package) desc;

-- 9.6 Give the package ranking (based on how many times it was downloaded) during 9AM to 11AM
select package, ranK() over (order by C desc) as Ranking
from (select package as Package, count(package) as C from cran where TIME between '09:00:00' AND '11:00:00' group by Package) as A;

-- 9.7 How many recordings are from China ("CN") or Japan("JP") or Singapore ("SG")?
select count(package) from cran
where country = 'CN' || country = 'JP' || country = 'SG';

-- 9.8 Print the countries whose downloaded are more than the downloads from China ("CN")
select country from cran
group by country
having count(package) > (select count(package) from CRAN where country= "CN");

-- 9.9 Print the average length of the package name of all the UNIQUE packages.
select package, avg(size) from cran
group by package;

-- 9.10 Get the package whose downloading count ranks 2nd (print package name and it's download count).
select package, c from (select package, c, ranK() over (order by C desc) as Ranking
from (select package as Package, count(package) as C from cran where TIME between '09:00:00' AND '11:00:00' group by Package) as A) as B
where ranking = 2;

-- 9.11 Print the name of the package whose download count is bigger than 1000.
select package, count(package) as "count" from cran
group by package
having count > 1000;

-- 9.12 The field "r_os" is the operating system of the users.
    -- 	Here we would like to know what main system we have (ignore version number), the relevant counts, and the proportion (in percentage).
 SELECT 
    base_os,
    COUNT(*) AS Count,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()), 2) AS "Proportion (%)"
FROM (
    SELECT 
        CASE 
            WHEN r_os LIKE '%-%' THEN SUBSTRING_INDEX(r_os, '-', 1)
            ELSE r_os
        END AS base_os
    FROM cran
) AS derived
GROUP BY base_os
ORDER BY Count DESC;