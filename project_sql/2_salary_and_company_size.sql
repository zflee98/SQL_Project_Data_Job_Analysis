/*
Course Link https://www.youtube.com/watch?v=7mz73uXD9DA&t=10694s
Timestamp 3:14:57
- Is there any correlation between salary and company size (job count) for Data Analysts? Pearson's r and t-test
*/

SELECT
    (sum_xy - n * mean_x * mean_y) / SQRT((sum_x2 - n * mean_x * mean_x) * (sum_y2 - n * mean_y * mean_y)) AS pearsons_r,
    ((sum_xy - n * mean_x * mean_y) / SQRT((sum_x2 - n * mean_x * mean_x) * (sum_y2 - n * mean_y * mean_y)) * SQRT(n - 2)) / SQRT(1 - (sum_xy - n * mean_x * mean_y) / SQRT((sum_x2 - n * mean_x * mean_x) * (sum_y2 - n * mean_y * mean_y)) * (sum_xy - n * mean_x * mean_y) / SQRT((sum_x2 - n * mean_x * mean_x) * (sum_y2 - n * mean_y * mean_y))) AS t_ratio,
    n - 2 AS degrees_freedom
FROM
    (
    SELECT
        -- x as job_count
        -- y as salary_year_avg
        SUM(job_count * salary_year_avg) AS sum_xy,
        AVG(job_count) AS mean_x,
        AVG(salary_year_avg) AS mean_y,
        COUNT(*) AS n,
        SUM(job_count * job_count) AS sum_x2,
        SUM(salary_year_avg * salary_year_avg) AS sum_y2
    FROM
        (
        SELECT
            company_id,
            COUNT(job_id) AS job_count,
            AVG(salary_year_avg) AS salary_year_avg
        FROM
            job_postings_fact
        WHERE
            job_title_short = 'Data Analyst'
        GROUP BY
            company_id
        HAVING
            AVG(salary_year_avg) IS NOT NULL
        ORDER BY
            job_count DESC
        ) 
    );



    
