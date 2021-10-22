--create table logTimeFactTransaction(
--	maxDate date,
--	minDate date
--);


DROP TABLE transactionFactOverPart
create table transactionFactOverPart(
	drvierSurKey INT,
	driverId char(5),
	policyId varchar(20),
	date DateTime,
	timeKey time,
	xCoordinate numeric(4,4),
	yCoordinate numeric(4,4),
	vehicleId char(5),
	partId char(4),
	PayByInsurance numeric(7,2),
	totalAmount numeric(7,2),
	Difference numeric(7,2),
	
);
SELECT * FROM transactionFactOverPart

DROP PROCEDURE procedureFactTransaction
create procedure procedureFactTransaction
as
begin
	if (select maxDate from logTimeFactTransaction) > (select minDate from logTimeFactTransaction)
		return -1;
	
	truncate table logTimeFactTransaction;

	declare @currDate date = (select max([date]) from transactionFactOverPart);
	declare @maxDate date = (select max(happenTime) from sa_accidentVehiclePart);
	declare @minDate date = (select min(happenTime) from sa_accidentVehiclePart);

	set @currDate = dateadd(day, 1, @currDate);

	if @currDate > @minDate
		set @minDate = @currDate;

	insert into logTimeFactTransaction values(@maxDate, @minDate);

	while(@minDate <= @maxDate)
	begin
		with feedFromSource as(
			select d.driverId, d.policyNumber as policyId, a.happenTime as date,
					convert(varchar(8), LEFT(CONVERT(VARCHAR, a.happenTime, 120), 10), 108) as timeKey, a.coordinateX as xCoordinate,
					a.coordinateY as yCoordinate, a.vehicleId, avp.partId, a.payByInsurance, a.totalFine as totalAmount,
					a.payByInsurance - a.totalFine as difference
			from sa_driver as d inner join sa_accident as a on (d.driverId = a.driverId)
					inner join sa_accidentVehiclePart as avp ON (avp.coordinateX = a.coordinateX and avp.coordinateY = a.coordinateY 
																and avp.happenTime = a.happenTime)
			where avp.happenTime >= @minDate and avp.happenTime <  dateadd(day, 1, @minDate)	
		)insert into transactionFactOverPart
			select dd.drvierSurKey, ffs.driverId, ffs.policyId, ffs.date, ffs.timeKey, ffs.xCoordinate, ffs.yCoordinate, ffs.vehicleId,
			ffs.partId, ffs.payByInsurance, ffs.totalAmount, 
					difference
			from feedFromSource as ffs inner join dimDriver as dd on (dd.driverId = ffs.driverId);

		set @minDate = DATEADD(day, 1, @minDate);

		truncate table logTimeFactTransaction;

		insert into logTimeFactTransaction values(@maxDate, @minDate);

	end
end

EXECUTE procedureFactTransaction

SELECT * FROM transactionFactOverPart

SELECT * FROM sa_accidentVehiclePart WHERE happenTime = '1953-01-14'
--select convert(varchar(8), DATEADD(SECOND, 5, '00:00:00'), 108);