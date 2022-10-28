/*DATA ANALYSIS*/
/*(1) Find the top 20 authors with the largest number of publications since 2010*/
SELECT A.ID,NAME AS AUTHOR_NAME,COUNT(P.PUBID) AS NUMBER_OF_PUBLICATIONS 
FROM AUTHOR A JOIN PUBLISHES P ON P.ID=A.ID JOIN PUBLICATION PUB ON PUB.PUBID=P.PUBID
WHERE YEAR>='2010' 
GROUP BY A.ID,NAME ORDER BY COUNT(P.PUBID) DESC LIMIT 20;

/*
   id    |     author_name      | number_of_publications 
---------+----------------------+------------------------
 1049748 | H. Vincent Poor      |                   1908
  693267 | Yang Liu             |                   1734
 1465567 | Mohamed-Slim Alouini |                   1632
 1656503 | Wei Wang             |                   1511
 1765969 | Yu Zhang             |                   1405
 1954107 | Zhu Han 0001         |                   1400
 1206612 | Dacheng Tao          |                   1394
  865030 | Wei Zhang            |                   1384
  745625 | Lei Wang             |                   1281
 1768568 | Xin Wang             |                   1235
  570154 | Philip S. Yu         |                   1213
 1294949 | Lei Zhang            |                   1201
  938186 | Lajos Hanzo          |                   1152
 1900108 | Yang Li              |                   1140
 1164042 | Wei Liu              |                   1109
 1360553 | Victor C. M. Leung   |                   1102
 1594292 | Jun Wang             |                   1102
 1166653 | Mohsen Guizani       |                   1077
  122969 | Jing Wang            |                   1073
   53855 | Wei Li               |                   1067
(20 rows)
*/

/*(2) Find the top 20 authors with the largest number of publications where the publications are of type‘inproceedings’*/
select a.id,name as author_name,count(pub.pubid) as number_of_publications from author a join publishes p 
on a.id=p.id join
publication pub on pub.pubid=p.pubid where 
pub.pubkey in (select pubkey from inproceedings) group by a.id,name order by count(pub.pubid) desc limit 20;
/*
   id    |     author_name      | number_of_publications 
---------+----------------------+------------------------
 1049748 | H. Vincent Poor      |                   2569
 1465567 | Mohamed-Slim Alouini |                   1874
  693267 | Yang Liu             |                   1858
  570154 | Philip S. Yu         |                   1801
 1656503 | Wei Wang             |                   1758
  938186 | Lajos Hanzo          |                   1612
 1765969 | Yu Zhang             |                   1605
  865030 | Wei Zhang            |                   1601
 1954107 | Zhu Han 0001         |                   1522
 1206612 | Dacheng Tao          |                   1504
  745625 | Lei Wang             |                   1469
 1530026 | Witold Pedrycz       |                   1430
 1768568 | Xin Wang             |                   1416
 1606632 | Hai Jin 0001         |                   1407
 1360553 | Victor C. M. Leung   |                   1404
 1294949 | Lei Zhang            |                   1383
 1294633 | Wen Gao 0001         |                   1367
 1750462 | Luca Benini          |                   1315
  906851 | Luc Van Gool         |                   1307
 1461894 | Li Zhang             |                   1284
(20 rows)
*/

/*(3) Find the top 20 authors with the largest number of publications in ‘SIGMOD Conference’*/
CREATE VIEW VW_SIGMOD AS (SELECT DISTINCT field.k AS pubkey FROM field 
WHERE (field.p = 'booktitle' AND field.v LIKE '%SIGMOD%') OR
(field.p = 'journal' AND field.v LIKE '%SIGMOD%') OR
(field.p = 'note' AND field.v LIKE '%SIGMOD%') OR
(field.p = 'cdrom' AND field.v LIKE '%SIGMOD%') OR
(field.p = 'url' AND field.v LIKE '%SIGMOD%') OR
(field.p = 'title' AND field.v LIKE '%SIGMOD%') OR
(field.p = 'title' AND field.v LIKE '%Special Interest Group on Management of Data%')
);

