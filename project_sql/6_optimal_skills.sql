/*
Course Link https://www.youtube.com/watch?v=7mz73uXD9DA&t=10694s
Timestamp 3:14:57
- Order skills by both salary and demand with a minimum threshold for demand
*/

SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS job_count,
    ROUND(AVG(salary_year_avg), 0) AS salary_year_avg
FROM
    skills_job_dim
INNER JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN
    job_postings_fact
    ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
GROUP BY
    skills
HAVING
    COUNT(job_postings_fact.job_id) > 50
ORDER BY
    salary_year_avg DESC,
    job_count DESC;