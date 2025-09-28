create database hrdata;
use hrdata;

select * from employees;

-- total employees 
select count(*)as total_employees
from employees;

-- total old employees 
select count(*)as total_old_employees
from employees
where dateoftermination!='';

-- total current employees
select count(*)as total_current_employees
from employees
where dateoftermination='';

--  avg salary 
select avg(salary)as avg_salary
from employees;


-- avg age 
select avg(timestampdiff(Year,str_to_date(DOB,'%d-%m-%Y'),curdate()))as avg_age
from employees;

-- avg years in company 
select avg(timestampdiff(Year,str_to_date(dateofhire,'%d-%m-%Y'),curdate()))as avg_years_in_company
from employees;

-- adding new column for employee current status
alter table employees
add employeecurrentstatus int;

-- updating values for new column 
set sql_safe_updates=0;
update employees
set employeecurrentstatus=case
when dateoftermination='' Then 1 else 0
end;

-- calculate attrition rate based on custom empstatusid values 
select (cast(count(case when employeecurrentstatus=0 then 1 end)as float)/count(*))*100 as attrition_rate
from employees;

-- get column names and data types 
describe employees;


-- print 1st 5 rows 
select * from employees 
limit 5;

-- print last 5 rows 
select * from employees
order by empid desc 
limit 5;

-- changin data type of salarty
alter table employees 
modify column salary decimal(10,2);


-- convert all date columnws in proper dates
update employees 
set dob=str_to_date(dob,'%d-%m-%Y');
update employees
set dateofhire=str_to_date(dateofhire,'%d-%m-%Y');
update employees
set lastperformanceReview_Date=str_to_date(lastperformancereview_date,'%d-%m-%Y');



alter table employees 
modify column DOB Date,
modify column dateofhire date,
modify column lastperformancereview_date Date;


-- read columns to check changes 
select dob,dateofhire,dateoftermination,lastperformancereview_date
from employees;


-- fill empty values in date of termnination 
update employees 
set dateoftermination='currently working'
where dateoftermination is null or dateoftermination='';

-- count of each unique value in the maritaldesc
select maritaldesc,count(*)as count
from employees
group by maritaldesc
order by count desc;

-- count of each unique value in the department
select department,count(*)as count
from employees
group by department
order by count desc;


-- count of each unique value in the position
select position,count(*)as count
from employees
group by position
order by count desc;

-- count of each unique value in the managername
select managername,count(*)as count
from employees
group by managername
order by count desc;

-- salary distribution by employees 
select 
case 
when salary<30000 then'<30k>'
when salary between 30000 and 49999 then '30k-49k'
when salary between 50000 and 69999 then '50k-69k'
when salary between 70000 and 89999 then '70k-89k'
when salary >=90000 then '90k and above'
end as salary_range,
count(*)as frequency
from employees group by salary_range order by salary_range;



-- performance score 
select performancescore,
count(*)as count 
from employees
group by performancescore
order by performancescore;

-- avg salary by departmnet
select Department,
avg(salary)as averagesalary
from employees
group by department
order by department;


-- count termination by cause
select TermReason,
count(*)as count 
from employees
where TermReason is not null
group by TermReason 
order by count desc;

-- employees count of state 
select state, count(*)as count
from employees 
group by state 
order by count desc;

-- gendwr distribution 
select gender,count(*) as count 
from employees 
group by gender 
order by count desc;


-- getting age distribution 
-- add new column age 
alter table employees
add column age int;

-- update the age column with calculated agr 
update employees
set age=timestampdiff(year,dob,curdate());


 -- age distribution 
 select
 case 
 when age<20 then'<20'
 when age between 20 and 29 then '20-29'
  when age between 30 and 39 then '30-39'
   when age between 40 and 49 then '40-49'
    when age between 50 and 59 then '50-59'
    when age>=60 then '60 and above'
    end as age_range,
    count(*)as count
    from employees
    group by age_range;
    
    -- absenves by department
    select department,
    sum(absences)as totalabsences
    from employees
    group by department
    order by totalabsences desc;
    
    
-- salary distribution by gender
select 
gender,
sum(salary)as totalsalary
from employees
group by gender 
order by totalsalary desc;


-- count of employees terminated as per marital status
select maritaldesc,count(*)as terminatedcount
from employees
where termd=1
group by maritaldesc
order by terminatedcount desc;

-- avg absence by performance score 
select performancescore,
avg(absences)as averageabsences
from employees
group by performancescore
order by performancescore;

-- employee count by recruitment score 
select recruitmentsource,count(*)as employeecount
from employees
group by recruitmentsource
order by employeecount desc;