CREATE TABLE SIGMOD_Conference AS (SELECT p.id, COUNT(p.pubid) AS number_of_publications
FROM publishes AS p
INNER JOIN Publication AS pub ON pub.pubid = p.pubid
INNER JOIN VW_SIGMOD AS s ON pub.pubkey= s.PubKey
GROUP BY p.id
ORDER BY number_of_publications DESC LIMIT 20
);

SELECT distinct on (author.name) author.name,author.id, number_of_publications
FROM author INNER JOIN SIGMOD_Conference ON author.id = SIGMOD_Conference.id;
/*
   id    |         name          | number_of_publications 
---------+-----------------------+------------------------
 1828780 | Marianne Winslett     |                    105
  463834 | Michael Stonebraker   |                     83
  761598 | H. V. Jagadish        |                     75
  959759 | Surajit Chaudhuri     |                     75
 1539717 | Richard T. Snodgrass  |                     70
   26304 | Divesh Srivastava     |                     70
  519549 | Michael J. Franklin   |                     67
  261123 | Michael J. Carey 0001 |                     63
  800425 | Jeffrey F. Naughton   |                     62
  738466 | David J. DeWitt       |                     60
 1188978 | Beng Chin Ooi         |                     60
 1270500 | Dan Suciu             |                     59
  676726 | Samuel Madden         |                     53
1825046  | Eugene Wu 0002        |                     26
  549389 | Feifei Li 0001        |                     37
 1609408 | Gautam Das 0001       |                     33
 1510619 | Gerhard Weikum        |                     40
  179484 | Guoliang Li 0001      |                     39
1921226  | Dennis E. Shasha      |                     36
 1168954 | Divyakant Agrawal     |                     29
(20 rows)
*/

/*(3) Find the top 20 authors with the largest number of publications in ‘VLDB Conference’*/
CREATE VIEW VW_VLDB AS (SELECT DISTINCT field.k AS pubkey FROM field 
WHERE (field.p = 'booktitle' AND field.v LIKE '%VLDB%') OR
(field.p = 'journal' AND field.v LIKE '%VLDB%') OR
(field.p = 'note' AND field.v LIKE '%VLDB%') OR
(field.p = 'cdrom' AND field.v LIKE '%VLDB%') OR
(field.p = 'url' AND field.v LIKE '%VLDB%') OR
(field.p = 'title' AND field.v LIKE '%VLDB%') OR
(field.p = 'title' AND field.v LIKE '%Very Large Data Base%')
);

CREATE TABLE VLDB_Conference AS (SELECT p.id, COUNT(p.pubid) AS number_of_publications
FROM publishes AS p
INNER JOIN Publication AS pub ON pub.pubid = p.pubid
INNER JOIN VW_VLDB AS s ON pub.pubkey= s.PubKey
GROUP BY p.id
ORDER BY number_of_publications DESC
LIMIT 100);

SELECT distinct on (author.name) author.name,author.id, number_of_publications
FROM author INNER JOIN VLDB_Conference ON author.id = VLDB_Conference.id;
/*
   id    |         name          | number_of_publications 
---------+-----------------------+------------------------
   17457 | Xuemin Lin 0001       |                     93
 1726814 | Lei Chen 0002         |                     93
   26304 | Divesh Srivastava     |                     92
 1261675 | Christian S. Jensen   |                     84
  761598 | H. V. Jagadish        |                     80
  335211 | Jeffrey Xu Yu         |                     65
 1188978 | Beng Chin Ooi         |                     63
  463834 | Michael Stonebraker   |                     63
  959759 | Surajit Chaudhuri     |                     63
  676726 | Samuel Madden         |                     62
  482223 | Alfons Kemper         |                     58
  179484 | Guoliang Li 0001      |                     57
 1863724 | Lu Qin 0001           |                     57
  711832 | Volker Markl          |                     54
 1132343 | Thomas Neumann 0001   |                     54
  261123 | Michael J. Carey 0001 |                     52
  519549 | Michael J. Franklin   |                     52
 1510619 | Gerhard Weikum        |                     52
 1270500 | Dan Suciu             |                     47
  771531 | Abraham Silberschatz  |                     26
 
(20 rows)
*/

