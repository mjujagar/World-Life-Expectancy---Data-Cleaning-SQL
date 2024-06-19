# World Life Expectancy - Data Cleaning

SELECT * 
FROM worldlifeexpectancy
;

##Removing duplicates

SELECT country, year, concat(country,year), count(concat(country,year))
FROM worldlifeexpectancy 
group by country, year, concat(country,year)
having count(concat(country,year)) > 1
;

Select *
From(
	Select Row_id,
	concat(country,year),
	row_number() Over (Partition by concat(country,year) order by concat (country,year)) as Row_num
	from worldlifeexpectancy 
    ) As Row_table
where Row_num >1
;


Delete from worldlifeexpectancy 
where 
	Row_id IN (
    Select Row_id
From(
	Select Row_id,
	concat(country,year),
	row_number() Over (Partition by concat(country,year) order by concat (country,year)) as Row_num
	from worldlifeexpectancy 
    ) As Row_table
Where Row_num >1
)
;
    
Select *
from worldlifeexpectancy 
where status = ''
;

Select distinct (status)
from worldlifeexpectancy 
where status != ''
;


Select distinct (country)
from worldlifeexpectancy 
where status != 'Developing'
;

Update worldlifeexpectancy 
set status  = 'Developing'
where country  IN (Select distinct (country)
		from worldlifeexpectancy
        where status = 'Developing')
        ;
        

Update worldlifeexpectancy  T1
Join worldlifeexpectancy  t2
	on t1.country = t2.country
set t1.status  = 'Developing'
where t1.status= ''
and t2.status <> ''
and t2.status = 'Developing'
        ;
        
Select *
from worldlifeexpectancy 
where country = 'United States of America'
;

Update T1
Join t2
	on t1.country = t2.country
set t1.status  = 'Developed'
where t1.status= ''
and t2.status <> ''
and t2.status = 'Developed'
;

Select *
from worldlifeexpectancy 
;
        
## Now the table has no nulls or has no blanks fields in status section.
## Now removing all blank fields in other sections

Select *
from worldlifeexpectancy 
where `life expectancy` = ''
; 
## here we have 2 blank field under life Expectancy setion, we now we will take the average 
## of the above field which is 59.5 and the below field which is 58.8 to fill the between field.

Select country, year, 'Life Expectancy'
from worldlifeexpectancy 
;

Select t1.country, t1.year, t1.`Life Expectancy`,
t2.country, t2.year, t2.`Life Expectancy`,
t3.country, t3.year, t3.`Life Expectancy`
from worldlifeexpectancy  t1
Join worldlifeexpectancy  t2
	ON t1.country = t2.country
    AND t1.year =t2.year -1
Join worldlifeexpectancy  t3
	ON t1.country = t3.country
    AND t1.year =t3.year -1    
;

Select t1.country, t1.year, t1.`Life Expectancy`,
t2.country, t2.year, t2.`Life Expectancy`,
t3.country, t3.year, t3.`Life Expectancy`,
Round((t2.`Life Expectancy` + t3.`Life Expectancy`)/2, 1)
from worldlifeexpectancy  t1
Join worldlifeexpectancy  t2
	ON t1.country = t2.country
    AND t1.year =t2.year -1
Join worldlifeexpectancy  t3
	ON t1.country = t3.country
    AND t1.year =t3.year -1 
    where t1.`Life Expectancy` = '' 
;

#Now lets update the section life Expectancy with the new calculations made above and check.

Update worldlifeexpectancy  t1
Join worldlifeexpectancy  t2
	ON t1.country = t2.country
    AND t1.year =t2.year -1 
Join worldlifeexpectancy  t3
	ON t1.country = t3.country
    AND t1.year =t3.year -1 
Set t1.`Life Expectancy` = Round((t2.`Life Expectancy` + t3.`Life Expectancy`)/2, 1)
where t1.`Life Expectancy` = ''
;



Select * from worldlifeexpectancy;


# Hence, we have cleaned the data set and completed 1st project, Data Cleaning Completed!!
