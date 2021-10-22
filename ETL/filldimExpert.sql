

create table tempDimExperts (

expertId char(5),
--personalCode char(10),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
emailAddress varchar(20),
phoneNumber varchar(13),
Specialty varchar(30),
--hireDate date,
--branchId char(5),
primary key (expertId)
)


create procedure dimExpert 
as
begin

if exists(select * from tempDimExperts) and
		not exists(select * from dimExpert)
		return -1;
		
truncate table tempDimExperts;

insert into tempDimExperts
select ISNULL(d.expertId,e.expertId),
		ISNULL(d.firstName,e.firstName),
		ISNULL(d.lastName,e.lastName),
		ISNULL(d.nationalCode,e.nationalCode),
		ISNULL(d.emailAddress,e.emailAddress),
		ISNULL(d.phoneNumber,e.phoneNumber),
		ISNULL(d.Specialty,e.Specialty)
from dimExperts d,SA_branch_expert e
where d.expertId=e.expertId

truncate table dimExpert

insert into dimExpert
select t.expertId,t.firstName,t.lastName,t.nationalCode,t.emailAddress,t.phoneNumber,t.sprcialty
from tempDimExperts t

end