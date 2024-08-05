-- Course Link https://www.youtube.com/watch?v=7mz73uXD9DA&t=10694s

-- Timestamp 2:20:20
-- Practice Problem 1
-- Timer 1:39.99

SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS salary_year,
    AVG(salary_hour_avg) AS salary_hour
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'::DATE
GROUP BY
    job_schedule_type
HAVING
    AVG(salary_year_avg) IS NOT NULL
ORDER BY
    salary_year DESC;

-- Timestamp 2:20:20
-- Practice Problem 2
-- Timer 1:46.07

SELECT
    EXTRACT(MONTH FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EDT')) AS month,
    count(job_id) AS job_count
FROM
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EDT')) = 2023
GROUP BY
    month
ORDER BY
    month;

-- Timestamp 2:20:20
-- Practice Problem 3a (Join)
-- Timer 2:59.11

SELECT DISTINCT
    company_dim.company_id,
    company_dim.name
FROM
    company_dim
RIGHT JOIN
    job_postings_fact
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_health_insurance = TRUE AND
    (EXTRACT(MONTH FROM job_posted_date) BETWEEN 4 AND 6) AND
    EXTRACT(YEAR FROM job_posted_date) = 2023;

-- Timestamp 2:20:20    
-- Practice Problem 3b (Subquery)
-- Timer 1:42.65

SELECT
    company_id,
    name
FROM
    company_dim
WHERE
    company_id IN
    (
        SELECT
            company_id
        FROM
            job_postings_fact
        WHERE
            job_health_insurance = TRUE AND
            (EXTRACT(MONTH FROM job_posted_date) BETWEEN 4 AND 6) AND
            EXTRACT(YEAR FROM job_posted_date) = 2023
    )