/* (4) Find all authors who published at least 12 SIGMOD papers but never published a PODS paper */
CREATE VIEW VW_PODS AS (SELECT DISTINCT field.k AS PubKey
FROM field 
WHERE (field.p = 'booktitle' AND field.v LIKE '%PODS%') OR
(field.p = 'note' AND field.v LIKE '%PODS%') OR
(field.p = 'cdrom' AND field.v LIKE '%PODS%') OR
(field.p = 'title' AND field.v LIKE '%PODS%') OR
(field.p = 'title' AND field.v LIKE '%Principles of Database Systems%'));

DROP TABLE IF EXISTS DUMMY_PODS,DUMMY_SIGMOD;
CREATE TABLE IF NOT EXISTS DUMMY_PODS AS (SELECT p.id, COUNT(p.pubid) AS number_of_publications
							FROM publishes as p
								INNER JOIN Publication AS pub ON p.pubid = pub.pubid
								INNER JOIN VW_PODS AS vp ON pub.pubkey = vp.pubkey
							GROUP BY p.id
							ORDER BY number_of_publications DESC);

CREATE TABLE IF NOT EXISTS DUMMY_SIGMOD AS (SELECT p.id, COUNT(p.pubid) AS number_of_publications
							FROM publishes as p
								INNER JOIN Publication AS pub ON p.pubid = pub.pubid
								INNER JOIN VW_SIGMOD AS vs ON pub.pubkey = vs.pubkey
							GROUP BY p.id
							ORDER BY number_of_publications DESC);
							
SELECT distinct on (a.name) a.name,sig.id, sig.number_of_publications
FROM DUMMY_PODS AS pod 
FULL OUTER JOIN DUMMY_SIGMOD AS sig ON pod.id = sig.id
LEFT OUTER JOIN Author AS a ON sig.id = a.id
WHERE sig.number_of_publications >= 12 AND pod.number_of_publications IS NULL;

