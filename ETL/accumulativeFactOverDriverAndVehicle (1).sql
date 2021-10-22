create table LogAccFactOverDriverAndVehicle(
	lastDate date
);

create procedure procedureAccFactOverDriverAndVehicle
as
begin
	declare @startDate date = (select lastDate from LogAccFactOverDriverAndVehicle);
	declare @endDate date = (select max(date) from trnasactionFactOverPart);

	if @startDate is null
		set @startDate = (select min(date) from transactionFactOverPart);
		
--	while @startDate < @endDate			--due to insurance space, no need to set loop over day
	
	insert into feedFromTransactionFact
		select max(date) as lastTimeAccident, driverId, vehicleId, sum(payByInsurance) as totalPayByInsurance, count(*) as totalAccident
		from transactionFactOverPart
		where date <= @endDate and date >= DATEADD(day, 1, @startDate)
		group by driverId, vehicleId;

	insert into accFactOverDriverAndVehicleCopy
	select lastTimeAccident, driverId, vehicleId, totalPayByInsurance,  totalAccident
	from accFactOverDriverAndVehicle;

	truncate table accFactOverDriverAndVehicle;

	insert into accFactOverDriverAndVehicle
	select ISNULL(fftf.lastTimeAccident, afodavc.lastTimeAccident) as lastTimeAccident,
			ISNULL(afodavc.driverId, fftf.driverId) as driverId,
			ISNULL(afodavc.vehicleId, fftf.vehicleId) as vehicleId,
			ISNULL(fftf.totalPayByInsurance, 0) + ISNULL(afodavc.totalPayByInsurance, 0) as totalPayByInsurance,
			ISNULL(fftf.totalAccedent, 0) + ISNULL(afodavc.totalAccident, 0)
	from accFactOverDriverAndVehicleCopy as afodavc full outer join feedFromTransactionFact as fftf
			on(afodavc.driverId = fftf.driverId and afodavc.vehicleId = fftf.vehicleId);

	truncate table logAccFactOverDriverAndVehicle;
	
	insert into LogAccFactOverDriverAndVehicle values(@endDate);
end