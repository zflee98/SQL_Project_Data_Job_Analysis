-- Course Link https://www.youtube.com/watch?v=7mz73uXD9DA&t=10694s

-- Timestamp 2:54:21
-- Practice Problem 1
-- Timer 4:21.64

SELECT
    q1_job_id.job_id,
    q1_job_id.job_title,
    q1_job_id.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM
    skills_job_dim
RIGHT JOIN
    (
        SELECT
            job_id,
            job_title,
            salary_year_avg
        FROM
            (
                SELECT
                    *
                FROM
                    job_postings_fact
                WHERE
                    EXTRACT(MONTH FROM job_posted_date) = 1
                UNION ALL
                SELECT
                    *
                FROM
                    job_postings_fact
                WHERE
                    EXTRACT(MONTH FROM job_posted_date) = 2
                UNION ALL
                SELECT
                    *
                FROM
                    job_postings_fact
                WHERE
                    EXTRACT(MONTH FROM job_posted_date) = 3
            )
        WHERE
            salary_year_avg > 70000
    ) AS q1_job_id
    ON q1_job_id.job_id = skills_job_dim.job_id
LEFT JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    q1_job_id.salary_year_avg DESC;

-- Timestamp 2:54:35
-- Example Problem 1
-- Timer 1:21.00

SELECT
    job_id,
    job_title,
    job_via,
    salary_year_avg
FROM
    (
        SELECT
            *
        FROM
            job_postings_fact
        WHERE
            EXTRACT(MONTH FROM job_posted_date) = 1
        UNION ALL
        SELECT
            *
        FROM
            job_postings_fact
        WHERE
            EXTRACT(MONTH FROM job_posted_date) = 2
        UNION ALL
        SELECT
            *
        FROM
            job_postings_fact
        WHERE
            EXTRACT(MONTH FROM job_posted_date) = 3
    )
WHERE
    salary_year_avg > 70000 
ORDER BY
    salary_year_avg DESC;

-- Timestamp 2:54:21
-- Practice Problem 1 (again!)
-- Timer 2:57.15

SELECT
    q1_jobs.job_id,
    q1_jobs.job_title,
    q1_jobs.job_via,
    q1_jobs.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM
    skills_job_dim
RIGHT JOIN
    (
        SELECT
            job_id,
            job_title,
            job_via,
            salary_year_avg
        FROM
            (
                SELECT
                    *
                FROM
                    job_postings_fact
                WHERE
                    EXTRACT(MONTH FROM job_posted_date) = 1
                UNION ALL
                SELECT
                    *
                FROM
                    job_postings_fact
                WHERE
                    EXTRACT(MONTH FROM job_posted_date) = 2
                UNION ALL
                SELECT
                    *
                FROM
                    job_postings_fact
                WHERE
                    EXTRACT(MONTH FROM job_posted_date) = 3
            )
        WHERE
            salary_year_avg > 70000
    ) AS q1_jobs
    ON q1_jobs.job_id = skills_job_dim.job_id
LEFT JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    q1_jobs.salary_year_avg DESC;