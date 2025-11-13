CREATE DATABASE salary_analysis;
USE salary_analysis;

CREATE TABLE salary_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    age_range VARCHAR(20),
    industry VARCHAR(150),
    job_title VARCHAR(150),
    clarification_of_job_title VARCHAR(255),
    annual_salary DECIMAL(15,2),
    additional_monetary_compensation DECIMAL(15,2),
    currency VARCHAR(10),
    income_clarification VARCHAR(255),
    country VARCHAR(100),
    state VARCHAR(100),
    city VARCHAR(100),
    years_experience_overall VARCHAR(50),
    years_experience_in_field VARCHAR(50),
    highest_education VARCHAR(100),
    gender VARCHAR(50)
);
ALTER TABLE salary_data MODIFY COLUMN currency VARCHAR(50);
ALTER TABLE salary_data MODIFY COLUMN city VARCHAR(255);
ALTER TABLE salary_data MODIFY COLUMN income_clarification TEXT;
ALTER TABLE salary_data MODIFY COLUMN clarification_of_job_title TEXT;
ALTER TABLE salary_data MODIFY COLUMN country VARCHAR(255);
ALTER TABLE salary_data MODIFY COLUMN state VARCHAR(255);
ALTER TABLE salary_data MODIFY COLUMN industry VARCHAR(255);

select*from salary_data;

SHOW VARIABLES LIKE 'secure_file_priv';

USE salary_analysis;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Cleaned.csv'
INTO TABLE salary_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, 
 @col9, @col10, @col11, @col12, @col13, @col14, @col15, @ignore1, @ignore2)
SET
age_range = @col1,
industry = @col2,
job_title = @col3,
clarification_of_job_title = @col4,
annual_salary = REPLACE(REPLACE(@col5,'¹',''),',',''),
additional_monetary_compensation = REPLACE(REPLACE(@col6,'¹',''),',',''),
currency = @col7,
income_clarification = @col8,
country = @col9,
state = @col10,
city = @col11,
years_experience_overall = @col12,
years_experience_in_field = @col13,
highest_education = @col14,
gender = @col15;




SELECT COUNT(*) FROM salary_data;
SELECT * FROM salary_data LIMIT 10;



DESC salary_data; 


# Average Salary by Industry and Gender
SELECT 
    industry,
    gender,
    ROUND(AVG(annual_salary), 2) AS avg_salary
FROM salary_data
WHERE annual_salary > 0
GROUP BY industry, gender
ORDER BY industry, gender;

# Total Salary Compensation by Job Title
SELECT 
    job_title,
    SUM(annual_salary + IFNULL(additional_monetary_compensation, 0)) AS total_compensation
FROM salary_data
GROUP BY job_title
ORDER BY total_compensation DESC;

#Salary Distribution by Education Level
SELECT 
    highest_education,
    ROUND(AVG(annual_salary), 2) AS avg_salary,
    MIN(annual_salary) AS min_salary,
    MAX(annual_salary) AS max_salary
FROM salary_data
GROUP BY highest_education
ORDER BY avg_salary DESC;

#Number of Employees by Industry and Years of Experience

SELECT 
    industry,
    years_experience_overall,
    COUNT(*) AS employee_count
FROM salary_data
GROUP BY industry, years_experience_overall
ORDER BY industry;

# Median Salary by Age Range and Gender

SELECT 
    age_range,
    gender,
    ROUND(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(
                GROUP_CONCAT(annual_salary ORDER BY annual_salary SEPARATOR ','), 
                ',', 
                (COUNT(*) + 1) / 2
            ),
            ',', 
            -1
        ),
    2) AS median_salary
FROM salary_data
WHERE annual_salary IS NOT NULL AND annual_salary > 0
GROUP BY age_range, gender
ORDER BY age_range, gender;

# Job Titles with the Highest Salary in Each Country

SELECT 
    country,
    job_title,
    MAX(annual_salary) AS highest_salary
FROM salary_data
GROUP BY country, job_title
ORDER BY country;

#Average Salary by City and Industry
SELECT 
    city,
    industry,
    ROUND(AVG(annual_salary), 2) AS avg_salary
FROM salary_data
GROUP BY city, industry
ORDER BY avg_salary DESC;

#Percentage of Employees with Additional Compensation by Gender
SELECT 
    gender,
    ROUND(
        (SUM(CASE WHEN additional_monetary_compensation > 0 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS percent_with_bonus
FROM salary_data
GROUP BY gender;

# Total Compensation by Job Title and Years of Experience
SELECT 
    job_title,
    years_experience_overall,
    SUM(annual_salary + IFNULL(additional_monetary_compensation, 0)) AS total_compensation
FROM salary_data
GROUP BY job_title, years_experience_overall
ORDER BY total_compensation DESC;

# Average Salary by Industry, Gender, and Education Level

SELECT 
    industry,
    gender,
    highest_education,
    ROUND(AVG(annual_salary), 2) AS avg_salary
FROM salary_data
GROUP BY industry, gender, highest_education
ORDER BY industry, gender;

