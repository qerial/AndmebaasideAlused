-- teeme andmebaasi e db
create database IKT25TAR

--kus on db??
use IKT25TAR

--andmebaasi kustutamine
--otsida kood ¸lesse
DROP DATABASE IKT25TAR

--teeme tabeli
create table Gender		
(
--Meil on muutuja Id,
--mis on t‰isarv andmet¸¸p,
--kui sisestad andmed, siis see veerg peab olema t‰idetud
--tegemist on priimaarvıtmega
id int not null primary key,
--Veeru nimi on Gender,
--10 t‰hem‰rki on max pikkus,
--andmed peavad olema sisestatud e 
-- ei tohi olla t¸hi
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
--* T‰hendab, et n‰ita kıike seal sees olevat infot
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

--n‰en tabelis olevat infot
--vıırvıtme ¸henduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)


-- kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla
--v‰‰rtust, siis automaatselt sisestab sellele reale v‰‰rtuse 3
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

--soovin kustutada ¸he rea
--????

delete from Person
where Id = 8


--lisame uue veeru City nvarchar(50)

alter table Person 
add City nvarchar(50)

--kıik, kes elavad Gothami linnas
select * from Person where city = 'Gotham city'
--kıik kes ei ela gothamis
select * from Person where City != 'Gotham city'
--variant nr 2. kıik, kes ei ela Gothamis
select * from Person where City <> 'Gotham'

--n‰itab teatud vanusega inimesi
--valime 120, 35 ja 25
select * from Person where Age = 120 or Age = 35 or Age = 26
select * from Person Where Age IN (120, 26, 35);

--soovin n‰ha inimesi vahemikus 22 kuni 41

select * from Person where (Age > 21 and Age < 42)

--wildcard e n‰itab kıik g-t‰hega linnad
select * from Person where City Like 'g%' ;
--otsib emailid @-m‰rgiga
select * from Person where Email like '%@%'

--tahan n‰ha, kellel on emailis ees ja peale @-m‰rki ¸ks t‰ht
select * from Person where Email like '%_@_.com%'

--kıik, kelle nimes ei ole esimene t‰ht W, A, S

select * from Person where Name like '[^^WAS]%'

--kıik, kes elavad Gothamis ja New Yorkis

select * from Person where (City = 'Gotham city' or City = 'New York')

--kıik, kes elavad Gothamis ja New Yorkis ning peavad olema 
--vanemad kui 29
select * from Person where (City = 'Gotham city' or City = 'New York' and Age > 29)

--kuvad t‰hestikulises j‰rjekorras inimesi ja vıtab aluseks
--name veeru 
select * from Person
select * from Person order by Name

--vıtab kolm esimest rida peron tabelist
select TOP 3 * FROM Person;
--3 tund 
--25.02.2026
--kolm esimest, aga tabeli j‰rjestus on Age ja siis Name

select TOP 50 PERCENT * from Person

--j‰rjesta vanuse j‰rgi isikud

Select * from Person order by Age DESC 

--muudab Age muutja int-ks ja n‰itab vanulesises j‰rjestuses
--casti abil saab andmet¸¸pi muuta
select * from Person order by cast(Age as int) desc

--kıikide isikute koondvanus

select SUM(cast(Age as int)) from Person

--kıige noorem isik tuleb ¸les leida

select TOP 1 * from Person order by cast(age as int) asc -- minu tehtud
select min(cast(Age as int)) from Person -- ıpetaja tehtud

--muudame Age muutja int peale
-- n‰eme konkreetsetes linnades olevate isikute koondvanust

select City, SUM(Age) as TotalAge from Person group by City

--kuidas saab koodiga muuta andmet¸¸pi ja selle pikkust
alter table Person
alter column Name nvarchar(25)

-- kuvab esimeses reas v‰lja toodud j‰rjestuses ja kuvab Age-i 
-- TotalAge-ks
--j‰rjest City-s olevate nimede k‰rgi ja siis Genderid j‰rgi
-- kasutada group by-d ja order by-d
select City, GenderId, sum(Age) as TotalAge from Person 
group by City, GenderId
order by City

--n‰itab, et mitu rida on selles tabelis
select count(*)
from Person

