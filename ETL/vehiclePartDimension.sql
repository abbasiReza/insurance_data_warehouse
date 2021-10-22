create table dimVehiclePart(
	partId int primary key,
	partName varchar(30),
	originalPrice numeric(4,4)
);

create procedure procedureDimVehiclePart
as
begin
	truncate table dimVehiclePart;
	insert into dimVehiclePart
		select isNULL(vp.partId, dvp.partId),
			 isNULL(vp.partName, dvp.partName),
			 isNULL(vp.originalPrice, dvp.originalPrice)
		from sa_vehiclePart as vp full outer join dimVehiclePart as dvp on (dvp.partId = vp.partId); 
end