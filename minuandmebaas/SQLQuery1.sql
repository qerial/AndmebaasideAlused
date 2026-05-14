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

select * from Employees
select sum(CAST(Salary as int)) from Employees --arvutab kõikide palgad kokku

-- lisame veeru City pikkus on 30

ALTER table Employees
add City nvarchar(30)

select City, Gender, sum(cast(Salary as int)) as TotalSalary
from Employees
group by City, Gender

--peeaegu sama päring, aga linnad on tähestikulises järjestuses.

select City, Gender, sum(cast(Salary as int)) as TotalSalary
from Employees
group by City, Gender
ORDER by City ASC

select count(*)
from Employees

-- mitu töötajat on soo ja linna kaupatöötamas

SELECT City, Gender, SUM(CAST(Salary AS int)) AS TotalSalary,
COUNT(Id) as [Total EMployee(s)]
FROM Employees
GROUP BY City, Gender

--kuvab kas naised või mehed linnade kaupa
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

-- kõik kes teenivad rohkem, kui 4000

SELECT City, Gender, SUM(CAST(Salary AS int)) AS TotalSalary,
COUNT(Id) as [Total EMployee(s)]
FROM Employees
WHERE Salary > 4000
GROUP BY City, Gender

-- kõik, kes teenivad rohkem, kui 4000
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
-- kuvab neid, kellel on Department Name all olemas väärtus
--mitte kattuvad read eemaldatakse tulemusest
-- ja sellepärast ei näidata Jamesi ja Russelit tabelis
--kuna neil on DepartmentId NULL
select Name, Gender, Salary DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--left join
select Name, Gender, Salary DepartmentName
from Employees	
left join Department -- võib kasutada ka LEFT OUTER JOIN-i 
on Employees.DepartmentId = Department.Id
--uurige, mis on left join
--näitab andmeid, kus vasakpoolsest tabelist isegi, siis kui  seal puudub
--mõnes reas väärtus

--right join 
select Name, Gender, Salary, DepartmentName
from Employees
right join Department -- võib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--right join näitab paremas (Department) tabelis olevaid väärtuseid, 
--mis ei ühti vasaku (Employees) tabeliga

--outer join 
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department 
on Employees.DepartmentId = Department.Id
--mõlema tabeli read kuvab

--teha cross join
select Name, Gender, Salary, DepartmentName
From Employees
cross join Department
--korrutab kõik omavahel läbi

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
--näitab ainult neid, kellel on vasakus tabelis (Employees)
-- DepartmenId null

select Name, Gender, Salary, DepartmentName
from Employees	
Right join Department 
on Employees.DepartmentId = Department.Id
Where Employees.DepartmentId is NULL
--näitab ainult paremas tabelis olevat rida,
--mis ei kattu Employees-ga.

--full join 
--mõlema tabeli mitte-kattuvate väärtustega  read kuvab välja
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

--teete AdventureWorksLT2019 andmebaasile join päringuid:
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
	

	--mõnikord peab muutja ette kirjutama tabeli nimetuse nagu on Product.Name
	--et editor saaks aru, et kmma tabeli muutjat soovitakse kasutada ja ei tekiks
	--segadust
	select Product.Name, ProductNumber, ListPrice, 
	ProductModel.Name as [Product Model Name]
	--mõnikord peab ka tabeli ette kirjutama täpsustama info
	--nagu on SalesLT.Product
	from SalesLT.Product
	inner join SalesLT.ProductModel
	--antud juhul Producti tabelis ProductModelId võõrvõti, 
	--mis ProductModeli tabelis on primaarvõti
	on Product.ProductModelID = ProductModel.ProductModelID


	--6 tund 

	--isnull funktsiooni kasutame
	select ISNULL ('Ingvar', 'No Manager') as Manager

	--NULL asemel kuvab No Manager
	select coalesce(NULL, 'No Manager') as Manager

	alter table Employees 
	add ManagerId int
	select * from Employees

	--neile, kellel ei ole ülemust, siis paneb neile No Manager teksti
	--kasutage left joini
	select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
	from Employees E
	left join Employees M
	on E.ManagerId = M.Id

		select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
	from Employees E
	on E.ManagerId = M.Id
	inner join Employees M

	--kõik saavad kõikide ülemused olla
	select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
	from Employees E
	cross join Employees M

	--lisame tabelisse uued veerud
	Alter table Employees
	ADD MiddleName nvarchar (30)
	Alter table Employees
	ADD LastName nvarchar(30)

	select * from Employees 
	sp_rename 'Employees.Name', 'FristName' 

	sp_rename 'Employees.Name', 'FirstName'

	select * from Employees
	update Employees set MiddleName = '007' where Id = 9
    update Employees set MiddleName = 'Balerine' where Id = 8
	update Employees set MiddleName = 'Nick' where Id = 1
	update Employees set MiddleName = 'Todd' where Id = 5
	update Employees set MiddleName = 'Ten' where Id = 6
	update Employees set FirstName = NULL where Id = 5
	update Employees set FirstName = NULL where Id = 10
	update Employees set LastName = 'Crowe' where Id = 10
	update Employees set LastName = 'Bond' where Id = 9
	update Employees set LastName = 'Connor' where Id = 7
	update Employees set LastName = 'Sven' where Id = 6
	update Employees set LastName = 'Someone' where Id = 5
	update Employees set LastName = 'Smith' where Id = 4
	update Employees set LastName = 'Anderson' where Id = 2
	update Employees set LastName = 'Jones' where Id = 1

	--igast reast võtab esimesena täidetud lahtri ja kuvab ainult seda
	select * from Employees
	select Id, coalesce(FirstName, MiddleName, LastName) as Name
	from Employees

	--loome kaks tabelit
	create table IndianCustomers
	(
	Id int identity(1,1),
	Name nvarchar(25),
	Email nvarchar(25)
	)

	create table UKCustomers
	(
	Id int identity(1,1),
	Name nvarchar(25),
	Email nvarchar(25)
	)


	--sisestame tabalisse andmeid
	insert into IndianCustomers (Name, Email)
	values ('Raj', 'R@R.com'),
	('Sam', 'S@S.com')

	insert into UKCustomers (Name, Email)
	values ('Ben', 'B@B.com'),
	('Sam', 'S@S.com')

	select * from IndianCustomers
	select * from UKCustomers

	--kasutane union all, mis näitab kõiki ridu
	--union all ühendab tabelid ja näitab sisu

	select Id, Name, Email from IndianCustomers
	union all
	select Id, Name, Email from UKCustomers

	--korduvate väärtustega read pannakse ühte ja ei korrata
	select Id, Name, Email from IndianCustomers
	union
	select Id, Name, Email from UKCustomers

	select Id, Name, Email from IndianCustomers
	union all
	select Id, Name, Email from UKCustomers
	Order by Name

	--stored procedure
	--tavaliselt pannakse nimetuse ette sp, mis tähendab stored procedure
	create procedure spGetEmployees
	as begin
	select FirstName, Gender from Employees
	end

	--nüüd saab kasutada selle nimelist sp-d 
	spGetEmployees
	exec spGetEmployees
	execute spGetEmployees

	create proc spGetEmployeesByGederAndDepartment
	--@ tähendab muutjat
	@Gender nvarchar(20),
	@DepartmentId int
	as begin
	    select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
		AND DepartmentId = @DepartmentId
	end

	EXECute spGetEmployeesByGenderAndDepartment

	--kui nüüd allolevat käsklust käima panna, siis nõuab gender parameetrit
	spGetEmployeesByGenderAndDepartment

	--õige variant
	spGetEmployeesByGenderAndDepartment 'Male', 1	
    spGetEmployeesByGenderAndDepartment 'Female', 3	

	--niimodi sp kirja pandud järjekorrast mööda minna, kui ise paned muut
	spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender= 'Male'

	--saab sp sisu vaadata result vaates
	sp_helptext spGetEmployeesByGenderAndDepartment

	--kuidas muuta sp-d ja panna sinna võti peale, et keegi teine peale teie ei saaks muuta
	--kuskile tuleb lisada with encryption
	alter proc spGetEmployeesByGederAndDepartment
	@Gender nvarchar(20),
	@DepartmentId int 
	with encryption
	as begin
	select FirstName, Gender, @DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId

	--sp tegemine
	create proc spGetEmployeeCountByGender
	@Gender nvarchar(20),
	@EmployeeCount int output 
	as begin
	    select @EmployeeCount = COUNT(Id) from Employees where Gender = @Gender
    end

	--annab tulemuse, kus loendab ära nõuetele vastavad read 
	--prindib ka tulemuse kirja teel
	--tuleb teha declare muutja @TotalCount, mis on int
	--execute spGetEmployeeCountByGender sp, kus on parameetrid Male ja TotalCount
	--if ja else, kui TotalCount = 0, siis tuleb tekst TotalCount is null
	--lõpus kasuta print @TotalCounti puhul


	declare @TotalCount int

