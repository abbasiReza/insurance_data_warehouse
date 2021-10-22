
create table monthlyBrokerBenfit (
branchId char(5),
brokerSurKey int,

createDate dateTime,
totalCost int,
totalContract int,
--PPR int,
Profits_earned int,
)


create table tempaccBrokerBenefit (
branchId char(5),
brokerSurKey int,

createDate dateTime,
totalCost int,
totalContract int,
--PPR int,
Profits_earned int,
)


create table fact_acc_BrokerBenefit (
branchId char(5),
brokerSurKey int,
countContract int,
totalCost int,
profits_earned int,
foreign key (branchId) references dimLocationBranch (branchId),
foreign key (brokerSurKey) references dimBrokers (surKeyBroker),
)


create procedure fillFactAccBrokerBenefit 
as
begin

declare @minDate date;
declare @maxDate date;
declare @tempMax date;

set @minDate= (select min(createDate) from factSnapshotBrokerBenefit)
set @maxDate= (select max(createDate) from factSnapshotBrokerBenefit)

if @minDate is null
return 1

truncate table tempaccBrokerBenefit
while(@minDate<@maxDate)
begin

truncate table monthlyBrokerBenfit;

insert into monthlyBrokerBenfit
select f.branchId,f.SurKeybroker,f.createDate,f.totalCost,f.totalContract,f.Profits_earned
from factSnapshotBrokerBenefit f
where f.createDate>=@minDate and f.createDate<DATEADD(MONTH, 1, @minDate)

insert into tempaccBrokerBenefit
select ISNULL(m.branchId,t.branchId),
		ISNULL(m.brokerSurKey,t.brokerSurKey),
		ISNULL(m.totalContract,0)+ISNULL(t.totalContract,0),
		ISNULL(m.totalCost,0)+ISNULL(t.totalCost,0),
		ISNULL(m.Profits_earned,0)+ISNULL(t.Profits_earned,0)
from monthlyBrokerBenfit m full outer join tempaccBrokerBenefit t on m.brokerSurKey=t.brokerSurKey


set @minDate=DATEADD(MONTH, 1, @minDate)

end

truncate table fact_acc_BrokerBenefit;

insert into fact_acc_BrokerBenefit
select t.branchId,t.brokerSurKey,t.totalContract,t.totalCost,t.Profits_earned
from tempaccBrokerBenefit t

end
