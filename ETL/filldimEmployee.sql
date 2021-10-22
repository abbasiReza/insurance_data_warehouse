

create table tempDimEmployee(
--staffId char (10),
personalCode char(10),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
emailAddress varchar(20),
phoneNumber varchar(13),
--cityId char(5),
primary key (personalCode)
);

create procedure fillDimEmployee
as
begin

if exists(select * from tempDimEmployee) and
		not exists(select * from dimEmployee)
		return -1;

truncate table tempDimEmployee;

insert into tempDimEmployee
select t.personalCode,t.firstName,t.lastName,t.nationalCode,t.emailAddress,t.phoneNumber
from dimEmployee t

truncate table dimEmployee

insert into dimEmployee
select ISNULL(t.personalCode,s.personalCode),
		ISNULL(t.firstName,s.firstName),
		ISNULL(t.lastName,s.lastName),
		ISNULL(t.nationalCode,s.nationalCode),
		ISNULL(t.emailAddress,s.emailAddress),
		ISNULL(t.phoneNumber,s.phoneNumber)

from tempDimEmployee t full outer join SA_employee s on t.personalCode=s.personalCode

end