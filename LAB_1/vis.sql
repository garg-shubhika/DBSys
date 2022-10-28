/*Start by writing a SQL query that returns a set (k, f(k)), 
where k=1,2,3,…, 100 and f(k) = number of distinct
authors that have at least k publications. 
Retrieve the results back into your program. From there,output a CSV file*/

DROP TABLE IF EXISTS temp_vis,dummy_vis;

CREATE TABLE dummy_vis 
AS
(
SELECT 
id as id, COUNT(*) AS k 
FROM 
publishes
GROUP BY id 
);

CREATE TABLE temp_vis AS (
SELECT k, COUNT(*) as count_of_author
FROM (SELECT id,k from dummy_vis) as publish
GROUP BY k
ORDER BY k 
);

\COPY temp_vis(k,count_of_author) TO '/home/shubhika/Downloads/DBSYS/temp_vis.csv' CSV HEADER;
DROP TABLE IF EXISTS dummy_vis,temp_vis CASCADE;