

CREATE procedure  [fillFactSnapMonthInsuranceToPerson]
as
begin
	if (exists(select * from sumTrnInsuranceToPerson) and not exists(select * from factSnapMonthInsuranceToPerson))
		return -1;

	declare @lastDateUsed date  = (select max(happenDate) from factSnapMonthInsuranceToPerson)

	if (@lastDateUsed is null)
		set @lastDateUsed = dateadd(day, -1, (select min(happenDate) from factTrnInsuranceToPerson))

	declare @curr date = dateadd(day, +1, @lastDateUsed)
	declare @end date = dateadd(month, +1, @curr)

	while(@curr <= @end) begin
		truncate table todayTrnInsuranceToPerson
		insert into todayTrnInsuranceToPerson
			select  sum(amount), coverageId, driverId, vehicleId, happenDate
			from factTrnInsuranceToPerson
			where happenDate >= @curr and happenDate < dateadd(day, +1, @curr)
			group by coverageId, driverId, vehicleId, happenDate

		truncate table tempSumTrnInsuranceToPerson
		insert into tempSumTrnInsuranceToPerson
			select amount, coverageId, driverId, vehicleId, happenDate
			from sumTrnInsuranceToPerson

		truncate table sumTrnInsuranceToPerson
		insert into sumTrnInsuranceToPerson
			select isnull(t1.amount, 0) + isnull(t2.amount, 0), isnull(t1.coverageId, t2.coverageId),
				isnull(t1.driverId, t2.driverId), isnull(t1.vehicleId, t2.vehicleId), isnull(t1.happenDate, t2.happenDate)
			from todayTrnInsuranceToPerson as t1 full outer join tempSumTrnInsuranceToPerson as t2
				on t1.coverageId = t2.coverageId and t1.driverId = t2.driverId and t1.vehicleId = t2.vehicleId
					and t1.happenDate = t2.happenDate

		set @curr = dateadd(day, +1, @curr)
	end

	insert into factSnapMonthInsuranceToPerson
		select amount, coverageId, driverId, vehicleId, happenDate
		from sumTrnInsuranceToPerson
end