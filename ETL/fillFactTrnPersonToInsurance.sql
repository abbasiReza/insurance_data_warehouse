
CREATE procedure  [fillFactTrnPersonToInsurance]
as
begin

	declare @maxDate date = (select max(paymentDate) from factTrnPersonToInsurance)

	insert into factTrnPersonToInsurance
		select t1.amount, t2.balance, t2.policyNumber, t3.coverageId, t5.driverId, t1.paidDate, t1.paidTime 
		from SA_Payment as t1 inner join SA_Bill as t2 on t1.billId = t2.billId
			inner join SA_PolicyCoverage as t3 on t2.policyNumber = t3.policyNumber
			inner join SA_VehicleCoverage as t4 on t3.coverageId = t4.coverageId
			inner join SA_VehicleDriver as t5 on t4.vehicleId = t5.vehicleId
		where t1.paidDate > @maxDate
end
