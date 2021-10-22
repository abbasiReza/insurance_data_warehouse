
CREATE procedure  [fillDimVehicle]
as
begin

	if exists(select * from tempDimVehicle) and not exists(select * from dimVehicle)
	return -1;

	truncate table tempDimVehicle
	insert into tempDimVehicle
		select vehicleId, policyNumber, year, make, model, trim, mileage, vinNumber, vehicleNumberPlate, vehicleRegisteredState, active
		from dimVehicle
	
	truncate table dimVehicle
	insert into dimVehicle
		select isnull(t1.vehicleId, t2.vehicleId), isnull(t1.policyNumber, t1.policyNumber),
		 isnull(t1.year, t2.year), isnull(t1.make, t2.make),
		  isnull(t1.model, t2.model), isnull(t1.trim, t2.trim), 
		  isnull(t1.mileage, t2.mileage), isnull(t1. vinNumber, t2. vinNumber),
		  isnull(t1.vehicleNumberPlate, t2.vehicleNumberPlate), isnull(t1.vehicleRegisteredState, t2.vehicleRegisteredState),
		  isnull(t1.active, t2.active)
		from SA_Vehicle as t1 full outer join tempDimVehicle as t2 on t1.vehicleId = t2.vehicleId  
end

