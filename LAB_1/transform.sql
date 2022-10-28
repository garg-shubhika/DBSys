/*AUTHOR*/
create table tmpAuthors (name text, pubkey text);

insert into tmpAuthors (name, pubkey) select distinct on (v) v,k from Field f where f.p = 'author';

create table tmpHomepages (homepage text, pubkey text);

insert into tmpHomepages (pubkey, homepage) select k, v from Field f where f.p = 'url';

create sequence seq;

insert into author (select nextval('seq') as id,tmpauthors.name, tmphomepages.homepage from tmpauthors 
left outer join tmphomepages on tmpauthors.pubkey=tmphomepages.pubkey 
where tmpauthors.name IS NOT NULL AND tmphomepages.homepage IS NOT NULL);

drop sequence seq;
drop table IF EXISTS tmpAuthors,tmpHomepages CASCADE;

/*PUBLICATION*/

create sequence pub_seq;

create table tmpublyear (pk text, year text); 
insert into tmpublyear (pk, year) select distinct k, cast(v as int) from Field f where f.p = 'year';

create table temp_pub_title (pk text, title text);
insert into temp_pub_title (pk, title) select distinct k, v from Field f where f.p = 'title';

CREATE TABLE tmp_titles AS(SELECT DISTINCT ON (pk) pk,title FROM temp_pub_title LEFT JOIN Pub ON temp_pub_title.pk = Pub.k);

CREATE TABLE tmp_publication AS(SELECT DISTINCT ON (tmp_titles.pk) tmp_titles.pk,title,year FROM tmp_titles LEFT OUTER JOIN tmpublyear ON tmp_titles.pk = tmpublyear.pk);

insert into publication (select nextval('pub_seq'),pk,title,cast(year as int) from tmp_publication);

drop sequence pub_seq;
drop table IF EXISTS tmpublyear,temp_pub_title,tmp_titles,tmp_publication CASCADE;

/*PUBLISHES*/
alter table publishes drop constraint publishes_id_fkey;
alter table publishes drop constraint publishes_pubid_fkey;

create table temp_pub (key text, name text);
insert into temp_pub (key, name) select k, v from field f where f.p = 'author';


create table temp_publish (key text,id int);
insert into temp_publish (key, id) select temp_pub.key, author.id from temp_pub 
left join author on temp_pub.name = author.name;

insert into publishes 
select temp_publish.id, publication.pubid from temp_publish left join publication 
on temp_publish.key = publication.pubkey 
where temp_publish.id is not NULL 
and publication.pubid is not null ON CONFLICT DO NOTHING;

alter table publishes add FOREIGN KEY(ID) REFERENCES AUTHOR;
alter table publishes add FOREIGN KEY(PUBID) REFERENCES PUBLICATION;

DROP TABLE IF EXISTS temp_publish,temp_pub CASCADE;


/*DROPPING FOREIGN KEY CONSTRAINTS*/
alter table article drop constraint article_pub_id_fkey;
alter table book drop constraint book_pub_id_fkey;
alter table incollection drop constraint incollection_pub_id_fkey;
alter table inproceedings drop constraint inproceedings_pub_id_fkey;

/*ARTICLE*/

CREATE TABLE TEMP_ARTICLE(PUBID,J,M,V,N) AS (SELECT DISTINCT ON (PUBLICATION.PUBID) PUBLICATION.PUBID,JOURNAL.V,MONTH_ART.V,VOLUME.V,NUMBER.V
FROM PUBLICATION JOIN PUB ON (PUBLICATION.PUBKEY = PUB.K AND PUB.P = 'ARTICLE')
LEFT OUTER JOIN FIELD AS JOURNAL ON (PUBLICATION.PUBKEY = JOURNAL.K AND JOURNAL.P = 'JOURNAL')
LEFT OUTER JOIN FIELD AS MONTH_ART ON (PUBLICATION.PUBKEY = MONTH_ART.K AND MONTH_ART.P = 'MONTH')
LEFT OUTER JOIN FIELD AS VOLUME ON (PUBLICATION.PUBKEY = VOLUME.K AND VOLUME.P = 'VOLUME')
LEFT OUTER JOIN FIELD AS NUMBER ON (PUBLICATION.PUBKEY = NUMBER.K AND NUMBER.P = 'NUMBER')
);

