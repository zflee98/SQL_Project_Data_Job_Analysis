# Introduction
Explores Luke Barousse's data job data set of 2023 from his course: [SQL for Data Analytics - Learn SQL in 4 Hours](https://www.youtube.com/watch?v=7mz73uXD9DA). In particular, provides empirical analysis of the correlation between salary and company size and optimal skills for highly rewarding roles in Data Analysis.

SQL queries used: [project_sql](/project_sql/)

# Background
Motivated by a desire to expand and refine my fledgling data analysis skills. 

Data and theme of queries follows [Luke Barousse's SQL Course](https://www.lukebarousse.com/sql) with some personal tweaks, my own code and an additional investigation of the correlation between company size and salary.

### Questions answered through SQL queries:
1. What are the top-paying Data Analyst job postings?
2. Is there any correlation between salary and company size?
3. What are the skill prerequisites for top-paying Data Analyst jobs?
4. Using frequency in job postings as an indicator for demand, what are the skills with the highest demand?
5. Using high-paying jobs with prerequisite skills as an indicator for skill value, what are the most valuable skills to have?
6. Combining demand and value, what are the optimal skills to possess or pursue as a Data Analyst?

# Tools I Used
- **SQL**: Used for sieving through the database for key insights.
- **PostgreSQL**: Used as the database.
- **Visual Studio Code**: Used as a proxy IDE to manage the database and execute SQL queries.
- **Excel**: For visualizing query results.
- **Git & GitHub**: Used for version control and sharing my analysis.

# The Analysis
Each query is aimed at investigating commonalities in highly-rewarding Data Analyst roles.

### 1. Top Paying Jobs
This query retrieves and sorts the top 20 highest-paying Data Analyst jobs, including job and company details, making sure to filter out entries with null salaries.

```SQL
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
LIMIT 20;
```

### Breakdown of query result:
1. **Top Salaries:**
   - Highest salaries are for specialized or senior roles, like the **Data Analyst** at **Mantys** ($650,000) and **Head of Infrastructure Management & Data Analytics** at **Citigroup, Inc** ($375,000).
2. **Key Locations:**
   - **San Francisco, CA** has several high-paying positions ($240,000 - $350,000), as does **Austin, TX** and **New York, NY**, which are significant hubs for competitive salaries.
3. **Role Variety:**
   - Job titles vary from **Data Analyst** to **Director of Analytics**, with salaries reflecting the role’s seniority and specialization, ranging from **$240,000** to **$650,000**.

![Top Paying Roles](assets\query_1.png)
*Bar graph visualizing the salary distribution for top 20 paying Data Analyst jobs; I used Excel to generate this graph from my SQL query results.*

### 2. Salary & Company Size
This query investigates the relationship between company size (empirically defined by job posting count) and salary for Data Analyst jobs.

```SQL
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
```
### Breakdown of query result:
1. **Pearson's Correlation Coefficient (`pearsons_r`):** 
   - **0.0388**: Indicates a very weak positive correlation between `job_count` and `salary_year_avg`. The small value suggests a minimal linear relationship.

2. **T-Ratio (`t_ratio`):**
   - **2.0475**: Shows the ratio of the correlation coefficient to its standard error. This value is used to test if the correlation is statistically significant.

3. **Degrees of Freedom (`degrees_freedom`):**
   - **2780**: Represents the number of independent values that can vary. This is used in statistical tests to determine significance.

In summary, the correlation between job count and salary is very weak, but the correlation is statistically significant based on the t-ratio.

### 3. Skills For Top Jobs
This query determines what skills are highly sought-after for highly-paying Data Analyst roles.

```SQL
SELECT
    job_id_top_20.job_id,
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
    ) AS job_id_top_20
    ON job_id_top_20.job_id = skills_job_dim.job_id
LEFT JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
```
### Breakdown of query result:
1. **SQL**: Count: 15. Frequently listed across multiple positions, including roles at companies like Anthropic, TikTok, and Pinterest, SQL is crucial for managing and querying databases.

2. **Python**: Count: 13. Another highly sought-after skill, Python appears in many job descriptions, such as those from Care.com, Walmart Global Tech, and Illuminate Mission Solutions, emphasizing its importance in data analysis and scripting.

3. **Tableau**: Count: 7. This data visualization tool is mentioned in several roles, including those at Care.com and AT&T, highlighting its importance in creating dashboards and visualizing data insights.
Certainly! Here’s a summary of the top three skills based on their frequency, along with counts and other relevant skills:

4. **Other Relevant Skills**
- Excel: Mentioned 6 times, relevant for data analysis and reporting.
- Power BI: Found 5 times, important for data visualization and business intelligence.
- R: Listed 5 times, used for statistical analysis and data visualization.
- Spark: Appears 3 times, important for big data processing and analytics.
- AWS, Azure, Snowflake, BigQuery: Various cloud platforms mentioned, indicating their relevance in managing and analyzing data in the cloud.
- Hadoop: Noted 1 time, used for big data processing and storage.

These skills highlight the diverse technical expertise needed for data-related roles, emphasizing proficiency in data manipulation, visualization, and cloud technologies.

### 4. Top Skills By Demand
This query delves deeper into the highly in-demand skills for Data Analyst roles by using prevalence in job postings as an indicator for demand.

```SQL
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
    5;
```
### Breakdown of query result:
1. **Data Management and Analysis**:
   - **Skills Included**: SQL, Excel, Python
   - **Explanation**: SQL is essential for querying and managing databases, Excel is widely used for data manipulation and analysis, and Python offers advanced data analysis capabilities through its extensive libraries. Together, these skills cover a broad range of data management and analytical tasks, from basic data handling to complex programming and data science applications.

2. **Data Visualization and Reporting**:
   - **Skills Included**: Tableau, Power BI
   - **Explanation**: Tableau and Power BI are both powerful tools for creating interactive data visualizations and reports. They help in transforming complex data sets into intuitive and actionable insights through visual means, making them crucial for effective data communication and decision-making.

![Top Demand Skills](assets\query_4.png)
*Bar graph visualizing the top 10 skills by demand (prevalence in Data Analyst job postings); I used Excel to generate this graph from my SQL query results for 10 positions instead of 5.*

### 5. Top Skills By Salary
This query switches crosshairs onto the highly valuable skills for Data Analyst roles by using average salary in job postings as an indicator for value.
```SQL
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
```
### Breakdown of query result:
1. **Highest Paying Skill**: The skill with the highest average annual salary is SVN, with an impressive $400,000. This suggests that expertise in SVN is highly valued and may be linked to specialized roles or industries that offer significant compensation.

2. **Notable Tech Skills**: Skills related to modern programming and data technologies also command high salaries. For instance, Solidity, Couchbase, and DataRobot have average annual salaries around $160,000 to $179,000. These skills are likely in high demand due to their application in cutting-edge technologies and data-driven decision-making.

3. **Strong Demand for Data and Cloud Technologies**: Many skills associated with data management and cloud technologies feature prominently with high salaries. Skills such as Terraform, VMware, and Databricks have average salaries in the $140,000 to $150,000 range. This reflects the growing importance and value of expertise in cloud infrastructure and data analytics tools.

![Top Value Skills](assets\query_5.png)
*Bar graph visualizing the top 20 skills by value (average salary in Data Analyst job postings); I used Excel to generate this graph from my SQL query results for 20 positions instead of 50.*

### 6. Optimal Skills
This query is a composite of the previous two, highlighting skills that are both rewarding and in high demand, pinpointing areas for further development for a Data Analyst.

```SQL
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
    demand DESC;
```
### Breakdown of query result:
1. **Emerging Technologies**: Skills like **Airflow** and **Databricks** are highly valued, indicating a strong demand for expertise in modern data orchestration and big data platforms. This reflects the growing importance of managing complex data workflows and large datasets.

2. **Cloud-Based Solutions**: **GCP** (Google Cloud Platform) and **Snowflake** rank high, highlighting the increasing preference for cloud-based solutions in data analytics. Organizations are investing in cloud technologies to enhance scalability, performance, and data management.

3. **High Demand for Data Engineering**: Skills related to data engineering, such as **Hadoop** and **Spark**, are among the top earners. This suggests a significant market value for professionals who can handle large-scale data processing and analytics, which are crucial for deriving insights from big data.

These insights reflect trends in data analytics and emphasize the value of advanced technologies and cloud solutions in the industry.

| **Skill**     | **Demand** | **Average Annual Salary** |
|---------------|------------|----------------------------|
| Airflow       | 71         | $116,387.26                |
| Scala         | 59         | $115,479.53                |
| Linux         | 58         | $114,883.20                |
| Confluence    | 62         | $114,153.12                |
| GCP           | 78         | $113,065.48                |
| Spark         | 187        | $113,001.94                |
| Databricks    | 102        | $112,880.74                |
| Git           | 74         | $112,249.64                |
| Snowflake     | 241        | $111,577.72                |
| Hadoop        | 140        | $110,888.27                |

*This table highlights the skills with the highest average annual salaries, reflecting their significant value in the data analysis field.*

# What I Learned
Thanks to Luke Barousse's course, I've expanded and polished my SQL skills considerably:
1. **Query Crafting**: Ranging from keywords, functions and query structure down to complex subqueries, CTEs and join functions.
2. **Hands-on Experience**: Applying my SQL know-how to an actual project with insights that are relevant to data analysis roles.
3. **Analytical Approach**: Translating complex and relevant questions into actionable and insightful SQL queries.

# Conclusions
1. Top Paying Jobs: Data Analyst roles offer decent salaries, with the highest roles varying greatly, and the very highest at $650,000.
2. Salary & Company Size: Larger company sizes have a slightly positive correlation with higher salaries, suggesting a company that specialises in data analytics provides higher salaries. However, this may just be survivorship bias.
3. Skills for Top Jobs: Highest paying Data Analyst roles require proficiency in SQL.
4. Top Skills By Demand: Data analysis, management, visualization and reporting are core aspects of any Data Analyst's repertoire.
5. Top Skills By Salary: There is a premium on niche expertise.
6. Optimal Skills: Overall, SQL can be said to be a fundamental skill for Data Analysts that leads to a considerable salary.