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
select * from Person

--teeme tabeli nimega Person
--Veeru nimed: Id int not null primary key,
--Name nvarchar (30)
--Email nvarchar (30)
--Genderid int


create table Person		
(
id int not null primary key,
Age nvarchar(10),
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2), 
(4, 'Aquaman', 'a@a.com', 2), 
(5, 'Catwoman', 'c@c.com', 1), 
(6, 'Antman', 'ant "ant.com', 2), 
(8, NULL, NULL, 2)

--näen tabelis olevat infot
--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)


-- kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla
--väärtust, siis automaatselt sisestab sellele reale väärtuse 3
--e unknown
alter table Person
add constraint DF_Persons_GenderId
Default 3 for genderId

Insert into Gender (Id, Gender)
values (3, 'Unknown')

insert into Person (Id, Name, Email)
values (9, 'Spiderman', 'spider@man.com')

select * from Person

--piirangu kustutamine
alter table Person 
drop constraint DF_Persons_GenderId

--kuidas lisada veerrgu tabelile Person
--veeru nimi on Age nvarchar

alter table Person 
add Age nvarchar(10)

alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

--kuidas uuendada andmeid
update Person
set Age = 159
where Id = 6

select * from Person

--soovin kustutada ühe rea
--????

delete from Person
where Id = 8


--lisame uue veeru City nvarchar(50)

alter table Person 
add City nvarchar(50)

--kõik, kes elavad Gothami linnas
select * from Person where city = 'Gotham city'
--kõik kes ei ela gothamis
select * from Person where City != 'Gotham city'
--variant nr 2. kõik, kes ei ela Gothamis
select * from Person where City <> 'Gotham'

--näitab teatud vanusega inimesi
--valime 120, 35 ja 25
select * from Person where Age = 120 or Age = 35 or Age = 26
select * from Person Where Age IN (120, 26, 35);

--soovin näha inimesi vahemikus 22 kuni 41

select * from Person where (Age > 21 and Age < 42)

--wildcard e näitab kõik g-tähega linnad
select * from Person where City Like 'g%' ;
--otsib emailid @-märgiga
select * from Person where Email like '%@%'

--tahan näha, kellel on emailis ees ja peale @-märki üks täht
select * from Person where Email like '%_@_.com%'

--kõik, kelle nimes ei ole esimene täht W, A, S

select * from Person where Name like '[^^WAS]%'

--kõik, kes elavad Gothamis ja New Yorkis

select * from Person where (City = 'Gotham city' or City = 'New York')

--kõik, kes elavad Gothamis ja New Yorkis ning peavad olema 
--vanemad kui 29
select * from Person where (City = 'Gotham city' or City = 'New York' and Age > 29)

--kuvad tähestikulises järjekorras inimesi ja võtab aluseks
--name veeru 
select * from Person
select * from Person order by Name

--võtab kolm esimest rida peron tabelist
select TOP 3 * FROM Person;
--3 tund 
--25.02.2026
--kolm esimest, aga tabeli järjestus on Age ja siis Name

select TOP 50 PERCENT * from Person

--järjesta vanuse järgi isikud

Select * from Person order by Age DESC 

--muudab Age muutja int-ks ja näitab vanulesises järjestuses
--casti abil saab andmetüüpi muuta
select * from Person order by cast(Age as int) desc

--kõikide isikute koondvanus

select SUM(cast(Age as int)) from Person

--kõige noorem isik tuleb üles leida

select TOP 1 * from Person order by cast(age as int) asc -- minu tehtud
select min(cast(Age as int)) from Person -- õpetaja tehtud

--muudame Age muutja int peale
-- näeme konkreetsetes linnades olevate isikute koondvanust

select City, SUM(Age) as TotalAge from Person group by City

--kuidas saab koodiga muuta andmetüüpi ja selle pikkust
alter table Person
alter column Name nvarchar(25)

-- kuvab esimeses reas välja toodud järjestuses ja kuvab Age-i 
-- TotalAge-ks
--järjest City-s olevate nimede kärgi ja siis Genderid järgi
-- kasutada group by-d ja order by-d
select City, GenderId, sum(Age) as TotalAge from Person 
group by City, GenderId
order by City

--näitab, et mitu rida on selles tabelis
select count(*)
from Person

--näitab tulemust, et mitu inimest on GenderId väärtusega 2
--konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, SUM(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '2'
group by GenderId, City

--näitab ära inimeste koondvanuse, mis on üle 41 a ja 
--kui palju neid igas linnas elab
--eristab inimese soo ära
select GenderId, City, SUM(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '2'
group by GenderId, City having sum(Age) > 41

--loome tabelid Employees ja Department
create table Department
(
Id int primary key, 
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees(Id, Name, Gender, Salary, DepartmentId)
values 
(1, 'Tom','Male',4000, 1),
(2, 'Pam', 'Female',3000, 3),
(3, 'John', 'Male',3500, 1), 
(4, 'Sam', 'Male',4500, 2), 
(5, 'Todd', 'Male',2800, 2), 
(6, 'Ben', 'Male',7000, 1), 
(7, 'Sara', 'Female',4800, 3), 
(8, 'Valarie', 'Female',5500, 1), 
(9, 'James', 'Male',6500, NULL), 
(10, 'Russel', 'Male',8800, NULL) 

insert into Department(Id, DepartmentName, Location, DepartmentHead)
values 
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'), 
(3, 'HR', 'New York', 'Christie'), 
(4, 'Other Department', 'Sydney', 'Cindarella')

select * from Department
select * from Employees

select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
---

--arvutab kõikide palgad kokku

select sum(cast(Salary as int)) from Employees
select min(cast(Salary as int)) from Employees

--näitab veerge Location ja Palka. Palga veerg kuvatakse TotalSalary-ks
--teha left join Department tabeliga
--grupitab locationiga

select Location, SUM(CAST(Salary as int)) as TotalSalary 
from Employees 
left join Department
on Employees.DepartmentId = Department.Id
group by Location