INSERT INTO ARTICLE(PUB_ID, ARTICLE_NUMBER, VOLUME, JOURNAL, MONTH) SELECT PUBID,N,V,J,M FROM TEMP_ARTICLE;

/*restore the foreign key in article and dropping the temp table*/
alter table article add  FOREIGN KEY (PUB_ID) REFERENCES PUBLICATION (PUBID);
DROP TABLE IF EXISTS TEMP_ARTICLE CASCADE;

/*BOOK*/
CREATE TABLE TEMP_BOOK(pubid,p,i) AS (
SELECT DISTINCT ON (publication.pubid) 
publication.pubid, 
publisher.v, 
isbn.v
FROM publication 
JOIN pub ON (publication.pubkey = pub.k AND pub.p = 'book')
LEFT OUTER JOIN field AS publisher ON (publication.pubkey = publisher.k AND publisher.p = 'publisher')
LEFT OUTER JOIN field AS isbn ON (publication.pubkey = isbn.k AND isbn.p = 'isbn')
);
INSERT INTO book(PUB_ID,ISBN,PUBLISHER) SELECT pubid,i,p FROM TEMP_BOOK;

/*restore the foreign key in book and dropping the temp table*/
alter table book add FOREIGN KEY (PUB_ID) REFERENCES PUBLICATION (PUBID);
DROP TABLE IF EXISTS TEMP_BOOK CASCADE;

/*INCOLLECTION*/
CREATE TABLE TEMP_incollection(pubid,b,p,i) AS(
SELECT DISTINCT ON (publication.pubid) 
publication.pubid, 
booktitle.v, 
publisher.v, 
isbn.v
FROM publication  
JOIN pub ON (publication.pubkey = pub.k AND pub.p = 'incollection')
LEFT OUTER JOIN field AS booktitle ON (publication.pubkey = booktitle.k AND booktitle.p = 'booktitle')
LEFT OUTER JOIN field AS publisher ON (publication.pubkey = publisher.k AND publisher.p = 'publisher')
LEFT OUTER JOIN field AS isbn ON (publication.pubkey = isbn.k AND isbn.p = 'isbn')
);

INSERT INTO incollection (PUB_ID, 
ISBN,
PUBLISHER,
BOOKTITLE) SELECT pubid,i,p,b FROM TEMP_incollection;

/*restore the foreign key in incollection and dropping the temp table*/
alter table incollection add FOREIGN KEY (PUB_ID) REFERENCES PUBLICATION (PUBID);
DROP TABLE IF EXISTS TEMP_incollection CASCADE;

/*INPROCEEDINGS*/
CREATE TABLE TEMP_inproceedings(pubid,b,e) AS
(
SELECT DISTINCT ON (publication.pubid) 
publication.pubid, 
booktitle.v, 
editor.v
FROM publication  
JOIN pub ON (publication.pubkey = pub.k AND pub.p = 'inproceedings')
LEFT JOIN field AS booktitle ON (publication.pubkey = booktitle.k AND booktitle.p = 'booktitle')
LEFT JOIN field AS editor ON (publication.pubkey = editor.k AND editor.p = 'editor')
);

INSERT INTO inproceedings(PUB_ID,EDITOR,BOOKTITLE) SELECT pubid,e,b FROM TEMP_inproceedings;

/*restore the foreign key in inproceedings and dropping the temp table*/
alter table inproceedings add FOREIGN KEY (PUB_ID) REFERENCES PUBLICATION (PUBID);
DROP TABLE IF EXISTS TEMP_inproceedings CASCADE;
