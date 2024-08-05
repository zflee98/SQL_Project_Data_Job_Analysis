/*
Course Link https://www.youtube.com/watch?v=7mz73uXD9DA&t=10694s
Timestamp 3:14:57
- Order skills by both salary and demand with a minimum threshold for demand
*/

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS demand,
    AVG(salary_year_avg) AS salary_year_avg
FROM
    skills_job_dim
INNER JOIN
    job_postings_fact
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(job_postings_fact.job_id) > 50
ORDER BY
    salary_year_avg DESC,
    demand DESC
LIMIT
    25;