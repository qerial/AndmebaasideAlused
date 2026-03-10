create database SpordiklubiSüsteem
use SpordiklubiSüsteem

-- 1. punkt
create table Liikmed
(
id int not null primary key,
eesnimi varchar(50),
perenimi varchar(50),
vanus int,
liitumise_aasta int
)
-- 2. punkt
insert into Liikmed (id, eesnimi, perenimi, vanus, liitumise_aasta)
values (1, 'Anna', 'Mets', 43, 2011),
(2, 'Toomas', 'Lõvi', 37, 2012),
(3, 'Jüri', 'Kadakas', 31,2014), 
(4, 'Romet', 'Saar', 2,2014 ), 
(5, 'Maris', 'Lill', 1, 2015), 
(6, 'Andrus', 'Tamm', 34, 2016)

select * from Liikmed

-- 3. punkt

Update Liikmed
set vanus = 41
where Id = 5

Update Liikmed
set perenimi = 'Rohi'
where id = 1

select * from Liikmed

-- 4. punkt

alter table Liikmed
add kuutasu DECIMAL(5,2)

select * from Liikmed

update Liikmed
set kuutasu = 869.55
where id = 1

update Liikmed
set kuutasu = 899.65
where id = 5

update Liikmed
set kuutasu = 970.71
where id = 3


select * from Liikmed


-- 5. punkt

alter table Liikmed
drop column liitumise_aasta
select * from Liikmed


-- 6. punkt

delete from Liikmed
where id = 2
select * from Liikmed
