create table tempTransactionBrokerBenefit(
branchId char(5),
SurKeybroker int,
drvierSurKey int,
policyNumber varchar(20),
--contractDate date,
createDate dateTime,
totalCost int,
totalContract int,

--PPR int,
Profits_earned int

)


create table templastTransactionBrokerBenefit(
branchId char(5),
SurKeybroker int,
drvierSurKey int,
policyNumber varchar(20),
--contractDate date,
createDate dateTime,
totalCost int,
totalContract int,

--PPR int,
Profits_earned int

)


create table dailyTransactionBrokerBenefit(
branchId char(5),
SurKeybroker int,
drvierSurKey int,
policyNumber varchar(20),
--contractDate date,
createDate dateTime,
totalCost int,
--PPR int,
Profits_earned int

)


create procedure fillFactSnapShotBroker
as 

begin

declare @minDate date;
declare @maxDate date;
declare @tempMax date;

set @minDate= (select min(createDate) from factTransactionBrokerBenefit)

if @minDate is null
return 1

set @maxDate = DATEADD(MONTH, 1, @minDate);

truncate table tempTransactionBrokerBenefit

while (@minDate <= @maxDate)
begin

truncate table dailyTransactionBrokerBenefit

insert into dailyTransactionBrokerBenefit
select f.branchId,f.SurKeybroker,f.drvierSurKey,f.policyNumber,f.createDate,f.totalCost,f.Profits_earned
from factTransactionBrokerBenefit f
where f.createDate>=@minDate and f.createDate<DATEADD(DAY, 1, @minDate)


truncate table templastTransactionBrokerBenefit

insert into templastTransactionBrokerBenefit
select * from tempTransactionBrokerBenefit

truncate table tempTransactionBrokerBenefit

insert into tempTransactionBrokerBenefit
select ISNULL(d.branchId,t.branchId),
		ISNULL(d.SurKeybroker,t.SurKeybroker),
		ISNULL(d.drvierSurKey,t.drvierSurKey),
		ISNULL(d.policyNumber,t.policyNumber),
		ISNULL(d.createDate,t.createDate),
		ISNULL(d.totalCost,0)+ISNULL(t.totalCost,0),
		case when d.SurKeybroker is not null and t.SurKeybroker is null then 1
		when d.SurKeybroker is null and t.SurKeybroker is not null then d.totalContract
		when d.SurKeybroker is not null and t.SurKeybroker is not null then 1+d.totalContract
		end as totalContract,
		ISNULL(d.Profits_earned,0)+ISNULL(t.Profits_earned,0)
from dailyTransactionBrokerBenefit d full outer join templastTransactionBrokerBenefit t on d.SurKeybroker=t.SurKeybroker

set @minDate=DATEADD(DAY, 1, @minDate)


end

insert into factSnapshotBrokerBenefit
select t.branchId,t.SurKeybroker,t.drvierSurKey,t.policyNumber,t.createDate,t.totalCost,t.totalContract,t.Profits_earned
from tempTransactionBrokerBenefit t



end