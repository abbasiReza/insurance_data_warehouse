

CREATE procedure  [fillFactAccInsuranceToPerson]
as
begin
	if (exists(select * from sumTrnInsuranceToPerson) and not exists(select * from factAccInsuranceToPerson))
		return -1;

	declare @curr date = (select min(happenDate) from factSnapMonthInsuranceToPerson)
	declare @end date = (select max(happenDate) from factSnapMonthInsuranceToPerson)

	while(@curr <= @end) begin
		truncate table oneMonthInsuranceToPerson
		insert into oneMonthInsuranceToPerson
			select  amount, coverageId, driverId, vehicleId
			from factSnapMonthInsuranceToPerson
			where happenDate >= @curr and happenDate < dateadd(month, +1, @curr)

		truncate table tempFactAccInsuranceToPerson
		insert into tempFactAccInsuranceToPerson
			select amount, coverageId, driverId, vehicleId
			from sumAccInsuranceToPerson

		truncate table sumAccInsuranceToPerson
		insert into sumAccInsuranceToPerson
			select isnull(t1.amount, 0) + isnull(t2.amount, 0), isnull(t1.coverageId, t2.coverageId),
				isnull(t1.driverId, t2.driverId), isnull(t1.vehicleId, t2.vehicleId)
			from oneMonthInsuranceToPerson as t1 full outer join tempFactAccInsuranceToPerson as t2
				on t1.coverageId = t2.coverageId and t1.driverId = t2.driverId and t1.vehicleId = t2.vehicleId

		set @curr = dateadd(day, +1, @curr)
	end

	insert into factAccInsuranceToPerson
		select amount, coverageId, driverId, vehicleId
		from sumTrnInsuranceToPerson
end


