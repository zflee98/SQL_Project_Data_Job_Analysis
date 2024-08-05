-- Course Link https://www.youtube.com/watch?v=7mz73uXD9DA&t=10694s

-- Timestamp 2:30:20
-- Practice Problem 1
-- Timer 1:54.63

SELECT
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg < 70000 THEN 'Low'
        WHEN salary_year_avg > 120000 THEN 'High'
        ELSE 'Medium'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;
