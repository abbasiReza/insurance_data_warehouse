
create procedure procedureDimDriver
as
begin
	if exists(select * from dimDriverCopy) and
		not exists(select * from dimDriver)
		return -1;

	truncate table dimDriverCopy;
	truncate feedFromSource
	
	insert into dbo.feedFromSource
		select d.driverId, d.firstName, d.lastName, d.emailAddress, d.phoneNumber, d.cellNumber, d.nationalCode,
				 l.licenseIssuedDate, l.licenseNumber, d.isPrimaryPolicyHolder, d.relationWithPolicyPrimaryHolder, g.genderName,
				 da.address, da.cityId, da.cityName, da.stateId, da.stateName, da.zipCode
		from sa_driver as d inner join sa_gender as g on (g.genderCode = d.genderCode)
				inner join sa_driverAddress as da on (da.driverAddressId = d.driverAddressId)

	set IDENTITY_INSERT dbo.dimDriverCopy on;
	
	insert into dimDriverCopy(surregateKey, driverId, firstName, lastName, emailAddress, phoneNumber, cellNumber, nationalCode,
				 licenseIssuedDate, licenseNumber, isPrimaryPolicyHolder, relationWithPolicyPrimaryHolder, gender, address, cityId,
				 cityName, stateId, stateName, zipCode, currentFlag, start_date, end_date)
	select surregateKey, driverId, firstName, lastName, emailAddress, phoneNumber, cellNumber, nationalCode,
				 licenseIssuedDate, licenseNumber, isPrimaryPolicyHolder, relationWithPolicyPrimaryHolder, gender, address, cityId,
				 cityName, stateId, stateName, zipCode, currentFlag, start_date, end_date
	from dimDriver
	where currentFlag = 0;

	insert into dimDriverCopy(surregateKey, driverId, firstName, lastName, emailAddress, phoneNumber, cellNumber, nationalCode,
				 licenseIssuedDate, licenseNumber, isPrimaryPolicyHolder, relationWithPolicyPrimaryHolder, gender, address, cityId,
				 cityName, stateId, stateName, zipCode, currentFlag, start_date, end_date)
	select cdfstli.surregateKey, cdfstli.driverId, cdfstli.firstName, cdfstli.lastName, cdfstli.emailAddress, cdfstli.phoneNumber,
			 cdfstli.cellNumber, cdfstli.nationalCode, cdfstli.licenseIssuedDate, cdfstli.licenseNumber, cdfstli.isPrimaryPolicyHolder,
			 cdfstli.relationWithPolicyPrimaryHolder, cdfstli.gender, cdfstli.address, cdfstli.cityId, cdfstli.cityName,
			 cdfstli.stateId, cdfstli.stateName, cdfstli.zipCode, cdfstli.currentFlag, cdfstli.start_date, cdfstli.end_date
	from dimDriver as cdfstli left outer join feedFromSource as cdustfs
	on(cdfstli.driverId = cdustfs.driverId)
	where (cdustfs.driverId is null and cdfstli.currentFlag = 1) or (cdustfs.licenseIssuedDate = cdfstli.licenseIssuedDate and cdfstli.currentFlag = 1);

	
	insert into dimDriverCopy(surregateKey, driverId, firstName, lastName, emailAddress, phoneNumber, cellNumber, nationalCode,
				 licenseIssuedDate, licenseNumber, isPrimaryPolicyHolder, relationWithPolicyPrimaryHolder, gender, address, cityId,
				 cityName, stateId, stateName, zipCode, currentFlag, start_date, end_date)
	select cdfstli.surregateKey, cdfstli.driverId, cdfstli.firstName, cdfstli.lastName, cdfstli.emailAddress, cdfstli.phoneNumber,
			 cdfstli.cellNumber, cdfstli.nationalCode, cdfstli.licenseIssuedDate, cdfstli.licenseNumber, cdfstli.isPrimaryPolicyHolder,
			 cdfstli.relationWithPolicyPrimaryHolder, cdfstli.gender, cdfstli.address, cdfstli.cityId, cdfstli.cityName, cdfstli.stateId, 
			 cdfstli.stateName, cdfstli.zipCode, 0 as currentFlag, cdfstli.startDate, GETDATE() as endDate
	from dimDriver as cdfstli inner join feedFromSource as cdustfs
	on(cdfstli.driverId = cdustfs.driverId)
	where cdfstli.licenseIssuedDate != cdustfs.licenseIssuedDate and cdfstli.currentFlag = 1;

	set identity_insert dimDriverCopy off;
	
	insert into dimDriverCopy
	select cdfstli.surregateKey, cdfstli.driverId, cdfstli.firstName, cdfstli.lastName, cdfstli.emailAddress, cdfstli.phoneNumber,
			 cdfstli.cellNumber, cdfstli.nationalCode, cdfstli.licenseIssuedDate, cdfstli.licenseNumber, cdfstli.isPrimaryPolicyHolder,
			 cdfstli.relationWithPolicyPrimaryHolder, cdfstli.gender, cdfstli.address, cdfstli.cityId, cdfstli.cityName, cdfstli.stateId, 
			 cdfstli.stateName, cdfstli.zipCode, 1 as currentFlag, GETDATE() as startDate, NULL as endDate
	from dimDriver as cdfstli inner join feedFromSource as cdustfs
	on(cdfstli.driverId = cdustfs.driverId)
	where cdfstli.licenseIssuedDate != cdustfs.licenseIssuedDate and cdfstli.currentFlag = 1;

	insert into dimDriverCopy
	select cdustfs.surregateKey, cdustfs.driverId, cdustfs.firstName, cdustfs.lastName, cdustfs.emailAddress, cdustfs.phoneNumber,
			 cdustfs.cellNumber, cdustfs.nationalCode, cdustfs.licenseIssuedDate, cdustfs.licenseNumber, cdustfs.isPrimaryPolicyHolder,
			 cdfstli.relationWithPolicyPrimaryHolder, cdfstli.gender, cdfstli.address, cdfstli.cityId, cdfstli.cityName, cdfstli.stateId, 
			 cdustfs.stateName, cdustfs.zipCode, 1 as currentFlag, GETDATE() as startDate, NULL as endDate
	from dimDriver as cdfstli right outer join feedFromSource as cdustfs
	on(cdfstli.driverId = cdustfs.driverId)
	where cdfstli.driverId is null;
	
	truncate table dimDriver;

	set IDENTITY_INSERT dbo.dimDriver on;

	insert into dimDriver(surregateKey, driverId, firstName, lastName, emailAddress, phoneNumber, cellNumber, nationalCode,
				 licenseIssuedDate, licenseNumber, isPrimaryPolicyHolder, relationWithPolicyPrimaryHolder, gender, address, cityId,
				 cityName, stateId, stateName, zipCode, currentFlag, start_date, end_date)
	select surregateKey, driverId, firstName, lastName, emailAddress, phoneNumber, cellNumber, nationalCode,
				 licenseIssuedDate, licenseNumber, isPrimaryPolicyHolder, relationWithPolicyPrimaryHolder, gender, address, cityId,
				 cityName, stateId, stateName, zipCode, currentFlag, start_date, end_date
	from dimDriverCopy as cdfstli;

	set IDENTITY_INSERT dbo.dimDriver off;

	truncate table dimDriverTempLastInfo;
	truncate table feedFromSource;
	truncate table dimDriverCopy;
end;
