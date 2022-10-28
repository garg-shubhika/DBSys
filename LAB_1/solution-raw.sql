/*For each type of publication, count the total number of publications of that type*/
select p,count(p) from Pub group by p order by p;

/*
ect p,count(p) from Pub group by p order by p;
       p       |  count  
---------------+---------
 article       | 2990379
 book          |   19586
 incollection  |   68714
 inproceedings | 3127371
 mastersthesis |      15
 phdthesis     |   96663
 proceedings   |   52294
 www           | 3106055
(8 rows)
*/

/*Select all the types of publications that contain conferences*/
select Pub.p,count(Pub.p) from Pub join field on Pub.k=field.k where field.v like '%Conference%' group by pub.p;

/*
       p       | count 
---------------+-------
 article       |  3020
 book          |     8
 incollection  |    14
 inproceedings | 54518
 proceedings   | 29800
 www           |     1
(6 rows)
*/

/*Find the fields that occur in all publications types*/
select field.p from pub join field on pub.k=field.k group by field.p having count(distinct pub.p)=8;

/*
   p    
--------
 author
 ee
 note
 title
 year
(5 rows)
*/

/*A query that returns the fields that occur only in at most 1 publication type*/
select field.p from pub join field on pub.k=field.k group by field.p having count(distinct pub.p)<=1 order by p;

/*
    p    
---------
 address
 chapter
(2 rows)
*/