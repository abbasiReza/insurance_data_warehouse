

CREATE procedure  [fillFactSnapMonthPersonToInsurance]
as
begin
	if (exists(select * from sumTrnPersonToInsurance) and not exists(select * from factSnapMonthPersonToInsurance))
		return -1;

	declare @lastDateUsed date  = (select max(paymentDate) from factSnapMonthPersonToInsurance)

	if (@lastDateUsed is null)
		set @lastDateUsed = dateadd(day, -1, (select min(paymentDate) from factTrnPersonToInsurance))

	declare @curr date = dateadd(day, +1, @lastDateUsed)
	declare @end date = dateadd(month, +1, @curr)

	while(@curr <= @end) begin
		truncate table todayTrnInsuranceToPerson
		insert into todayTrnPersonToInsurance
			select  sum(amount), last_value(balance) over (partition by policyNumber, coverageId, driverId order by paymentTime) as balance, policyNumber, coverageId, driverId, paymentDate, paymentTime
			from factTrnPersonToInsurance
			where paymentDate >= @curr and paymentDate < dateadd(day, +1, @curr)
			group by policyNumber, coverageId, driverId, paymentDate, paymentTime

		truncate table tempSumTrnPersonToInsurance
		insert into tempSumTrnPersonToInsurance
			select amount, balance, policyNumber, coverageId, driverId, paymentDate, paymentTime
			from sumTrnPersonToInsurance

		truncate table sumTrnPersonToInsurance
		insert into sumTrnPersonToInsurance
			select isnull(t1.amount, 0) + isnull(t2.amount, 0), isnull(t1.balance, t2.balance),
				isnull(t1.policyNumber, t2.policyNumber), isnull(t1.coverageId, t2.coverageId),
				isnull(t1.driverId, t2.driverId), isnull(t1.paymentDate, t2.paymentDate), 
				isnull(t1.paymentTime, t2.paymentTime)
			from todayTrnPersonToInsurance as t1 full outer join tempSumTrnPersonToInsurance as t2
				on t1.policyNumber = t2.policyNumber and t1.coverageId = t2.coverageId and t1.driverId = t2.driverId 
				and t1.paymentDate = t2.paymentDate and t1.paymentTime = t2.paymentTime

		set @curr = dateadd(day, +1, @curr)
	end

	insert into factSnapMonthPersonToInsurance
		select amount, balance, policyNumber, coverageId, driverId, paymentDate
		from sumTrnPersonToInsurance
end
