create table temp1factTranBrokerBenefit(
driverId char(5),
brokerId char(5),
policyNumber char(3),
createDate date,
totalCost int,
)



create procedure factTranBrokerBenefit
as
begin
declare @maxDate date;
set @maxDate =  (select max(CAST(date as date)) from factTranBrokerBenefit)

truncate table temp1factTranBrokerBenefit

insert into temp1factTranBrokerBenefit
select (select drvierSurKey from dimDriver where dimDriver.driverId=c.driverId and current_flag=1) as drvierSurKey,c.brokerId,d.policyNumber,d.createdDate,c.contract_cost
from SA_attract_Customer c ,SA_driver d
where c.driverId=d.driverId and d.createdDate>@maxDate

insert into factTransactionBrokerBenefit
select b.branchId,(select s.surKeyBroker from dimBrokers s where s.brokerId=b.brokerId and s.currentFlag=1),t.drvierSurKey,t.policyNumber,t.createDate,t.totalCost,(b.PPR*t.totalCost)/100
from temp1factTranBrokerBenefit t,SA_branch_broker b
where t.brokerId=b.brokerId

end