--n‰itab tulemust, et mitu inimest on GenderId v‰‰rtusega 2
--konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, SUM(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '2'
group by GenderId, City

--n‰itab ‰ra inimeste koondvanuse, mis on ¸le 41 a ja 
--kui palju neid igas linnas elab
--eristab inimese soo ‰ra
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

--arvutab kıikide palgad kokku

select sum(cast(Salary as int)) from Employees
select min(cast(Salary as int)) from Employees

--n‰itab veerge Location ja Palka. Palga veerg kuvatakse TotalSalary-ks
--teha left join Department tabeliga
--grupitab locationiga

select Location, SUM(CAST(Salary as int)) as TotalSalary 
from Employees 
left join Department
on Employees.DepartmentId = Department.Id
group by Location

select * from Employees
select sum(CAST(Salary as int)) from Employees --arvutab kıikide palgad kokku

-- lisame veeru City pikkus on 30

ALTER table Employees
add City nvarchar(30)

select City, Gender, sum(cast(Salary as int)) as TotalSalary
from Employees
group by City, Gender

--peeaegu sama p‰ring, aga linnad on t‰hestikulises j‰rjestuses.

select City, Gender, sum(cast(Salary as int)) as TotalSalary
from Employees
group by City, Gender
ORDER by City ASC

select count(*)
from Employees

-- mitu tˆˆtajat on soo ja linna kaupatˆˆtamas

SELECT City, Gender, SUM(CAST(Salary AS int)) AS TotalSalary,
COUNT(Id) as [Total EMployee(s)]
FROM Employees
GROUP BY City, Gender

--kuvab kas naised vıi mehed linnade kaupa
--kasutage where

SELECT City, Gender, SUM(CAST(Salary AS int)) AS TotalSalary,
COUNT(Id) as [Total EMployee(s)]
FROM Employees
WHERE Gender = 'Male'
GROUP BY City, Gender

--sama tulemuse nagu eelmine kord, aga kasutage: having

SELECT City, Gender, SUM(CAST(Salary AS int)) AS TotalSalary,
COUNT(Id) as [Total EMployee(s)]
FROM Employees
GROUP BY City, Gender
having gender  = 'male';

-- kıik kes teenivad rohkem, kui 4000

SELECT City, Gender, SUM(CAST(Salary AS int)) AS TotalSalary,
COUNT(Id) as [Total EMployee(s)]
FROM Employees
WHERE Salary > 4000
GROUP BY City, Gender

-- kıik, kes teenivad rohkem, kui 4000
select * from Employees where sum(cast(Salary as int)) > 4000
--teeme variandi, kus saame tulemuse
select Gender, City, sum(CAST(salary as int)) as TotalSalary,
COUNT (Id) as [Total Employee(s)]
from Employees
group by Gender, City 
having sum(cast(Salary as int)) > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)
insert into Test1 values('X')
select * from Test1
--kustutame nimega City Employee tabelist
alter table Employees
drop column City

--inner join 
-- kuvab neid, kellel on Department Name all olemas v‰‰rtus
--mitte kattuvad read eemaldatakse tulemusest
-- ja sellep‰rast ei n‰idata Jamesi ja Russelit tabelis
--kuna neil on DepartmentId NULL
select Name, Gender, Salary DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--left join
select Name, Gender, Salary DepartmentName
from Employees	
left join Department -- vıib kasutada ka LEFT OUTER JOIN-i 
on Employees.DepartmentId = Department.Id
--uurige, mis on left join
--n‰itab andmeid, kus vasakpoolsest tabelist isegi, siis kui  seal puudub
--mınes reas v‰‰rtus

--right join 
select Name, Gender, Salary, DepartmentName
from Employees
right join Department -- vıib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--right join n‰itab paremas (Department) tabelis olevaid v‰‰rtuseid, 
--mis ei ¸hti vasaku (Employees) tabeliga

--outer join 
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department 
on Employees.DepartmentId = Department.Id
--mılema tabeli read kuvab

--teha cross join
select Name, Gender, Salary, DepartmentName
From Employees
cross join Department
--korrutab kıik omavahel l‰bi

--teha left join, kus Employees tabelist DepartmentId on null
select Name, Gender, Salary, DepartmentName
from Employees	
left join Department 
on Employees.DepartmentId = NULL

--teine variant 
select Name, Gender, Salary, DepartmentName
from Employees	
left join Department 
on Department.Id is NULL
--n‰itab ainult neid, kellel on vasakus tabelis (Employees)
-- DepartmenId null

select Name, Gender, Salary, DepartmentName
from Employees	
Right join Department 
on Employees.DepartmentId = Department.Id
Where Employees.DepartmentId is NULL
--n‰itab ainult paremas tabelis olevat rida,
--mis ei kattu Employees-ga.

--full join 
--mılema tabeli mitte-kattuvate v‰‰rtustega  read kuvab v‰lja
select Name, Gender, Salary, DepartmentName
from Employees	
full join Department 
on Employees.DepartmentId = Department.Id
Where Employees.DepartmentId is NULL

select Name, Gender, Salary, DepartmentName
from Employees	
full join Department 
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null

--teete AdventureWorksLT2019 andmebaasile join p‰ringuid:
--inner join, left join, cross join ja full join
--tabeleid sellesse andmebaasi juurde ei tohi teha

--INNER JOIN
SELECT a.AddressID, City, PostalCode, AddressLine1
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca
    ON a.AddressID = ca.AddressID;

	--LEFT JOIN
	select a.AddressID, City, PostalCode, AddressLine1
	FROM SalesLT.Address AS a
	left join SalesLT.CustomerAddress AS ca
	ON a.AddressID = ca.AddressID

	--CROSS JOIN
	select a.AddressID, City, PostalCode, AddressLine1
	FROM SalesLT.Address AS a
	cross join SalesLT.CustomerAddress AS ca
	
	--FULL JOIN
	select a.AddressID, City, PostalCode, AddressLine1
	FROM SalesLT.Address AS a
	FULL join SalesLT.CustomerAddress AS ca
	ON a.AddressID = ca.AddressID
	

	--mınikord peab muutja ette kirjutama tabeli nimetuse nagu on Product.Name
	--et editor saaks aru, et kmma tabeli muutjat soovitakse kasutada ja ei tekiks
	--segadust
	select Product.Name, ProductNumber, ListPrice, 
	ProductModel.Name as [Product Model Name]
	--mınikord peab ka tabeli ette kirjutama t‰psustama info
	--nagu on SalesLT.Product
	from SalesLT.Product
	inner join SalesLT.ProductModel
	--antud juhul Producti tabelis ProductModelId vıırvıti, 
	--mis ProductModeli tabelis on primaarvıti
	on Product.ProductModelID = ProductModel.ProductModelID

