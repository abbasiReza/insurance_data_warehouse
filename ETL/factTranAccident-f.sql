
create table temp1factTranAccident(
expertId char(5),
latitude numeric(4,4),
longitude numeric(4,4),
date datetime,
drvierSurKey char(5),
cost int
)




create procedure factTranAccident
as 
begin

declare @maxDate date;
set @maxDate =  (select max(CAST(date as date)) from factTransactionAccident)

truncate table temp1factTranAccident;

insert  into temp1factTranAccident
select s.expertId,s.coordinateX,s.coordinateY,s.happenTime,a.driverId,s.amount
from SA_accident_cost_by_expert s,SA_accident a
where s.coordinateX=a.coordinateX and s.coordinateY=a.coordinateY and s.happenTime=a.happenTime and s.happenTime>@maxDate

insert into factTransactionAccident
select t.expertId,e.branchId,t.latitude,t.longitude,(select drvierSurKey from dimDriver d where d.driverId=t.driverId and current_flag=1),t.date,t.cost
from temp1factTranAccident t,SA_branch_expert e
where t.expertId=e.expertId

end