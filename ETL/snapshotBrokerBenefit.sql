create table dimBrokers (
surKeyBroker int identity(1,1),
brokerId char(5),
--personalCode char(10),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
emailAddress varchar(20),
phoneNumber varchar(13),
--hireDate date,
--branchId char(5),
PPR int , --Percentage of profit received
startDate date,
endDate date,
currentFlag bit,
primary key (surKeyBroker)
);


create table factTransactionBrokerBenefit(
branchId char(5),
SurKeybroker int,
driverId char(5),
policyNumber varchar(20),
--contractDate date,
createDate dateTime,
totalCost int,
--PPR int,
Profits_earned int
foreign key (branchId) references dimLocationBranch (branchId),
foreign key (SurKeybroker) references dimBrokers (surKeyBroker),
foreign key (driverId) references dimDriver (driverId),
foreign key (policyNumber) references dimPolicy (policyNumber),
foreign key (createDate) references dimDate (Date) 
)

create table dailyTransactionBrokerBenefit(
branchId char(5),
SurKeybroker int,
driverId char(5),
policyNumber varchar(20),
--contractDate date,
createDate dateTime,
totalCost int,
--PPR int,
Profits_earned int

)

create table tempTransactionBrokerBenefit(
branchId char(5),
SurKeybroker int,
driverId char(5),
policyNumber varchar(20),
--contractDate date,
createDate dateTime,
totalCost int,
totalContract int,

--PPR int,
Profits_earned int

)


create table factSnapshotBrokerBenefit (
branchId char(5),
brokerSurKey int,
--driverId char(5),
--policyNumber char(3),
--contractDate date,
createDate dateTime,
totalCost int,
totalContract int,
--PPR int,
Profits_earned int,
foreign key (branchId) references dimLocationBranch (branchId),
foreign key (brokerSurKey) references dimBrokers (surKeyBroker),
--foreign key (driverId) references dimDriver (driverId),
--foreign key (policyNumber) references dimPolicy (policyNumber),
foreign key (createDate) references dimDate (Date) 
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
select f.branchId,f.SurKeybroker,f.driverId,f.policyNumber,f.createDate,f.totalCost,f.Profits_earned
from factTransactionBrokerBenefit f
where f.createDate>=@minDate and f.createDate<DATEADD(DAY, 1, @minDate)


insert into tempTransactionBrokerBenefit
select ISNULL(d.branchId,t.branchId),
		ISNULL(d.SurKeybroker,t.SurKeybroker),
		ISNULL(d.driverId,t.driverId),
		ISNULL(d.policyNumber,t.policyNumber),
		ISNULL(d.createDate,t.createDate),
		ISNULL(d.totalCost,0)+ISNULL(t.totalCost,0),
		case when d.SurKeybroker is not null and t.SurKeybroker is null then 1
		when d.SurKeybroker is null and t.SurKeybroker is not null then d.totalContract
		when d.SurKeybroker is not null and t.SurKeybroker is not null then 1+d.totalContract
		end as totalContract,
		ISNULL(d.Profits_earned,0)+ISNULL(t.Profits_earned,0)
from dailyTransactionBrokerBenefit d full outer join tempTransactionBrokerBenefit t on d.SurKeybroker=t.SurKeybroker

set @minDate=DATEADD(DAY, 1, @minDate)


end

insert into factSnapshotBrokerBenefit
select t.branchId,t.SurKeybroker,t.driverId,t.policyNumber,t.createDate,t.totalCost,t.totalContract,t.Profits_earned
from tempTransactionBrokerBenefit t



end