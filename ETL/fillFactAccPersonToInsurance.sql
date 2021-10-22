
create procedure  [fillFactAccPersonToInsurance]
as
begin
	
	if (exists(select * from sumTrnPersonToInsurance) and not exists(select * from factAccPersonToInsurance))
		return -1;

	declare @curr date = (select min(paymentDate) from factSnapMonthPersonToInsurance)
	declare @end date = (select max(paymentDate) from factSnapMonthPersonToInsurance)

	while(@curr <= @end) begin
		truncate table oneMonthPersonToInsurance
		insert into oneMonthPersonToInsurance
			select  amount, balance, policyNumber, coverageId, driverId, paymentDate
			from factSnapMonthPersonToInsurance
			where paymentDate >= @curr and paymentDate < dateadd(month, +1, @curr)

		truncate table tempFactAccPersonToInsurance
		insert into tempFactAccPersonToInsurance
			select amount, balance, policyNumber, coverageId, driverId
			from sumAccPersonToInsurance

		truncate table sumAccPersonToInsurance
		insert into sumAccPersonToInsurance
			select isnull(t1.amount, 0) + isnull(t2.amount, 0), isnull(t1.balance, t2.balance), 
			isnull(t1.policyNumber, t2.policyNumber), isnull(t1.coverageId, t2.coverageId),
				isnull(t1.driverId, t2.driverId)
			from oneMonthPersonToInsurance as t1 full outer join tempFactAccPersonToInsurance as t2
				on t1.policyNumber = t2.policyNumber and t1.coverageId = t2.coverageId and t1.driverId = t2.driverId

		set @curr = dateadd(month, +1, @curr)
	end

	insert into factAccPersonToInsurance
		select amount, balance, policyNumber, coverageId, driverId
		from sumAccPersonToInsurance
end