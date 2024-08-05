/*
Course Link https://www.youtube.com/watch?v=7mz73uXD9DA&t=10694s
Timestamp 3:14:57
- Skills for Top 20 highest paid Data Analyst jobs
*/

SELECT
    job_id_top_10.job_id,
    job_title,
    company_name,
    salary_year_avg,
    skills,
    type
FROM
    skills_job_dim
RIGHT JOIN
    (
    SELECT
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim
        ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        salary_year_avg IS NOT NULL AND
        job_title_short = 'Data Analyst'
    ORDER BY
        salary_year_avg DESC
    LIMIT 20
    ) AS job_id_top_10
    ON job_id_top_10.job_id = skills_job_dim.job_id
LEFT JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id