/*
           name            |   id    | number_of_publications 
---------------------------+---------+------------------------
Aaron J. Elmore           | 1098693 |                     15
Abolfazl Asudeh           |  373777 |                     12
Aditya G. Parameswaran    | 1454745 |                     21
Ahmed K. Elmagarmid       |  165786 |                     23
Alfons Kemper             |  482223 |                     37
Alvin Cheung              | 1364593 |                     13
Amit P. Sheth             | 1758963 |                     17
Andrew Eisenberg          |  438231 |                     18
Andrew Pavlo              | 1713232 |                     24
Anthony K. H. Tung        | 1500580 |                     25
Arash Termehchy           | 1561745 |                     12
Arie Segev                |  881835 |                     25
Arnon Rosenthal           |  240931 |                     18
Arun Kumar 0001           | 1372592 |                     23
Ashraf Aboulnaga          | 1704287 |                     12
Asuman Dogac              |  938950 |                     17
Babak Salimi              |  254164 |                     12
Badrish Chandramouli      | 1501572 |                     19
Barzan Mozafari           | 1621318 |                     17
Ben Kao                   |   93224 |                     12
Betty Salzberg            | 1909521 |                     14
Bin Cui 0001              | 1578481 |                     31
Bingsheng He              |  935817 |                     18
Bolin Ding                | 1454018 |                     12
Boris Glavic              | 1531620 |                     13
Bruce G. Lindsay 0001     |  415645 |                     18
Byron Choi                | 1774867 |                     13
Carlo Curino              |  888859 |                     15
Carsten Binnig            | 1505983 |                     41
Ce Zhang 0001             | 1775281 |                     15
Chi Wang 0001             |  553996 |                     12
Christian S. Jensen       | 1261675 |                     34
C. J. Date 0001           | 1108640 |                     15
Clement T. Yu             |  227555 |                     13
Cong Yu 0001              | 1839135 |                     14
Daniel J. Abadi           |  211531 |                     18
David B. Lomet            | 1964142 |                     29
Dirk Habich               | 1237058 |                     15
Donald Kossmann           |  149206 |                     48
E. F. Codd                |  762063 |                     19
Elke A. Rundensteiner     |  818792 |                     35
Eric Lo 0001              | 1911745 |                     12
Eric N. Hanson            | 1916374 |                     13
Eugene Wu 0002            | 1825046 |                     26
Fatma Özcan               | 1335830 |                     12
Feifei Li 0001            |  549389 |                     37
Gang Chen 0001            | 1818129 |                     17
Gao Cong                  | 1159396 |                     23
Goetz Graefe              | 1000890 |                     20
Guoliang Li 0001          |  179485 |                     39
Guy M. Lohman             | 1360535 |                     21
Hans-Arno Jacobsen        | 1582282 |                     18
Hongjun Lu                |  738672 |                     13
Ihab F. Ilyas             | 1590417 |                     27
Immanuel Trummer          |  737798 |                     16
James Cheng               | 1325980 |                     15
Jayant Madhavan           | 1002654 |                     12
Jayavel Shanmugasundaram  | 1290398 |                     14
Jeffrey Xu Yu             |  335211 |                     34
Jens Teubner              | 1641255 |                     12
Jianhua Feng              |  256372 |                     12
Jiannan Wang              |  657846 |                     18
Jian Pei                  |    4455 |                     19
Jiawei Han 0001           |  400941 |                     48
Jignesh M. Patel          |  766846 |                     29
Jim Gray 0001             | 1782439 |                     31
Jim Melton                |  291543 |                     21
Jingren Zhou              | 1888039 |                     16
Jorge-Arnulfo Quiané-Ruiz | 1947864 |                     15
José A. Blakeley          |   49757 |                     12
Juliana Freire            |  358504 |                     29
Jun Yang 0001             |  844164 |                     22
Karl Aberer               | 1500312 |                     20
Kaushik Chakrabarti       |  198216 |                     14
Kevin Chen-Chuan Chang    | 1533029 |                     21
Kevin S. Beyer            |  324476 |                     13
Krithi Ramamritham        |  645043 |                     27
Laura M. Haas             | 1639701 |                     22
Lijun Chang               |  296819 |                     13
Ling Liu 0001             |  870237 |                     22
Louiqa Raschid            | 1535930 |                     21
Luis Gravano              |  987517 |                     15
Lu Qin 0001               | 1863724 |                     16
Manos Athanassoulis       | 1185161 |                     12
Matei Zaharia             | 1901464 |                     12
Meihui Zhang 0001         |  366940 |                     16
Michael J. Cafarella      |  808292 |                     17
Mourad Ouzzani            |   67453 |                     22
Nan Tang 0001             | 1043905 |                     23
Nan Zhang 0004            | 1859491 |                     12
Nesime Tatbul             | 1927984 |                     13
Nick Roussopoulos         | 1541778 |                     22
Nicolas Bruno             | 1636010 |                     14
Patrick Valduriez         |  537654 |                     15
Peter Bailis              | 1025870 |                     12
Philippe Bonnet           |  224915 |                     13
Qiong Luo 0001            | 1340483 |                     13
Rajasekar Krishnamurthy   | 1550360 |                     12
Raymond Chi-Wing Wong     | 1805838 |                     15
Sanjay Krishnan           | 1827329 |                     14
Sebastian Schelter        | 1145266 |                     13
Senjuti Basu Roy          |  858529 |                     12
Sihem Amer-Yahia          |  858528 |                     30
Stanley B. Zdonik         |  520595 |                     18
Stratos Idreos            | 1360532 |                     35
Sudipto Das               |  276250 |                     12
Suman Nath                |  149545 |                     14
Themis Palpanas           |  759649 |                     18
Tim Kraska                |  175470 |                     50
Torsten Grust             | 1598618 |                     14
Ugur Çetintemel           |  942146 |                     16
Vanessa Braganholo        | 1029016 |                     44
Vasilis Vassalos          | 1157950 |                     12
Viktor Leis               |  706501 |                     15
Volker Markl              |  711832 |                     41
Wei Wang 0011             | 1862344 |                     15
Wook-Shin Han             | 1324879 |                     19
Xiaofang Zhou 0001        | 1605135 |                     13
Xiaokui Xiao              |  408908 |                     33
Xifeng Yan                |  178173 |                     13
Yinghui Wu                |   52272 |                     13
Zhen Hua Liu              | 1460858 |                     12
Zhifeng Bao               |  753328 |                     12
*/


