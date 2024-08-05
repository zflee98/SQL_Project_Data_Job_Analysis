-- Course Link https://www.youtube.com/watch?v=7mz73uXD9DA&t=10694s

-- Timestamp 2:33:39
-- Example Problem 1: List of company names with no degree
-- Timer 56.35

SELECT
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
            job_no_degree_mention = TRUE
    )

-- Timestamp 2:37:42
-- Example Problem 2: List of company names with the most job openings
-- Timer 1:49.09

WITH job_count_by_company AS 
(
    SELECT
        company_id,
        COUNT(job_id) AS job_count
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    company_dim.company_id,
    name,
    job_count
FROM
    company_dim
LEFT JOIN
    job_count_by_company
    ON job_count_by_company.company_id = company_dim.company_id
ORDER BY
    job_count DESC;

-- Timestamp 2:41:55
-- Practice Problem 1
-- Timer 2:24.73

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    job_count_by_skills.job_count
FROM
    skills_dim
INNER JOIN
    (
        SELECT
            skill_id,
            COUNT(job_id) AS job_count
        FROM
            skills_job_dim
        GROUP BY
            skill_id
    ) AS job_count_by_skills
    ON job_count_by_skills.skill_id = skills_dim.skill_id
ORDER BY
    job_count_by_skills.job_count DESC
LIMIT
    5;

-- Timestamp 2:41:55
-- Practice Problem 2
-- Timer 2:54.95

SELECT
    company_dim.company_id,
    company_dim.name,
    job_count_by_company.job_count,
    CASE
        WHEN job_count_by_company.job_count < 10 THEN 'Small'
        WHEN job_count_by_company.job_count > 50 THEN 'Large'
        ELSE 'Medium'
    END AS size_category
FROM
    company_dim
INNER JOIN
    (
        SELECT
            company_id,
            COUNT(job_id) AS job_count
        FROM
            job_postings_fact
        GROUP BY
            company_id
    ) AS job_count_by_company
    ON job_count_by_company.company_id = company_dim.company_id
ORDER BY
    job_count_by_company.job_count DESC;

-- Timestamp 2:42:26
-- Example Problem 3
-- Timer 3:28:46

SELECT
    skills_dim.skill_id,
    skills,
    job_count_by_skills.job_count
FROM
    skills_dim
INNER JOIN
    (
        SELECT
            skill_id,
            COUNT(job_postings_fact.job_id) AS job_count
        FROM
            skills_job_dim
        INNER JOIN
            job_postings_fact
            ON skills_job_dim.job_id = job_postings_fact.job_id
        WHERE
            job_work_from_home = TRUE
        GROUP BY
            skill_id
    ) AS job_count_by_skills
    ON job_count_by_skills.skill_id = skills_dim.skill_id
ORDER BY
    job_count_by_skills.job_count DESC
LIMIT 
    5;
