CREATE procedure  [fillFactTrnInsuranceToPerson]
as
begin
	
	declare @maxDate date = (select max(happenDate) from factTrnInsuranceToPerson)

	select t2.amount, t4.policyNumber, t3.coverageId, t1.driverId, t1.vehicleId, t1.latitude, t1.longitude,
		t1.happenDate, t1.happenTime, t5.surregateKey, t1.happenDate, t1.happenTime
	from SA_ThirdPartyAccident as t1 inner join SA_InsurancePaymentToPerson as t2 on t1.latitude = t2.latitude
		and t1.longitude = t2.longitude and t1.happenDate = t2.happenDate and t1.happenTime = t2.happenTime
		inner join  SA_VehicleCoverage as t3 on t1.vehicleId = t3.vehicleId
		inner join SA_PolicyCoverage as t4 on t3.coverageId = t4.coverageId
		inner join dimTrafficViolationCode as t5 on t1.trafficViolationCode = t5.trafficViolationCodeId
	where t1.happenDate > @maxDate
end