-- Stored procedure
execute spGetEmployeeCountByGender 'Male', @TotalCount out
if(@TotalCount = 0)
    print '@TotalCount is null'
else 
	print '@Total is not null'
	print @TotalCount

	--7 tund

	-- deklareerime muutuja @TotalCount, mis on int andmetüüp
	declare @TotalCount int
	-- käivitame stored procedure spGetEmployeeCountByGender, kus on parameetrid
	-- @EmployeeCount = @TotalCount out ja @Gender
	execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
	-- prindib konsooli välja, kui TotalCount on null või mitte null
	print @TotalCount

	--sp sisu vaatamine
	sp_help spGetEmployeeCountByGender
	-- tabeli info vaatamine
	sp_help Employees
	-- kui soovid sp teksti näha 
	sp_helptext spGetEmployeeCountByGender

	--vaatame, millest sõltub meie valitud sp
	sp_depends spGetEmployeeCountByGender
	-- näitab, et sp sõltub Employees tabelist, kuna seal on count(Id)
	-- ja Id on Employees tabelis
	
	--vaatame tabelit
	sp_depends Employees

	--teeme sp, mis annab andmeid ID ja Nameveergude kohta Employees tabelis
	create proc spGetNameById
	@Id int,
	@Name nvarchar(20) output
	as begin
		select @Id = Id, @Name = Name from Employees
	end

	--annab kogu tabeli ridade arvu
	create proc spTotalCount2
	@TotalCount int output
	as begin 
		select @TotalCount = count(Id) from Employees
	end

	--on vaja teha uus päring, kus kasutame spTotalCount2 sp-d
	--, et saada tabeli ridade arv
	-- tuleb deklareerida muutja @TotalCount  mis on int andmetüüp
	--tuleb execute spTotalCount2, kus on parameeter @TotalCount = @TotalCount out
		declare @TotalCount int
	    execute spTotalCount2 
		@TotalCount = @TotalCount out
	    print @TotalCount

		--Mis Id all on keegi nime järgi 
		create proc spGetNameById1
		 @Id int,
		 @FirstName nvarchar(20) output
		 as begin 
			select @FirstName = Name from Employees where Id = @Id
		end

		--annab tulemuse, kus id 1(seda numbrit saab muuta) real on keegi koos nimega
		--print tuleb kasutada, et näidata tulemust
		Declare @FirstName nvarchar(20)
		execute spGetNameById1
        7, @FirstName output
		Print 'Name of the Employee = ' + @FirstName

		--tehke sama, mis eelmine, aga kasutage spGetNameById sp-d
		--FirstName lõpus on out

		Declare @FirstName nvarchar(20)
		execute spGetNameById1 7, @FirstName out
		Print 'Name of the Employee = ' + @FirstName

		--output tagastab muudetud read kohe päringu tulemusena
		--see on salvestatud protseduuris ja ühe väärtuse tagastamine
		--out ei anna mitte midagi, kui seda ei määra execute käsus

		--rida 668 
		--tund 8
		--19.08.2026

		sp_help spGetNameById

		create proc spGetNameById2
		@Id int
		--kui on begin, siis on ka end kuskil olemas
		as begin 
			return (select FirstName from Employees where Id = @Id)
		end

		--kutsusime välja int-i aga Tom on nvarchar
		declare @EmployeeName nvarchar(50)
		execute @EmployeeName = spGetNameById2 1
		print 'Name of the employee = ' + @EmployeeName

	    --sisseehitatud string funktsioonid
		--see konverteerib ASCII tähe väärtuse numbriks
		select ASCII('A')

		select char(65)

		--prindime kogu tähestiku välja
		declare @Start int 
		set @Start = 97
		--kasutate while, et näidata kogu tähestik ette
		while (@Start <= 122)
		begin 
		select char(@Start)
		set @Start = @Start + 1
		end


		--eemaldame tühjad kohad sulgudes
		select LTRIM('                  Hello')
		select ('                  Hello')


		--tühikute eemaldamine veerust, mis on tabelis
		select FirstName, MiddleName, LastName from Employees
		--eemaldage tühikud veerust ära
		select ltrim(FirstName) as Name, MiddleName, LastName from Employees
		
		--paremalt poolt tühjad stringid lõikab ära 
		select rtrim('   Hello     ')

		--keerab kooloni sees olevad andmed vastupidiseks
		--vastavalt lower-ga ja upper-ga saan muuta märkide suurust
		--reverse funktsioon pöörab kõik ümber
		select Reverse(upper(ltrim(FirstName))) as FirstName, MiddleName, lower(LastName),
		rtrim(ltrim(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
		from Employees 

		--left, right, substring
		--vasakult poolt neli esimest tähte 
		select left('ABCDEF', 4)
		--paremalt poolt kolm tähte
		select right('ABCDEF', 3)

		--kuvab @-tähemärgi asetust e mitmes on @-märk
		select CHARINDEX('@', 'sara@aaa.com')

		--esimene nr peale komakohta näitab, et mitmendast alustab ja 
		--siis mitu nr peale seda kuvada
		select SUBSTRING('pam@bbb.com',5,2)

		-- @ - märgist kuvab kolm tähemärki. Viimase nr saab määrata pikkust
		select SUBSTRING('pam@bbb.com', charindex('@', 'pam@bbb.com')+ 1, 3)
		-- peale @-märki hakkab kuvama tulemust, nr saab kaugust seadistada
		select SUBSTRING('pam@bbb.com', charindex('@', 'pam@bbb.com') + 2,
		len('pam@bbb.com') - charindex('@', 'pam@bbb.com'))

		alter table Employees
		add Email nvarchar(20)

		select * from Employees


		'Tom@aaa.com'
		'Pam@bbb.com'
		'John@aaa.com'
		'Sam@bbb.com'
		'Todd@bbb.com'
		'Ben@ccc.com'
		'Sara@ccc.com'
		'Valarie@aaa.com'
		'James@bbb.com'
		'Russel@bbb.com'

		update Employees
		set Email = Case Id
		when 1 then 		'Tom@aaa.com'
		when 2 then 		'Pam@bbb.com'
when 3 then 		'John@aaa.com'
when 4 then		'Sam@bbb.com'
when 5 then 		'Todd@bbb.com'
when 6 then		'Ben@ccc.com'
when 7 then 		'Sara@ccc.com'
when 8 then 		'James@bbb.com'
when 9 then 		'Russel@bbb.com'
end
select * from Employees
--soovime teada saada domeeninimesid emailides
select SUBSTRING (Email, charindex('@', Email) + 1,
len (Email) - charindex('@', Email)) as EmailDomain
from Employees

--alates  teistes tähest emailis kuni @ märgini on tärnid 
select FirstName, LastName,
substring(Email, 1, 2) + replicate('*', 5) +
substring(Email,charindex('@', Email), len(Email) - charindex('@', Email)+1) as Email
from Employees

--kolm korda näitab stringis olevad väärtust
select replicate('asd', 3)

--tühku sisestamine
select space(5)

--tühiku sisestamine Firstname ja Lastname vahele
select FirstName + Space(25) + LastName AS FullName
FROM Employees

-- PATINDEX
-- sama, mis charindex, aga dünaamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@aaa.com', Email) > 0
--leian kõik selle domeeni esindajad ja alates mitemndast märgist algab 

--kõik .com emailid asedab .net-ga
select Email, REPLACE(Email, '.com', '.net')
from Employees

--soovin asendada peale esimest märki kolm tähte viie tärniga

select FirstName, LastName, Email,
stuff(Email, 2, 3, '*****') as StuffedEmail
from Employees

create table  DateTime
(
c_time time,
c_date date,
c_smalldateteime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2
)

select * from DateTime

--konkreetse masina kellaaeg
select getdate(), 'GETDATE()'

insert into DateTime 
values (getdate(), getdate(), getdate(), getdate(), getdate(), getdate())

select * from DateTime

update DateTime
set c_date = '1446-04-12'
where c_date = '2026-03-19'

select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP' --aja päring
select SYSDATETIME(), 'SYSDATETIME' --veel täpsem aja päring
select SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET' --täpne aeg koos ajalise nihkega
select GETUTCDATE(), 'GETUTCDATE' ---UTC aeg

--saab kontrollida, kas on õige andmetüüp 
select isdate('asd') --tagastab 0 kuna string ei ole date
select isdate(GETDATE()) -- kuidas saada vastuseks 1 isdate puhul
select isdate('2026-03-19 12:43:22.260001') -- tagastab 0 kuna max kolm komakohta võib olla
select isdate('2026-03-19 12:43:22.260') -- tagastab 1
select DAY(GETDATE()) -- annab tänase päeva nr
select DAY('01/24/2026') -- annab stringis oleva kp ja järjestus peab olema õige
select MONTH(GETDATE())--annab jooksva kuu nr
select MONTH('01/24/2026') --annab stringis oleva kuu ja järjestus peab olema õige
select YEAR(GETDATE())-- annab jooksva aasta nr
select YEAR('01/24/2026') -- annab stringis oleva aasta ja järjestus peab olema õige
select datename(day, '2026-03-19 12:43:22.260') --annab stringis oleva päeva nr
select datename(weekday, '2026-03-19 12:43:22.260') --annab stringis oleva nädala sõnana
select datename(month, '2026-03-19 12:43:22.260') --annab stringis oleva kuu sõnana

create table EmployeesWithDates
(
Id nvarchar(2),
Name nvarchar(20),
DateOfBirth datetime
)
select * from EmployeesWithDates
INSERT INTO EmployeesWithDates(Id, Name, DateOfBirth)
values ('1', 'Sam', '1980-12-30 00:00:00:000'),
('2', 'Pam', '1982-09-01 12:02:36:260'),
('3', 'John', '1985-08-22 12:03:30:370'),
('4', 'Sara', '1979-11-29 12:59:30:670')

select * from EmployeesWithDates


--tund 9

--kuidas võtta ühendust veerust andmeid ja selle abil luua uued veerud
--vaatab DoB veerust päeva ja kuvab päeva nimetuse sõnana
select Name, DateOfBirth, Datename(weekday, DateOfBirth) as [Day], 
--vaatab VoB veerust kuupäevasid ja kuvab kuu nr
	MONTH(DateOfBirth) as MonthNumber,
	--vaatab DoB veerust kuud ja kuvab sõnana
	DateName(MONTH, DateOfBirth) as [MonthName],
	--võtab DoB veerust aasta 
	Year(DateOfBirth) as [Year]
from EmployeesWithDates

select Datepart(WEEKDAY, '2008-07-28 ')


--kuvab 3 kuna USA nädal algab pühapäeval
select Datepart(WEEKDAY, '2026-03-24 13:13:00:670')
--tehke sama, aga kasutage kuud
select DATEPART(MONTH,'2026-03-24 13:13:00:670')
--liidab stringis olevale, kuupäevale 20 päeva juurde
select DateAdd(day, 20, '2026-03-24 13:13:00:670')
--lahutab stringis oleval, kuupäeval 20 päeva ära
select DateAdd(day, -20, '2026-03-24 13:13:00:670')
--kuvab kahe stringis oleva kuudevahelist aega nr-na
select datediff(MONTH, '11/20/2026', '01/20/2026')
--tehke sama, aga aastat
select datediff(YEAR, '11/20/2026', '01/20/2028')

-- alguses uurite, mis on funktsioon MS SQL
--v: eelkirjutatud toimingud, salvestatud tegevus
-- mis on seda vaja?
--pakkuda andmebaasis korduvkasutatavat funktsionaalsust
--mis on selle eelised ja puudumised
--saad kiiresti kasutada toiminguid ja ei pea uuesti koodi kirjutama
--funktsioon ei tohi muuta DB olekut

create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int 
	select @tempdate = @DOB

	select @years = DATEDIFF(year, @tempdate, getdate()) - case when (month(@DOB) >
	month(GETDATE())) or (MONTH(@DOB) = month(GETDATE()) and day(@DOB) > day(getdate()))
	then 1 else 0 end
	select @tempdate = dateadd(year, @Years, @tempdate)

	select @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - case when day(@DOB) > day(GETDATE()) then 1 else 0 end
	select @tempdate = dateadd(MONTH, @months, @tempdate)

	select @days = datediff(DAY, @tempdate, GETDATE())
	
	declare @Age nvarchar(50)
		set @Age =cast(@years as nvarchar(4)) + ' Years ' + cast(@months as nvarchar(2))
		+ ' Months ' + cast(@days as nvarchar(2)) + ' Days old '
		return @Age 
end

 select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age From EmployeesWithDates

 --rida 902
 --tund 10

 --kui kasutame seda funktsiooni, siis saame teada tänase päeva vahtet stringis välja tooduga

 select dbo.fnComputeAge('07/28/2008') as Age

 -- nr peale DOB muutujat näitab, et mismoodi kuvada DOB-d
 select Id, Name, DateOfBirth,
 convert(nvarchar, DateOfBirth, 109) as ConvertedDOB
 from EmployeesWithDates

 select Id, Name, Name + ' - ' + cast(Id as nvarchar) as [Name-Id] from EmployeesWithDates

 select CAST(GETDATE() as date) 

 --tänane kp, aga kasutate converti 

 Select CONVERT(nvarchar, GETDATE(), 109) as ConvertedTime

 select convert(date, getdate())
 
 select * from EmployeesWithDates

 --matemaatilised funktsioonid 
 select ABS(-5) --abs on absoluutväärtusega number ja tulemuseks saame ilma miinus märgita 5
 select CEILING(4.2) -- ceiling on funktsioon, mis ümardab ülespoole ja tulemuseks saame 5
  select CEILING(-4.2) --ceiling ümardab ka miinus numbrid ülespoole, mis tähendab, et saame -4
  select floor(15.2) --floor on fuktsioon, mis ümardab alla ja tulemuseks saame 15
  select floor(-15.2)-- floor ümardab ka miinus numbrid alla, mis tähendab et saame -16
  select power(2, 4)--kaks astmes 4
  select SQUARE(9)--antud juhul 9 ruudus
  select sqrt(16) -- antud juhul 16 ruutjuur

  select rand() --rand on funktsioon, mis genereerib 
  --juhusliku numbri vahemikus 0 kuni 1
  --kuidas saada täisnumber iga kord
select rand() * 100
select floor(rand() * 100) --korrutab sajaga iga suvalise numbri

--iga krd näitab 10 suvalist numbrit
declare @counter int 
set @counter = 1
while (@counter <= 10)
begin
	 print floor(rand() * 100)
	 set @counter = @counter + 1
end

select ROUND(850.556, 2)
--round on funktsioon,
--mis ümardab kaks komakohta ja tulemuseks saame 850.56
select ROUND(850.556, 2, 1)
--round on funktsioon, mis ümardab kaks komakohta ja
--kui kolmas parameeter on 1, siis ümardab alla 
select ROUND(850.556, 1)
--ROUND on funktsoon, mis ümardab ühe komakohta ja 
--tulemuseks saame 850.6
select ROUND(850.556, 1, 1)
--ümardab alla ühe komakoha pealt 
--ja tulemuseks saame 850.5 
select ROUND(850.556, -2) --ümardab täisnr ülessepoole ja tulemuseks saame 900
select ROUND(850.556, -1) --ümardab täisnr alla ja tulemus on 850

--
create function dbo.CalculateAge(@DOB date)
returns int
as begin
Declare @Age int

	SET @Age = datediff(YEAR, @DOB, GETDATE()) -
	case 
		when (MONTH(@DOB) > MONTH(GETDATE())) or
			 (MONTH(@DOB) = MONTH(GETDATE()) and DAY(@DOB) > DAY(GETDATE()))
			 then 1 else 0 end
		return @Age
end

SELECT dbo.CalculateAge'2008-07-28' AS Age

--arvutab välja, kui vana on isik ja võtab arvesse kuud ning päevad 
--antud juhul näitab kõike, kes on üle 36 a vanad
select Id, Name, dbo.CalculateAge(DateOfBirth) as Age from EmployeesWithDates
where dbo.CalculateAge(DateOfBirth) > 36

--02.04.2026
--inline table valued functions
alter table EmployeesWithDates
add DepartmentId int
alter table EmployeesWithDates
add Gender nvarchar(10)

select * from EmployeesWithDates

INSERT INTO EmployeesWithDates (Id, Name, DateOfBirth, DepartmentId, Gender)
VALUES (5, 'Todd', '1985-08-22 12:03:30.370', 1, 'Male');

update EmployeesWithDates
set DepartmentId = 1
where Name = 'Sam'


update EmployeesWithDates
set DepartmentId = 1
where Name = 'John'

update EmployeesWithDates
set DepartmentId = 3
where Name = 'Sara'

update EmployeesWithDates
set DepartmentId = 2
where Name = 'Pam'


update EmployeesWithDates
set Gender = 'Male'
where DepartmentId = 1

update EmployeesWithDates
set Gender = 'Female'
where DepartmentId = 2 

update EmployeesWithDates
set Gender = 'Female'
where DepartmentId = 3

update EmployeesWithDates
set DateOfBirth = '1978-11-29 12:59:30.670'
where Id = 5

--scarle function annab mingis vahemikus olevaid andmeid,
--inline table values ei kasuta begin ja end funktsioone
--scalar annab väärtused ja inline annab tabeli
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table 
as
return (select Id, Name, DateOfBirth, DepartmentId, Gender
		from EmployeesWithDates
		where Gender = @Gender)

--kuidas leida kõik naised tabelis EmployeesWithDates
-- ja kasutada funktsiooni fn_EmployeesByGender


--tahaks ainult Pami nime näha
select * from fn_EmployeesByGender('female')
where name = 'Pam'

select * from Department
--kahest erinevast tabelist andmete võtmine ja 
--koos kuvamine
--esimene on funktsioon ja tein tabel





select Name, Gender, DepartmentName
from fn_EmployeesByGender('Male') E
join Department on Department.Id = E.DepartmentId

--multi tabel statement
--inline funktsioon
create function fn_GetEmployees()
returns table as
return(select Id, Name, cast(DateOfBirth as date)
		as DOB
		from EmployeesWithDates)

select * from fn_GetEmployees()
--multi-state puhul peab defineerima uue tabeli veerud koos muutujatega
--funktsiooni nimi on fn_MS_GetEmployees()
--peab edastama meile Id, Name, DOB tabelist

create function fn_MS_GetEmployees()
returns @Table Table (Id int,Name nvarchar(20), DOB date)
as begin 
insert into @Table
select Id ,Name , cast(DateOfBirth as date) as DOB
from EmployeesWithDates
return
end

select * from fn_MS_GetEmployees()

--inline tabeli funktsioonid on paremini töötamas kuna k'sitletakse vaatena
--multi puhul on pm tegemist stored proceduriga ja kulutab ressurssi rohkem

--muudame andmeid ja vaatame, kas inline funktsioonis on muutused kajastatud
update fn_GetEmployees() set Name = 'Sam1' where Id = 1
select * from fn_GetEmployees() --saab muuta andmeid

update fn_MS_GetEmployees() set Name = 'Sam2' where Id = 1
--ei saa muuta andmeid multi state funktsioonis,
--kuna see on nagu stored procedure

--deterministic vs non-deterministic functions
--deterministic funktsioonid annavad alatu sama tulemuse, kui sisend on sama
select COUNT(*) from EmployeesWithDates
select SQUARE(4)
--non-deterministic funktsioonid annavad erineva tulemuse, kui sisend on sama
select GETDATE()
select CURRENT_TIMESTAMP
select floor(rand() * 10000)

--loome funktsiooni 
create function fn_GetNameById(@Id int)
returns nvarchar(30)
as begin 
	return (select Name from EmployeesWithDates where Id = @Id)
end

--kasutame funktsiooni leides Id 1 all oleva inimene 
select  dbo.fn_GetNameById(1)

select * from EmployeesWithDates

--saab näha funktsiooni sisu
sp_helptext fn_GetNameById

--nüüd muudate funktsiooni nimega fn_GetNameById
--ja panete sinna encryption, et keegi peale teie ei saaks sisu näha

alter function fn_GetNameById(@Id int)
returns nvarchar(30)
with encryption 
as begin 
	return (select Name from EmployeesWithDates where Id = @Id)
end

--kui nüüd sp_helptexti kasutada, siis ei näe funktsiooni sisu
sp_helptext fn_GetNameById

--kasutame schemabindingut, et näha, mis on funktsiooni sisu
alter function fn_GetNameById(@Id int)
returns nvarchar(30)
with schemabinding
as begin 
	return (select Name from dbo.EmployeesWithDates where Id = @Id)
end

--schemabinding tähendab, et kui keegi üritab muuta EmployeesWithDates
--tabelit, siis ei lase seda teha, kuna see on seotud
--fn_GetNameById funktsiooniga

--ei saa kustutada ega muuta tabeit EmployeesWithDates
--kuna see on seotud fn_GetNameById funktsiooniga
drop table dbo.EmployeesWithDates


--temporary tables
--see on olemas ainult selle sessiooni jooksul
--kasutatakse # sümbolit, et saada aru, et tegemist on temporary tabeliga

create table #PersonDetails (Id int, Name nvarchar(20))

insert into #PersonDetails values (1, 'Sam')
insert into #PersonDetails values (2, 'Pam')
insert into #PersonDetails values (3, 'John')

select * from #PersonDetails

--temporary tabelite nimekirja ei näe, kui kasutada sysobjects
--tabelit, kuna need on ajutised
select Name from sysobjects
where name like '#PersonDetails%'

--kasutame temporary tabeli
drop table #PersonDetails

create proc spCreateLocalTempTable
as begin
create table #PersonDetails (Id int, Name nvarchar(20))

insert into #PersonDetails values (1, 'Sam')
insert into #PersonDetails values (2, 'Pam')
insert into #PersonDetails values (3, 'John')

select * from #PersonDetails
end
--
exec spCreateLocalTempTable

--globaalne temp tabel on olemas kogu 
--serveris ja kõigile kasutajatele, kes on ühendatud
create table ##GlobalPersonDetails (Id int, Name nvarchar(20))

--index
create table EmployeeWithSalary
(
	Id int primary key,
	Name nvarchar(20),
	Salary int,
	Gender nvarchar(10)
)

insert into EmployeeWithSalary values
(1, 'Sam', 2500, 'Male'),
(2, 'Pam', 6500, 'Female'),
(3, 'John', 4500, 'Male'),
(4, 'Sara', 5500, 'Female'),
(5, 'Todd', 3100, 'Male')

select * from EmployeeWithSalary

--otsime inimesi, kelle palgavahemik on 5000 kuni 7000

select * from EmployeeWithSalary
where Salary between 5000 and 7000

--loome indeksi Salary veerule, et kiirendada otsingut
--mis asetab andmed Salary veeru järgi järjestatult

create index IX_EmployeeSalary 
on EmployeewithSalary(Salary asc)

--saame teada, et mis on selle tabeli primaarvõti ja index
exec sys.sp_helpindex @objname = 'EmployeeWithSalary'

--tahaks indeksi kasutada, et otsing oleks kiirem
select * from EmployeeWithSalary
where Salary between 5000 and 7000

--näitab, et kasutatakse indeksi IX_EmployeeSalary,
--kuna see on järjestatud Salary veeru järgi
select * from EmployeeWithSalary with (index(IX_EmployeeSalary))

--indeksi kasutamine
drop index IX_EmployeeSalary on EmployeeWithSalary --1 variant
drop index EmployeeWithSalary.IX_EmployeeSalary --2 variant

-- indeksi tüübid:
--1. Klastrites olevad
--2. Mitte-klasstris olevad
--3. Unikaalsed
--4. Filtreeriitud
--5. XML
--6. Täistekst
--7. Ruumiline 
--8. Veerusäilitav
--9. Veergude indeksid
--10. Välja arvatud veergudega indeksid

-- klastris olev indeks määrab ära füüsilise järjestuse 
-- ja selle tulemusel saab tabelis olla ainult üks klastris olev indeks

create table EmployeeCity
(
	Id int primary key,
	Name nvarchar(20),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(50)
)

exec sp_helpindex EmployeeCity

-- andmete õige järjestuse loovad klastris olevad indeksid 
-- ja kasutab selleks Id nr-t
-- põhjus, miks antud juhul kasutab Id-d  tuleneb primaarvõtmest
insert into EmployeeCity values
(3, 'John', 4500, 'Male','New York'),
(1, 'Sam', 2500, 'Male','London'),
(4, 'Sara', 5500, 'Female','Tokyo'),
(5, 'Todd', 3100, 'Male','Toronto'),
(2, 'Pam', 6500, 'Male','Sydney')

--klastris olevad indeksid dikteerivad säilitatud andmete järjestuse tabelis 
--ja seda saab klastrite puhul olla ainult üks

select * from EmployeeCity
create clustered index IX_EmployeeCityName
on EmployeeCity(Name)
--põhjus, miks ei saa luua klastris olevad 
--indeksit Name veerule, on see, et tabelis on juba klastris
--olev indeks Id veerul, kuna see on primaarvõti

--loome composite indeksi, mis tähendab, et see on mitme veeru indeks
--enne tuleb kustutada klastris olev indeks kuna composite indeks
--on klastris olev indeksi tüüp
create clustered index IX_EmployeeGenderSalary
on EmployeeCity(Gender desc, Salary asc)

--kui teed select päringu sellele tabelile, siis peaksid nägema andmeid,
--mis on järjestatud selliselt: Esimeseks võetakse aluseks Gender veerg
--kahanevas järjestuses ja siis salary veerg tõusvas järjestuses

select * from EmployeeCity

--mitte klastris olev indeks on eraldi struktuur 
--mis hoiab indeksi veeru väärtusi
create nonclustered index IX_EmployeeCityName
on EmployeeCity(Name)
--kui nüüd teed select päringu, siis näed et andmed on
--järjestatud Id veeru järgi
select * from EmployeeCity

-- erinevused kahe indeksi vahel
-- 1. Ainult üks klastris olev indeks saab olla tabeli peale
-- mitte-klastris olevad indekseid saab olla mittu
-- 2. Klastris olevad indeksid on kiiremad kuna indeks peab tagasi
-- viitama tabelile Juhul, kui selekteeritud veerg ei ole olemas indeksis 
-- 3. Klastris olev indeks määratleb ära tabeli ridade salvestujärjestuse 
-- ja ei nõua kettal lisaruumi. Samas mitte klastris olevad indeksid on
-- salvestatud tabelis eraldi ja nõuab lisa ruumi

create table EmployeeFirstName
(
	Id int primary key,
	FirstName nvarchar(20),
	LastName nvarchar(20),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(50)
)

helpindex EmployeeFirstName

insert into EmployeeFirstName values(1, 'John', 'Smith', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 2500, 'Male', 'London')

drop index EmployeeFirstName.PK__Employee__3214EC0750A642E5
-- kui käivitad ülevalpool oleva koodi, siis tuleb veateade 
-- et SQL server kasutab UNIQUE indeksit jõustamaks väärtuste
-- unikaalsust ja primaarvõtit koodiga Unikaalseid Indekseid
-- ei saa kustutada, aga käsitsi saab

create unique nonclustered index UIX_Employee_FirstName_LastName
on EmployeeFirstName(FirstName, LastName)

--lisame uue piirangu peale
alter table EmployeeFirstName
add constraint UQ_EmployeeFirstNameCity
unique nonclustered(City)

--sisestage kolmas rida andmeid, mis on id-s 3, FirstName-s John,
--LastName-s Menco ja linn on London

insert into EmployeeFirstName values(3, 'John', 'Menco', NULL, NULL, 'London')

select * from EmployeeFirstName

--saab vaadata indeksite infot
exec sp_helpconstraint EmployeeFirstName

-- 1.vaikimisi primaarvõti loob unikaalse klastris oleva indeksi,
-- samas unikaalne piirang loob unikaalse mitte-klastris oleva indeksi
-- 2. Unikaalset indeksit või piirangut ei saa luua olemasolevasse tabeils
-- kui peaks olema unikaalne indeks või piirang. Nt, kui tahad sisestada
-- 10 rida andmeid, millest 5 sisaldavad korduvaid andmeid,
-- siis kõik 10 lükatakse tagasi, kui soovin ainult 5
-- rea tagasi lükkamist ja ülejäänud 5 rea sisestamist, siis selleks 
-- kasutatakse IGNORE_DUP_KEY

--näide 
create unique index IX_EmployeeFirstName
on EmployeeFirstName(City)
with ignore_dup_key

insert into EmployeeFirstName values(3, 'John', 'Smith', 3512, 'Male', 'London1')
insert into EmployeeFirstName values(4, 'Mike', 'Sandoz', 3123, 'Male', 'London2')
insert into EmployeeFirstName values(4, 'John', 'Menco', 3220, 'Male', 'London2')
--enne ignore käsku oleks kõik kolm rida tagasi lükatud, aga 
--nüüd läks keskmine rida läbi kuna linna nimi oli unikaalne
select * from EmployeeFirstName
--view on virtuaalne tabel, mis on loodud ühe või mitme tabeli põhjal
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.Id = Employees.DepartmentId

create view vw_EmployeesByDetails
as 
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.Id = Employees.DepartmentId
--otsige ülesse view

--kuidas view-d kasutada: vw_EmployeesByDetails

select * from vw_EmployeesByDetails
--view ei salvesta andmeid vaikimisi
--seda tasub võtta, kui salvestatud virtuaalse tabelina

--milleks vaja:
--saab kasutada andmebaasi skeemi keerukuse lihtsustamiseks, 
--mitte IT-inimestele
--piiratud ligipääs andmetele, ei näe kõiki veerge

--teeme view, kus näev ainult IT-töötajaid
create view vITEmployeesInDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.Id = Employees.DepartmentId
where Department.DepartmentName = 'IT'

--ülevalpool olevat päringut saab liigutada reataseme turvalisuse 
--alla. Tahan ainult näidata IT osakonna töötajaid

select * from vITEmployeesInDepartment

-- veeru taseme turvalisus
-- peale selecti määratled veergude näitamise ära
create view vEmployeesInDepartmentSalaryNoShow
as
select FirstName, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

select * from vEmployeesInDepartmentSalaryNoShow

--saab kasutada esitlemaks koondandmeid ja üksikasjalike andmeid
--view, mis tagastab summeeritud andmeid
create view vEmployeesCountByDepartment
as
select DepartmentName, count(Employees.Id) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName

select * from vEmployeesCountByDepartment

--kui soovid vaadata view sisu

sp_helptext vEmployeesCountByDepartment
--kui soovid muuta, siis kasutad alter view

--kui soovid kustutada, siis kasutad drop view
drop view vEmployeesCountByDepartment 

--andmete uuendamine läbi view
create view vEmployeesDataExceptSalary
as
select Id, FirstName, Gender, DepartmentId
from Employees

select * from Employees

update vEmployeesDataExceptSalary
set [FirstName] = 'Tom' where Id = 2

--kustutage Id 2 rida ära
delete from vEmployeesDataExceptSalary
where Id = 2

select * from vEmployeesDataExceptSalary

select * from Employees
-- andmete sisestamine läbi view 
-- Id 2, Female, Osakond 2, Pam

insert into vEmployeesDataExceptSalary 
values(2, 'Pam', 'Female', 2)

--indekseeritud view
--MS SQL-s on indekseeritud view nime all ja
-- Oracles materjaliseeritud view nimega

create table Product
(
Id int primary key,
Name nvarchar(20),
UnitPrice int
)

select * from Product

insert into Product values
(1, 'Books', 20),
(2,'Pens', 14),
(3, 'Pencils', 11),
(4, 'Clips', 10)

create table ProductSales
(
Id int,
QuantitySold int
)

select * from ProductSales

insert into ProductSales values 
(1, 10),
(3, 23),
(4, 21),
(2, 12),
(1, 13),
(3, 12),
(4, 13),
(1, 11),
(2, 12),
(1, 14)

-- loome view, mis annab meile veerud TotalSales ja TotalTransaction
create view vTotalSalesByProduct
with schemabinding
as
select Name,
sum(isnull((QuantitySold * UnitPrice), 0)) as TotalSales,
count_big(*) as TotalTransactions
from dbo.ProductSales
join dbo.Product
on dbo.Product.Id = dbo.ProductSales.Id
group by Name

select * from vTotalSalesByProduct

-- kui soovid luua indeksi view sisse, siis peab järgima teatud reegleid
-- 1. view tuleb luua koos schemabinding-ga
-- 2. kui liafunktsioon select list viitab väljendile ja selle tulemuseks 
-- võib olla NULL, siis asendusväärtus peaks olema täpsustatud.
-- Antud juhul kasutasime ISNULL funktsiooni asendamaks NULL väärtust
-- 3. kui GroupBy on täpsustatud, siis view select list peab sisaldama COUNT_BIG(*) väljendit
-- 4. Baastabelis peaksid view-d olema viidatud kahesosalie nimega
-- e antud juhul dbo.Product ja dbo.ProductSales.

create unique clustered  index UIX_vTotalSalesByProduct_Name
on vTotalSalesByProduct(Name)

select * from vTotalSalesByProduct

--view piirangud 
create view vEmployeeDetails
@Gender nvarchar(20)
as
select Id, FirstName, Gender, DepartmentId
from Employees
where Gender = @Gender
--mis on selles views valesti???
--vaatesse e view-sse ei saa kaasa panna parameetreid e antud juhul Gender

--teha funktsioon, kus parameetriks on Gender
--soovin näha veerge: Id, FirstName, Gender, DepartmentId
--tabeli nimi on Employees

create function fnEmployeeDetails
(
	@Gender nvarchar(20)
)
returns table
as 
return
(
select Id, FirstName, Gender, DepartmentId
from Employees 
where Gender = @Gender
)

--kasutame funktsiooni fnEmployeeDetails koos parameetriga

select * from fnEmployeeDetails('Female')

--order by kasutamine
create view  vEmployeeDetailsStored
as 
select Id, FirsName, Gender, DepartmentId
from Employees
order by Id
--order by-d ei saa kasutada

--temp tabeli kasutamine
create table ##TestTempTable
(Id int, FirstName nvarchar(20), Gender nvarchar(20))

insert into ##TestTempTable values(101, 'Mart', 'Male')
insert into ##TestTempTable values(101, 'Joe', 'female')
insert into ##TestTempTable values(101, 'Pam', 'female')
insert into ##TestTempTable values(101, 'James', 'Male')

-- view nimi on v0nTempTable
-- kasutame ##TestTempTable  
create view vOnTempTable
as 
select Id, FirstName, Gender
from ##TestTempTable
-- view-id ja funktsioone ei saa teha ajutistele tabelitele

--Trigger

--DML trigger
--kokku on kolme tüüpi: DML, DDL ja LOGON

-- trigger on stored procedure eriliik, mis automaatselt käivitub
-- kui mingi tegevus
-- peaks andmebaasis aset leidma

-- DML - data manipulation language
-- DML-i põhilised käsklused: insert, update ja delete

-- DML triggereid saab klassifitseerida kahte tüüpi:
-- 1. After trigger (kutsutakse ka FOR triggeriks)
-- 2. Instead of trigger (selmet trigger e selle asemel trigger)

--- after trigger käivitub peale sündmust, kui kuskil on tehtud insert, 
--- update ja delete

--- loome uue tabeli
create table EmployeeAudit
(
Id int identity(1, 1) primary key,
AuditData nvarchar(1000)
)

--peale iga töötaja sisestamist tahame teada saada töötaja Id-d,
-- päeva ning aega(millal sisestati)
-- kõik andmed tulevad EmployeeAudit tabelisse
-- andmeid sisestame Employees tabelisse

create trigger trEmployeeForInsert
on Employees
for insert 
as begin 
declare @Id int
select @Id = Id from inserted
insert into EmployeeAudit
values ('New employee with Id' + cast(@Id as nvarchar(5)) + ' is added at '
+ CAST(getDate() as nvarchar(20)))
end

select * from Employees 

insert into Employees values 
(11, 'Bob', 'Male', 3000, 1, 'Bomb', 'Blob', 'bob@bob.com', 3)
go 
select * from EmployeeAudit

--delete trigger
create trigger trEmployeeForDelete
on Employees
for delete
as begin
	declare @Id int
	select @Id = Id from deleted

	insert into EmployeeAudit
	values('An existing employee with Id = ' + cast(@Id as nvarchar(5)) +
	' is deleted at ' + cast(getdate() as nvarchar(20)))
end

delete from Employees where Id = 11
select * from EmployeeAudit

--update trigger
create trigger trEmployeeForUpdate
on Employees
for update
as begin
	--muutujate deklareerimine
	declare @Id int
	declare @OldGender nvarchar(20), @NewGender nvarchar(20)
	declare @OldSalary int, @NewSalary int
	declare @OldDepartmentId int, @NewDepartmentId int
	declare @OldManagerId int, @NewManagerId int
	declare @OldFirstName nvarchar(20), @NewFirstName nvarchar(20)
	declare @OldMiddleName nvarchar(20), @NewMiddleName nvarchar(20)
	declare @OldLastName nvarchar(20), @NewLastName nvarchar(20)
	declare @OldEmail nvarchar(50), @NewEmail nvarchar(50)

	---muutuja, kuhu läheb lõpptekst
	declare @AuditString nvarchar(1000)

	-- laeb kõik uuendatud andmed temp tabeli alla
	select * into #TempTable
	from inserted

	-- käib läbi kõik andmed temp tabelist
	while(exists(select Id from #TempTable))
	begin
		set @AuditString = ''
		--selekteerib esimese rea andmed temp
		select top 1 @Id = Id, @NewGender = Gender,
		@NewSalary = Salary, @NewDepartmentId = DepartmentId,
		@NewManagerId = ManagerId, @NewFirstName = FirstName,
		@NewMiddleName = MiddleName, @NewLastName = LastName,
		@NewEmail = Email
		from #TempTable
		--võtab vanad andmed kustutatud tabelist
		select @OldGender = Gender,
		@OldSalary = Salary, @OldDepartmentId = DepartmentId,
		@OldManagerId = ManagerId, @OldFirstName = FirstName,
		@OldMiddleName = MiddleName, @OldLastName = LastName,
		@OldEmail = Email
		from deleted where Id = @Id

		---rida 1677
		---tund 14
		---30.04.26
		--hakkab võrdlema igat muutujat, et kas toimus andmete muutus
		set @AuditString = 'Employee with Id = ' + cast(@Id as nvarchar(4)) + ' changed '
		if(@OldGender <> @NewGender)
			set @AuditString = @AuditString + ' Gender from ' + @OldGender + ' to ' +
			@NewGender

		if(@OldSalary <> @NewSalary)
			set @AuditString = @AuditString + ' Salary from ' + cast(@OldSalary as nvarchar(20)) + ' to ' +
			cast(@NewSalary as nvarchar(20))

		if(@OldDepartmentId <> @NewDepartmentId)
			set @AuditString = @AuditString + ' DepartmentId from ' + cast(@OldDepartmentId as nvarchar(20)) + ' to ' +
			cast(@NewDepartmentId as nvarchar(20))

		if(@OldManagerId <> @NewManagerId)
			set @AuditString = @AuditString + ' ManagerId from ' + cast(@OldManagerId as nvarchar(20)) + ' to ' +
			cast(@NewManagerId as nvarchar(20))

		if(@OldFirstName <> @NewFirstName)
			set @AuditString = @AuditString + ' FirstName from ' + @OldFirstName + ' to ' +
			@NewFirstName

		if(@OldMiddleName <> @NewMiddleName)
			set @AuditString = @AuditString + ' Middlename from ' + @OldMiddleName + ' to ' +
			@NewMiddleName

		if(@OldLastName <> @NewLastName)
			set @AuditString = @AuditString + ' Lastname from ' + @OldLastName + ' to ' +
			@NewLastName

		if(@OldEmail <> @NewEmail)
			set @AuditString = @AuditString + ' Email from ' + @OldEmail + ' to ' +
			@NewEmail

		insert into dbo.EmployeeAudit values (@AuditString)
		--kustutab temp tabelist rea
		delete from #TempTable where Id = @Id
	end
end
--Triggeri lõpp

update Employees set FirstName = 'test123', Salary = 4000, MiddleName = 'test456'
where Id = 10

select * from Employees
select * from EmployeeAudit
----

--instead of trigger
create table Employee
(
Id int primary key,
Name nvarchar(30),
Gender Nvarchar(10),
DepartmentId int
)

--kellel ei ole seda tabelit, siis nemad sisestabad selle koodi
create table Department
(
Id int primary key,
DepartmentName nvarchar(20),
)

Insert into Employee values 
(1, 'John', 'Male', 3 ),
(2, 'Mike', 'Male', 2 ),
(3, 'Pam', 'Female', 1 ),
(4, 'Todd', 'Male', 4 ),
(5, 'Sara', 'Female', 1 ),
(6, 'Ben', 'Male', 3 )

create view vEmployeeDetails
as 
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Department
on Employee.DepartmentId = Department.Id

select * from vEmployeeDetails
-- tuleb veateade
insert into vEmployeeDetails values
(7, 'Valarie', 'Female', 'IT')

--nüüd proovime lahendada proobleemi, kui kasutame instead of trigger-t
create trigger tr_vEmployeeDetails_InsteadOfInsert
on vEmployeeDetails
instead of insert
as begin
	declare @DeptId int

	select @DeptId = dbo.Department.Id
	from Department
	join inserted
	on inserted.DepartmentName = Department.DepartmentName

	if(@DeptId is null)
		begin 
		raiserror('Invalid department name. Statement terminated', 16, 1)
		return 
	end

	insert into dbo.Employee(Id, Name, Gender, DepartmentId)
	select Id, Name, Gender, @DeptId
	from inserted
end
--- raiserror funktsioon
-- selle eesmärk on tuua  välja veateade, kui DepartmentName veerus ei ole väärtust
-- ja ei klapi uue sisestatud väärtusega.
-- Esimene on parameeter ja veateate sisu, teine on veataseme nr (nr 16 tähendab
-- üldiseid vigu) ja kolmas on olek

--nüüd saab läbi view sisestada andmeid
insert into vEmployeeDetails values(7, 'Valarie', 'Female', 'IT')

--uuendame andmeid
update vEmployeeDetails
set Name = 'Johny', DepartmentName = 'IT'
where Id = 1
-- ei saa uuendada andmeid kuna mitu tabelit on sellest mõjutatud

update vEmployeeDetails
set DepartmentName = 'IT'
where Id = 1

select * from vEmployeeDetails

--instead of Update trigger
create trigger tr_vEmployeeDetails_InsteadOfUpdate
on vEmployeeDetails
instead of update
as begin

	if(update(Id))
	begin
		raiserror('Id cannot be changed', 16, 1)
		return
	end

	if(update(DepartmentName))
	begin
		declare @DeptId int
		select @DeptId = Department.Id
		from Department
		join inserted
		on inserted.DepartmentName = Department.DepartmentName

		if(@DeptId is null)
		begin
			raiserror('Invalid Department Name', 16, 1)
			return
		end

		update Employee set DepartmentId = @DeptId
		from inserted
		join Employee
		on Employee.Id = inserted.Id
	end

	if(update(Gender))
	begin
		update Employee set Gender = inserted.Gender
		from inserted
		join Employee
		on Employee.Id = inserted.Id
	end 

		if(update(Name))
	begin
		update Employee set Name = inserted.Name
		from inserted
		join Employee
		on Employee.Id = inserted.Id
	end 
end

--uuendame andmeid, kasutada vEmployeeDetails
--uuendada seal, kus on Id 1


---delete trigger
create view vEmployeeCount
as
select DepartmentId, DepartmentName,count(*) as TotalEmployees
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName, DepartmentId

select * from vEmployeeCount

--vaja teha päring, kus on töötajaid 2tk või rohkem 
--kasutada EmployeeCount

select * from vEmployeeCount
where TotalEmployees >1

select DepartmentName, TotalEmployees from vEmployeeCount
where TotalEmployees >= 2

---
select DepartmentName, DepartmentId, count(*) as TotalEmployees
into #TempEmployeeCount
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName, DepartmentId

select * from #TempEmployeeCount
--läbi ajutise tabeli saab samu andmeid vaadata, kui seal on info olemas
select DepartmentName, TotalEmployees from #TempEmployeeCount
where TotalEmployees >= 2

--tuleb teha trigger nimega trEmployeeDetails_InsteadOfDelete
--ja kasutada vEmployeeDetails
--triggeri tüüo on instead of delete

create trigger trEmployeeDetails_InsteadOfDelete
on vEmployeeDetails
instead of delete
as begin
	delete Employee
	from Employee
	join deleted
	on Employee.Id = deleted.Id
end

delete from vEmployeeDetails where Id = 7
select * from vEmployeeDetails

--CTE e common table expression

--CTE näide 
with EmployeeCount(DepartmentName, DepartmentId, TotalEmployees)
as
	(
	select DepartmentName,DepartmentId, count(*) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName, DepartmentId
	)
select DepartmentName, TotalEmployees
from EmployeeCount
where TotalEmployees >= 2

-- CTE-d võivad sarnaneda  temp tabeliga 
-- sarnane päritud tabelile ja ei ole salvestatud objektina
-- ning kestab päringu ulatuses

--päritud tabel
select DepartmentName, TotalEmployees
from
(
	select DepartmentName,DepartmentId, count(*) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName, DepartmentId	
)
as EmployeeCount
where TotalEmployees >= 2

-- tehke päring, kus on kaks CTE päringut sees

with EmployeeCountBy_Payroll_IT_Dept(DepartmentName, Total)
as
(
	select DepartmentName, COUNT(Employee.Id) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	where DepartmentName in ('Payroll', 'IT')
	group by DepartmentName
),
EmployeeCountBy_HR_Admin_Dept(DepartmentName, Total)
as
(
	select DepartmentName, COUNT(Employee.Id) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName
)
--kui on kaks CTE-d, siis unioni abil ühendab päringu
select * from EmployeeCountBy_Payroll_IT_Dept
union
select * from EmployeeCountBy_HR_Admin_Dept

--teha CTE päring nimega EmployeeCount
--järjestaks DepartmentName järgi ära


with EmployeeCount(DepartmentId, TotalEmployees)
as
(
	select DepartmentId, count(*) as TotalEmployees
	from Employee
	group by DepartmentId
)
select DepartmentName
from  Department
join Employee
on Department.Id = Employee.DepartmentId
ORDER BY DepartmentName

--tund 15
--uuendame CTE-d

with Employee_Name_Gender
as
(
select Id, Name, Gender from Employee
)
select * from Employee_Name_Gender

--kasutame JOIN-i CTE tegemiseks

with EmployeesByDepartment
as 
(
	select Employee.Id, Employee.Name, Gender, DepartmentName
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
)
update EmployeesByDepartment set Gender = 'Male' where Id = 1

-- kasutage eelmist CTE andmete muutmiseks,
-- aga seekord muutke Id 1 töötaja Gender female peale ja
-- DepartmentName Payroll peale

with EmployeesByDepartment
as 
(
	select Employee.Id, Employee.Name, Gender, DepartmentName
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
)
update EmployeesByDepartment set Gender = 'Female', DepartmentName = 'Payroll'
where Id = 1
-- ei luba mitmes tabelis korraga andmeid muuta, kui tegemist on CTE-ga

--- Kokkuvõte CTE-st
-- 1. kui CTE baseerub ühel tabelil, siis uuendus töötab
-- 2. kui CTE baseerub mitmel tabelil, siis tuleb veateade
-- 3. kui CTE baseerub mitmel tabelil ja tahame muuta ainult ühte tabelit,
-- siis uuendus saab tehtud

-- korduv CTE
--- CTE, mis iseendale viitab, kutsutakse korduvaks CTE-ks
--- kui tahad andmeid näidata hierarhiliselt

create table Employee
(
	EmployeeId int Primary key,
	Name nvarchar(20),
	ManagerId int
)

select * from Employee

insert into Employee values
(1, 'Tom', 2),
(2, 'Josh', NULL),
(3, 'Mike', 2),
(4, 'John', 3),
(5, 'Pam', 1),
(6, 'Mary', 3),
(7, 'James', 1),
(8, 'Sam', 5),
(9, 'Simon', 1)

-- kasutame left joini, et näha kõiki töötajaid ja nende juhte
select Emp.Name as [Employee Name],
isnull(Manager.Name, 'Super Boss') as [Manager Name]
from dbo.Employee Emp
left join Employee Manager
on Emp.ManagerId = Manager.EmployeeId

-- peab samasuguse tulemuse saavutama, aga kasutate CTE-d

with EmployeeCTE (Id, Name, ManagerId, [Level])
as
(
	select Employee.EmployeeId, Employee.Name, Employee.ManagerId, 1 
	from Employee
	where ManagerId is null

	union all

	select Employee.EmployeeId, Employee.Name, Employee.ManagerId, 
	EmployeeCTE.[Level] + 1
	from Employee
	join EmployeeCTE
	on Employee.ManagerId = EmployeeCTE.Id

)
	select EmpCTE. Name as Employee,
	isnull(MgrCTE. Name, 'Super Boss') as [Manager Name],
	EmpCTE. Level as [Boss Level]
	from EmployeeCTE EmpCTE
	left join EmployeeCTE MgrCTE
	on EmpCTE. ManagerId = MgrCTE.Id

--- PIVOT
--mis on PIVOT?
--PIVOT on SQL-i operatsioon, mis võimaldab teisendada ridu veergudeks
create table Sales
(
	SalesAgent nvarchar(20),
	SalesCountry nvarchar(20),
	SalesAmount int
)

insert into sales values
('Tom','UK',200),
('John','US',180),
('John','UK',260),
('David','India',450),
('Tom','India',350),
('David','US',200),
('Tom','US',130),
('John','India',540),
('John','UK',120),
('David','UK',220),
('John','UK',420),
('David','US',320),
('Tom','US',340),
('Tom','UK',660),
('John','India',430),
('David','India',230),
('David','India',280),
('Tom','UK',480),
('John','UK',360),
('David','UK',140)
--
select SalesCountry, SalesAgent, sum(SalesAmount) as TotalSales
from Sales
group by SalesCountry, SalesAgent
order by SalesCountry, Salesagent

--- kasuta pivotit, et saada sama tulemus nagu ülemises päringus

select SalesAgent, India, US, UK
from Sales
pivot
(
	sum(SalesAmount)
	for SalesCountry in ([UK], [India], [US])
) As PivotTable

--päring muudab unikaalsete veergude väärtust (India, UK ja US) SalesCountry veerus
-- omaette veergudeks koos veergude SalesAmount liitmisega

create table SalesWithId
(
Id int primary key,
SalesAgent nvarchar(20),
SalesCountry nvarchar(20),
SalesAmount int
)

insert into SalesWithId values
(1,'Tom','UK',200),
(2,'John','US',180),
(3,'John','UK',260),
(4,'David','India',450),
(5,'Tom','India',350),
(6,'David','US',200),
(7,'Tom','US',130),
(8,'John','India',540),
(9,'John','UK',120),
(10,'David','UK',220),
(11,'John','UK',420),
(12,'David','US',320),
(13,'Tom','US',340),
(14,'Tom','UK',660),
(15,'John','India',430),
(16,'David','India',230),
(17,'David','India',280),
(18,'Tom','UK',480),
(19,'John','UK',360),
(20,'David','UK',140)

select * from SalesWithId

select SalesAgent, India, US, UK
from SalesWithId
pivot
(
	sum(SalesAmount)
	for SalesCountry in ([UK], [India], [US])
) As PivotTable
-- põhjuseks on Id veeru olemasolu SalesWithId, mida võetakse arvesse
-- pööramise ja grupeerimise järgi

select SalesAgent, India, US, UK
from
(
	select SalesAgent, SalesCountry, SalesAmount from SalesWithId
)
as SourceTable
pivot
(
	sum(SalesAmount)
	for SalesCountry in (UK, India, US)
)
As PivotTable

--transactionid
-- transaction jälgib järgmisi samme:
-- 1. selle algus
-- 2. käivitab DB käske
-- 3. kontrollib vigu. Kui on viga, siis taastab algse oleku

create table PhysicalAddress
(
	Id int not null primary key,
	EmployeeNumber int,
	HouseNumber nvarchar(10),
	StreetAddress nvarchar(50),
	City nvarchar(50),
	Postalcode nvarchar(20)
)

insert into PhysicalAddress
values (1, 101, '#10','King Street','Londoon', 'CR27DW')

create proc spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update PhysicalAddress set City = 'LONDON'
			where PhysicalAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback tran
	end catch
end

--käivitame spUpdateAddress stored procedure-i
spUpdateAddress

select * from MailingAddress
select * from PhysicalAddress

-- kui teine uuendus ei lähe läbi, siis esimene ei lähe ka läbi
-- kõik uuendused peavad läbi minema

-- transaction ACID test

-- edukas transaction peab läbima ACID testi:
-- A - atomic e aatomlikus 
-- C - consistent e järjepidevus
-- I - isolated e isoleeritus
-- D - durable e vastupidav

-- Atomic - kõik tehingud transactionis on kas edukalt täidetud või need
-- lükatakse tagasi. Nt, mõlemad käsud peaksid alati õnnestuma. Andmebaas
-- teeb sellisel juhul: võtab esimese update tagasi ja veeretab selle algsendisse
-- e taastab algsed andmed

-- Consistent - kõik transactioni puuduvad andmed jäetakse loogiliselt 
-- järjepidevasse olekusse. Nt, kui laos saadaval olevaid esemete hulka 
-- vähendatakse, siis tabelis peab olema vastav kanne. Inventuur ei saa
-- lihtsalt kaduda

-- Isolated - transaction peab andmeid mõjutama, sekkumata teistesse
-- samaaegtesse transactionitesse. See takisab andmete muutmist, mis 
-- põhinevad sidumata tabelitel. Nt, muudatused kirjas, mis hiljem tagasi
-- muudetakse. Enamik DB-d kasutab tehingute isoleerimise säilitamiseks
-- lukustamist

-- Durable - kui muutus on tehtud, siis on see püsiv. Kui süsteemiviga või
-- voolukatkestus ilmneb enne läskude komplekti valamist, siis tühistatakse need
-- käsud ja andmed taastakse algsesse olekusse. Taastamine toimub peale 
--süsteemi taaskäivitamist.

--subqueries e alamkäsud 
--alamkäsud on SQL-i käsud, mis on peastatud teise SQL-i käsu sisse

create table ProductSales
(
Id int primary key identity,
ProductId int foreign key references Product(Id),
UnitPrice int,
QuantitySold int
)

--tund 16
-- 21.05.26
