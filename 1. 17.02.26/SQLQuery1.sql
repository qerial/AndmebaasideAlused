-- teeme andmebaasi e db
create database IKT25TAR

--kus on db??
use IKT25TAR

--andmebaasi kustutamine
--otsida kood ülesse
DROP DATABASE IKT25TAR

--teeme tabeli
create table Gender		
(
--Meil on muutuja Id,
--mis on täisarv andmetüüp,
--kui sisestad andmed, siis see veerg peab olema täidetud
--tegemist on priimaarvõtmega
id int not null primary key,
--Veeru nimi on Gender,
--10 tähemärki on max pikkus,
--andmed peavad olema sisestatud e 
-- ei tohi olla tühi
Gender nvarchar(10) not null
)





--andmete sisestamine
--proovige ise teha
--Id 1, Gender Male
--Id 2, Gender Female

INSERT INTO Gender(id, Gender)
VALUES(1, 'Male'),
(2, 'Female')

--vaatame tabeli sisu
--* Tähendab, et näita kõike seal sees olevat infot
select * from Gender

--teeme tabeli nimega Person
--Veeru nimed: Id int not null primary key,
--Name nvarchar (30)
--Email nvarchar (30)
--Genderid int

create table Person		
(
id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)



