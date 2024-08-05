/*
Course Link https://www.youtube.com/watch?v=7mz73uXD9DA&t=10694s
Timestamp 3:14:57
- Top 10 skills for Data Analyst jobs by demand (job count)
*/

SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS job_count
FROM
    skills_job_dim
INNER JOIN
    job_postings_fact
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    job_count DESC
LIMIT 
    10;