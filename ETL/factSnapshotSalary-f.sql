



create table tempFactSnapshotSalary (
ID char(10),
branchId char (5),
amount int,
fromDate dateTime,
toDate dateTime,
payDate dateTime,
NumberOfMonthPaied int,
)

create table NumberOfPiad (

ID char(10),
NumberOfMonthPaied int

)


create table tempNumberOfPiad (

ID char(10),
NumberOfMonthPaied int

)

create table temp2NumberOfPiad (

ID char(10),
NumberOfMonthPaied int

)


create procedure fillSnapShotSalary
as
begin

declare @minDate date;
declare @maxDate date;
declare @tempMax date;

set @minDate= (select min(from_Date) from SA_salaryEmployee)
--set @maxDate= (select max(CAST(from_Date as date)) from SA_salaryEmployee)
set @tempMax=(select max(fromDate) from factSnapshotSalary)

 if @tempMax is not null
	begin
	set @minDate=DATEADD(MONTH, 1, @tempMax);
end




 


truncate table tempFactSnapShotSalary 
insert into tempFactSnapShotSalary
select s.personalCode,s.branchId,s.amount,s.from_date,s.from_date,GETDATE(),ISNULL(t.NumberOfMonthPaied,0)+1
from SA_salaryEmployee s left outer join NumberOfPiad t on s.personalCode=t.ID
where s.from_date=@minDate

--insert into tempFactSnapShotSalary
--select s.brokerId,s.branchId,s.amount,s.from_date,s.from_date,GETDATE(),ISNULL(t.NumberOfMonthPaied,0)+1
--from SA_salaryBroker s left outer join NumberOfPiad t on s.brokerId=t.ID
--where s.from_date=@minDate

insert into tempFactSnapShotSalary
select s.BossId,s.branchId,s.amount,s.from_date,s.from_date,GETDATE(),ISNULL(t.NumberOfMonthPaied,0)+1
from SA_salaryBoss s left outer join NumberOfPiad t on s.BossId=t.ID
where s.from_date=@minDate

insert into tempFactSnapShotSalary
select s.expertId,s.branchId,s.amount,s.from_date,s.from_date,GETDATE(),ISNULL(t.NumberOfMonthPaied,0)+1
from SA_salaryExpert s left outer join NumberOfPiad t on s.expertId=t.ID
where s.from_date=@minDate

insert into factSnapshotSalary
select t.ID,t.branchId,t.amount,t.fromDate,t.toDate,t.payDate,t.NumberOfMonthPaied
from tempFactSnapShotSalary t


truncate table temp2NumberOfPiad
insert into temp2NumberOfPiad
select * from NumberOfPiad


truncate table NumberOfPiad
truncate table tempNumberOfPiad

insert into tempNumberOfPiad
select ISNULL(t.ID,s.personalCode),case
									when t.ID is null and s.personalCode is not null then 1
									when t.ID is not null and s.personalCode is null then t.NumberOfMonthPaied
									else t.NumberOfMonthPaied+1 end as NumberOfMonthPaied
from temp2NumberOfPiad t full outer join SA_salaryEmployee s on t.ID=s.personalCode


--insert into tempNumberOfPiad
--select ISNULL(t.ID,s.brokerId),case
--									when t.ID is null and s.brokerId is not null then 1
--									when t.ID is not null and s.brokerId is null then t.NumberOfMonthPaied
--									else t.NumberOfMonthPaied+1 end as NumberOfMonthPaied
--from temp2NumberOfPiad t full outer join SA_salaryBroker s on t.ID=s.brokerId


insert into tempNumberOfPiad
select ISNULL(t.ID,s.expertId),case
									when t.ID is null and s.expertId is not null then 1
									when t.ID is not null and s.expertId is null then t.NumberOfMonthPaied
									else t.NumberOfMonthPaied+1 end as NumberOfMonthPaied
from temp2NumberOfPiad t full outer join SA_salaryExpert s on t.ID=s.expertId

insert into tempNumberOfPiad
select ISNULL(t.ID,s.BossId),case
									when t.ID is null and s.BossId is not null then 1
									when t.ID is not null and s.BossId is null then t.NumberOfMonthPaied
									else t.NumberOfMonthPaied+1 end as NumberOfMonthPaied
from temp2NumberOfPiad t full outer join SA_salaryBoss s on t.ID=s.BossId

truncate table NumberOfPiad

insert into NumberOfPiad
select t.ID,t.NumberOfMonthPaied
from tempNumberOfPiad t


end