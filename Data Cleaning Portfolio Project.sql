-- Data Exploration and Cleaning

-- To display the structure of the table including column names and data types. 

describe members_info;

## Membership date in text data type. 
## Phone numbers are stored as text, don't change them to INT because no calculations happening on Phone Number

-- To count the total number of records in the table.
select count(*) 
from members_info;

-- To display the first 20 records from the table for initial inspection of data. 

select * 
from members_info
limit 20;

## The full_name contains a mix of uppercase and lowercase characters, special characters like(???) and white spaces.
## The column name martial_status has a spelling mistake. 

-- Before cleaning the data it is advisable to create a new table to not change the original dataset. 

create table stg_members_info AS 
select * 
from members_info;

select * 
from stg_members_info
limit 20;

-- Remove unwanted special characters from the column.

select REGEXP_REPLACE(full_name, '[^A-Za-z ]', '') 
from stg_members_info;
 
-- Remove leading/trailing spaces to ensure names have consistent spacing and improved readability. 

select REGEXP_REPLACE(TRIM(full_name), '\\s+', ' ') 
from stg_members_info;

--  Covert all names to lowercase. This standardizes text formatting, making searches and duplicate detection more consistent.

select lower(full_name) 
from stg_members_info;

-- If you are satisfied with the result, update the table for consistent text standardization.

update stg_members_info
set full_name = lower(
    REGEXP_REPLACE(
        REGEXP_REPLACE(trim(full_name), '[^A-Za-z ]', ''),
        '\\s+',' ')
);

-- Rename the column name martial status to remove spelling mistake and avoid confusion.

alter table stg_members_info
rename column martial_status to marital_status;

-- Retrieve all unique values in the column to identify inconsistent entries or spelling variations. 

select distinct marital_status
from stg_members_info;

-- The word 'divorced' is misspelled as 'divored' and made into a distinct value which can intefere with the grouping, filtering and analysis.

update member_info
set marital_status = 'divorced'
where marital_status = 'divored';

-- Retrieve distinct values for Phone Numbers:

select distinct phone
from stg_members_info;

-- Some phone numbers are not exactly 12 digits including '-', or following the format. To check those numbers"

select phone
from stg_members_info
where phone NOT REGEXP '^[0-9]{3}-[0-9]{3}-[0-9]{4}$';

-- Five phone numbers were found out which had missing digits. 
-- We cannot determine the missing digits that is why it is advisable to flag them as null/invalid. 

update stg_members_info
set phone = NULL
where phone NOT REGEXP '^[0-9]{3}-[0-9]{3}-[0-9]{4}$';

-- Moving on to columns, 'email', 'full_address' 'job_title' to check their distinct values

select distinct email
from stg_members_info;

select distinct full_address
from stg_members_info;

select distinct job_title
from stg_members_info;

-- Nothing flagged as inconsistent. 

-- As mentioned earlier, membership date has a data type of text, which should be date. 

-- Make sure that all the dates are in standard date format, e.g: Month/Date/Year.

update stg_members_info
set membership_date = STR_TO_DATE(membership_date, '%m/%d/%Y');

-- Then change the column's data type from text to DATE.

alter table stg_members_info
modify column membership_date date;

describe stg_members_info;
# The membership_date is now in Date data type.

-- Retrieve the minimum and maximum values for age and membership_date.
-- It helps identify outliers and invalid values that should be corrected before analysis.

select min(age) as min_age, 
	   max(age) as max_age,
       min(membership_date) as min_date,
       max(membership_date) as max_date
from stg_members_info;
## Age and date both have invalid values that need correction.

-- Identify records with ages outside the expected range (18–100 years) to detect unrealistic age values.

select *
from stg_members_info
where age <18 OR age > 100;
## The records  contain unrealistic age values e.g. 522, 277. 

-- Since the intended ages cannot be determined with confidence, these values are replaced with NULL instead of making assumptions.

update stg_members_info
set age = NULL
where age > 100;

--  Identify records with membership dates earlier than the expected time period.

select *
from stg_members_info
WHERE membership_date < '2000-01-01';
## The invalid years fall between 1912 and 1921, while the rest of the dataset ranges from 2012 to 2022. This suggests century error during data entry.

-- Correct century errors by adding 100 years to membership dates before 2000.

update stg_members_info
set membership_date = DATE_ADD(membership_date, INTERVAL 100 YEAR)
where membership_date < '2000-01-01';

-- Everything is standarized and formatted now. We can move on to detects duplicates now. 

-- Check Duplicates using a window function

WITH duplicate_cte AS (
	 select *, 
             ##assign a row number to each record
             row_number() over(
             partition by full_name, age, marital_status, email, phone, full_address, job_title, membership_date
             order by membership_date
             ) as row_num
from stg_members_info
)
select *
from duplicate_cte
where row_num > 1;

-- Identifying missing values in text based columns.

select * 
from stg_members_info 
where full_name is null or full_name = ''
or marital_status is null or marital_status = ''
or email is null or email = ''
or full_address is null or full_address = ''
or job_title is null or job_title = ''
or phone is null or phone = '';

-- Identifying NULL values in int or date based column.

select *
from stg_members_info
where age is null 
or membership_date is null;

-- Replace missing values in the marital_status column with 'Unknown', because it can not be inferred by dataset.

update stg_members_info
set marital_status = 'Unknown'
where marital_status IS NULL or marital_status =  '';

-- Replace missing values in the phone column with 'Unknown', because it can not be inferred by dataset.

update stg_members_info
set phone = 'Unknown'
where phone IS NULL or phone =  '';

-- Replace missing values in the job_title column with 'Unknown', because it can not be inferred by dataset.

update stg_members_info
set job_title = 'Unknown'
where job_title IS NULL or job_title =  '';


## The treatment of NULL values depended on the nature of the data. 
## Where the correct value could not be reliably inferred, the missing value was retained as NULL to preserve data integrity e.g. for AGE. 
## For categorical fields, the missing values were replaced with 'Unknown' to indicate unavailable information while maintaining consistency. 
## No assumptions were made to estimate missing values to ensure that the dataset remained accurate and unbiased.


