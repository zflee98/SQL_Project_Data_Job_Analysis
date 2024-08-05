/*
Course Link https://www.youtube.com/watch?v=7mz73uXD9DA&t=10694s
Timestamp 3:14:57
- Top 50 skills for Data Analyst jobs by salary
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS salary_year_avg
FROM
    skills_job_dim
INNER JOIN
    (
        SELECT
            job_id,
            salary_year_avg
        FROM
            job_postings_fact
        WHERE
            salary_year_avg IS NOT NULL AND
            job_title_short = 'Data Analyst'
    ) AS job_postings_with_salary
    ON job_postings_with_salary.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY
    skills
ORDER BY
    salary_year_avg DESC
LIMIT
    50;