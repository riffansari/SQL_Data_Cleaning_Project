# SQL_Data_Cleaning_Project
End-to-end SQL data cleaning project showcasing data standardization, validation, duplicate detection and missing value handling in MySQL.

## Project Overview

This project focuses on cleaning and preparing a raw dataset using MySQL. The goal was to identify and resolve common data quality issues to create a dataset that is accurate. consistent, and ready for use.

Throughout the project, I followed a structured data cleaning process and documented all the steps that I used along with the queries. 

### Dataset

The dataset contains member information of a club, including:

Full Name
Age
Marital Status
Email
Phone Number
Address
Job Title
Membership Date

### Objectives
- Assess the quality of the raw dataset.
- Standardize inconsistent data.
- Correct invalid values and formatting issues.
- Detect duplicate records.
- Handle missing values appropriately.
- Prepare the dataset for future use.

## Data Cleaning Process

The following steps were carried out during the cleaning process:

- Inspected the dataset structure and record count.
- Created a staging table to preserve the original data.
- Standardized text fields by removing extra spaces, converting text to lowercase and correcting inconsistencies.
- Corrected spelling mistakes in categorical values.
- Converted data to its correct data type.
- Identified unrealistic numerical values. 
- Detected duplicate records using window functions.
- Reviewed and handled missing values based on the type of data.

### SQL Concepts Used
- SELECT
- UPDATE
- ALTER 
- WHERE
- GROUP BY
- Aggregate Functions (COUNT, MIN, MAX)
- CASE Expressions
- Common Table Expressions (CTEs)
- Window Functions (ROW_NUMBER)
- Regular Expressions (REGEXP_REPLACE)
- Date Functions (STR_TO_DATE, DATE_ADD)

### Tools
MySQL

### Author
Riffa Ansari 