SELECT pod.id, a.Name, pod.number_of_publications
FROM DUMMY_PODS AS pod 
FULL OUTER JOIN DUMMY_SIGMOD AS s ON pod.id = s.id
LEFT OUTER JOIN Author AS a ON pod.id = a.id
WHERE pod.number_of_publications >= 6 AND s.number_of_publications IS NULL
ORDER BY pod.number_of_publications DESC;

/*Dropping the temp views and table*/
DROP VIEW IF EXISTS VW_SIGMOD,VW_PODS,VW_VLDB CASCADE;
DROP TABLE IF EXISTS SIGMOD_Conference,VLDB_Conference,DUMMY_PODS,DUMMY_SIGMOD CASCADE;
/*
   id    |          name           | number_of_publications 
---------+-------------------------+------------------------
  721576 | Stavros S. Cosmadakis   |                      8
  334135 | Eljas Soisalon-Soininen |                      8
  595272 | Marco Calautti          |                      7
 1851705 | Nofar Carmeli           |                      6
 1573578 | Kobbi Nissim            |                      6
*/

/*(5) For each decade, find the most prolific author in that decade across all venue*/
DROP TABLE IF EXISTS TEMP_DEC CASCADE;
CREATE TABLE TEMP_DEC AS 
(
SELECT CAST(YEAR AS INT) AS YEAR,P.ID AS ID,COUNT(PUBKEY) AS COUNT_OF_PUBKEY FROM PUBLICATION PUB
JOIN PUBLISHES P ON PUB.PUBID=P.PUBID
WHERE YEAR IS NOT NULL GROUP BY YEAR,P.ID
); 


DROP TABLE IF EXISTS TEMP_DEC2 CASCADE;
CREATE TABLE TEMP_DEC2 AS 
(
SELECT year1.id,year1.year AS year1, SUM(year2.COUNT_OF_PUBKEY) as sum_pubkey
FROM TEMP_DEC AS year1, TEMP_DEC AS year2
WHERE year1.year <= year2.year AND 
year2.year < year1.year + 10 AND
cast(year1.year as text) like '%0'
GROUP BY year1.year,year1.id
ORDER BY year1.year
);

SELECT DISTINCT ON (y.year1) y.year1, y.id, a.name
FROM TEMP_DEC2 y JOIN author a
ON y.id = a.id
WHERE (year1, sum_pubkey) IN (SELECT year1, MAX(sum_pubkey) FROM TEMP_DEC2 GROUP BY year1)
ORDER BY y.year1;

/*Dropping the temp tables*/
DROP TABLE IF EXISTS TEMP_DESC,TEMP_DESC2 CASCADE;
/*
 year1 |   id   |        name         |
-------+--------+---------------------+
  1940 | 684611 | Henry S. Leonard    |
  1950 | 178939 | Alan M. Turing      |
  1960 | 3223   | Ronald G. Matteson  |
  1970 | 262805 | Azriel Rosenfeld    |
  1980 | 262805 | Azriel Rosenfeld    |
  1990 | 14     | Ivan Bruha          |
  2000 | 2692080| Wen Gao 0001        |
  2010 | 1016379| H. Vincent Poor	  |
  2020 | 8      | Johan Van Niekerk   |

*/