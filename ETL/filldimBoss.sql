
create table tempDimBoss (
BossId char(5),
--personalCode char(10),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
emailAddress varchar(20),
phoneNumber varchar(13),
--hireDate date,
--branchId char(5),
primary key (BossId)
)


create procedure fillDimBoss
as 
begin
if exists(select * from tempDimBoss) and
		not exists(select * from dimBoss)
		return -1;
truncate table tempDimBoss


insert into tempDimBoss
select b.BossId,b.firstName,b.lastName,b.nationalCode,b.emailAddress,b.phoneNumber
from dimBoss b

truncate table dimBoss

insert into dimBoss
select ISNULL(t.BossId,b.BossId),
		ISNULL(t.firstName,b.firstName),
		ISNULL(t.lastName,b.lastName),
		ISNULL(t.nationalCode,b.nationalCode),
		ISNULL(t.emailAddress,b.emailAddress),
		ISNULL(t.phoneNumber,b.phoneNumber)
from tempDimBoss t full outer join SA_branch_boss b on t.BossId=b.BossId



end