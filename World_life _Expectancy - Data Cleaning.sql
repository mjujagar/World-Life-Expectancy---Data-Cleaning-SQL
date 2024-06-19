# World Life Expectancy - Data Cleaning

SELECT * 
FROM world_life_expectancy
;

##Removing duplicates

SELECT country, year, concat(country,year), count(concat(country,year))
FROM world_life_expectancy
group by country, year, concat(country,year)
having count(concat(country,year)) > 1
;

Select *
From(
	Select Row_id,
	concat(country,year),
	row_number() Over (Partition by concat(country,year) order by concat (country,year)) as Row_num
	from world_life_expectancy
    ) As Row_table
where Row_num >1
;


Delete from world_life_expectancy
where 
	Row_id IN (
    Select Row_id
From(
	Select Row_id,
	concat(country,year),
	row_number() Over (Partition by concat(country,year) order by concat (country,year)) as Row_num
	from world_life_expectancy
    ) As Row_table
Where Row_num >1
)
;
    
Select *
from world_life_expectancy
where status = ''
;

Select distinct (status)
from world_life_expectancy
where status != ''
;


Select distinct (country)
from world_life_expectancy
where status != 'Developing'
;

Update world_life_expectancy
set status  = 'Developing'
where country  IN (Select distinct (country)
		from world_life_expectancy
        where status = 'Developing')
        ;
        

Update world_life_expectancy T1
Join world_life_expectancy t2
	on t1.country = t2.country
set t1.status  = 'Developing'
where t1.status= ''
and t2.status <> ''
and t2.status = 'Developing'
        ;
        
Select *
from world_life_expectancy
where country = 'United States of America'
;

Update world_life_expectancy T1
Join world_life_expectancy t2
	on t1.country = t2.country
set t1.status  = 'Developed'
where t1.status= ''
and t2.status <> ''
and t2.status = 'Developed'
;

Select *
from world_life_expectancy
;
        
## Now the table has no nulls or has no blanks fields in status section.
## Now removing all blank fields in other sections

Select *
from world_life_expectancy
where `life expectancy` = ''
; 
## here we have 2 blank field under life Expectancy setion, we now we will take the average 
## of the above field which is 59.5 and the below field which is 58.8 to fill the between field.

Select country, year, 'Life Expectancy'
from world_life_expectancy
;

Select t1.country, t1.year, t1.`Life Expectancy`,
t2.country, t2.year, t2.`Life Expectancy`,
t3.country, t3.year, t3.`Life Expectancy`
from world_life_expectancy t1
Join world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.year =t2.year -1
Join world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year =t3.year -1    
;

Select t1.country, t1.year, t1.`Life Expectancy`,
t2.country, t2.year, t2.`Life Expectancy`,
t3.country, t3.year, t3.`Life Expectancy`,
Round((t2.`Life Expectancy` + t3.`Life Expectancy`)/2, 1)
from world_life_expectancy t1
Join world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.year =t2.year -1
Join world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year =t3.year -1 
    where t1.`Life Expectancy` = '' 
;

#Now lets update the section life Expectancy with the new calculations made above and check.

Update world_life_expectancy t1
Join world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.year =t2.year -1 
Join world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year =t3.year -1 
Set t1.`Life Expectancy` = Round((t2.`Life Expectancy` + t3.`Life Expectancy`)/2, 1)
where t1.`Life Expectancy` = ''
;

Select *
from world_life_expectancy
; 

# Hence, we have cleaned the data set, Data Cleaning Completed!!