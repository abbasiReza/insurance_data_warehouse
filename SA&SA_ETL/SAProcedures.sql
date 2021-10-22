create procedure procedureSa_vehiclePart
as
begin
	delete from sa_vehiclePart;
	insert into sa_vehiclePart
		select partId, partName, originalPrice, additionalInfo
		from vehiclePart;
END;

CREATE TABLE logSa_accidentVehiclePart(
	currentDate DATE, 
	endDate DATE
);
SELECT * FROM sa_accidentVehiclePart

create procedure procedureSa_accidentVehiclePart
as
begin
	declare @startDate date = (select max(happenTime) from sa_accidentVehiclePart);
	declare @endDate date = (select max(happenTime) from accidentVehiclePart);

	if (select MAX(currentDate) from logSa_accidentVehiclePart) <= (select MAX(endDate) from logSa_accidentVehiclePart)
		return -1;
	if @startDate is not NULL
		set @startDate =DATEADD(DAY,1,@startDate)
	else
		set @startDate = (select min(happenTime) from accidentVehiclePart);

	while(@startDate <= @endDate)
	begin
		insert into sa_accidentVehiclePart 
		select partId, happenTime, coordinateX, coordinateY, damageCost 
		from accidentVehiclePart;

		set @startDate =DATEADD(DAY,1,@startDate)
		
		delete from logSa_accidentVehiclePart;

		insert into logSa_accidentVehiclePart values(@startDate, @endDate);
	end
end


create procedure procedureSa_gender
as
begin
	delete from sa_gender;

	insert into sa_gender
	select genderCode, genderName
	from gender;
END

create procedure procedureSa_martial
as
begin
	delete from SA_martial;

	insert into SA_martial
	select statusCode, statusName,explaintion
	from martial;
END


create procedure procedureSa_state
as 
begin
	delete from sa_state;

	insert into sa_state
	select stateId, stateName
	from state;
end

create procedure procedureSa_city
as
begin
	delete from sa_city;

	insert into sa_city 
	select cityId, cityName, stateId
	from city;
END


create procedure procedureSa_location
as
begin
	delete from sa_location;
	
	insert into sa_location
	select x, y, street, cityID
	from location;
end
SELECT * FROM driver
create procedure procedureSa_driver
as
begin
	delete from sa_driver;

	insert into sa_driver (driverId,policyNumber,title,firstName,lastName,middleInitial,DOB,emailAddress,phoneNumber,cellNumber,nationalCode,licenseId,isPrimaryPolicyHolder,relationWithPrimaryPolicyHolder,genderCode,martialStatusCode,createdDate,active,licenseIssuedDate,licenseNumber)
	select	d.driverId, d.policyNumber, d.title, d.firstName, d.lastName, d.middleInitial, d.DOB, d.emailAddress, d.phoneNumber,
			d.cellNumber, d.SSN, d.licenseId, d.isPrimaryPolicyHolder, d.relationWithPrimaryPolicyHolder, d.genderCode,
			d.martialStatusCode, d.createdDate, d.active, l.licenseIssuedDate, l.licenseNumber
	from driver as d inner join licenseInfo as l on (l.Id = d.licenseId);
END

create procedure procedureSa_accidentStatus
as
begin
	delete from SA_accidentStatus;

	insert into SA_accidentStatus
	select accidentStatusCode, accidentStat,additionalInfo
	from accidentStatus;
END

create procedure procedureSa_drvierAddress
as 
begin
	delete from sa_driverAddress;

	insert into sa_driverAddress
	select driverAddressId, driverId, address, cityCode, zipCode, isitGarageAddress
	from driverAddress;
END
EXEC procedureSa_drvierAddress

SELECT * FROM driverAddress left OUTER JOIN  driver ON (driverAddress.driverId = driver.driverId)
WHERE driver.driverId = NULL



CREATE PROCEDURE procedureSa_policy
AS
BEGIN
delete from SA_policy
INSERT INTO SA_policy
SELECT p1.policyNumber,
p1.policyEffectiveDate ,
p1.policyExpireDate ,
p1.optionCode ,
p2.optionDesc ,
p1.totalAmount  ,
p1.active  ,
p1.additionalInfo ,
p1.createDate 
FROM policy p1 INNER JOIN paymentOptions p2 ON p1.optionCode=p2.optionCode
END


CREATE PROCEDURE procedureSa_branch
AS
BEGIN
delete from SA_branch
insert into SA_branch
select branchId,cityID,address,level
from branch

END

CREATE PROCEDURE procedureSa_expert
AS
BEGIN
delete from SA_branch_expert
insert into SA_branch_expert
select expertId,branchId,firstName,lastName,nationalCode,'',cityId,address,hireDate,phoneNumber,specialty
from branch_expert
END



create procedure  procedureSa_Vehicle
as
BEGIN
	delete from SA_vehicle
	insert into SA_Vehicle
	select vehicleId, policyNumber, year, make, model, trim, mileage, vinNumber, vehicleNumberPlate, vehicleRegisteredState,
		active
	from vehicle

END
CREATE TABLE logSa_accident(
currentDate DATE,
endDate date


);
 SELECT * FROM sa_accident
 SELECT * FROM sa_vehicle
 SELECT * FROM accident
 SELECT * FROM dbo.logSa_accident
create procedure procedureSa_accident
as
begin
	declare @startDate date = (select max(happenTime) from sa_accident);
	declare @endDate date = (select max(happenTime) from accident);


	if (select currentDate from logSa_accident) <= (select endDate from logSa_accident)
		return -1;
	if @startDate is not NULL
		set @startDate =DATEADD(DAY,1,@startDate)
	else
		set @startDate = (select min(happenTime) from accident);

		

	while(@startDate < @endDate)
	begin
		insert into sa_accident 
		select vehicleId, expertId, happenTime, coordinateX, coordinateY, totalFine, payByInsurance, accidentStatusCode, driverId 
		from accident
		WHERE happenTime>=@startDate AND happenTime<DATEADD(DAY,1,@startDate)

		set @startDate =DATEADD(DAY,1,@startDate)
		
		delete from logSa_accident;
		insert into logSa_accident values(@startDate, @endDate);
	end
end

CREATE PROCEDURE procedureSa_accident_cost_by_expert
AS
BEGIN
delete from SA_accident_cost_by_expert
insert into SA_accident_cost_by_expert (happenTime ,
	coordinateX ,
	coordinateY ,
	expertId ,
	factorNumber ,
	amount ,
	registrationDate )
select happenDate,latitude,longitude,expertId,factorNumber,amount,registrationDate
from accident_cost_by_expert
END
SELECT * FROM sa_accident
SELECT * from accident_cost_by_expert;

SELECT * 
FROM accident_cost_by_expert AS b FULL OUTER JOIN accident AS a ON (a.coordinateY = b.latitude and a.coordinateX=b.longitude AND a.happenTime = b.happenDate)
WHERE b.latitude = NULL

SELECT * FROM accident_cost_by_expert
SELECT * FROM accident WHERE 1=0

CREATE PROCEDURE procedureSa_salaryExpert
AS 
BEGIN
delete from SA_salaryExpert
insert into SA_salaryExpert
select expertId,branchId,amount,from_date,to_date
from salaryExpert
END


CREATE PROCEDURE procedureSa_branch_broker
AS 
BEGIN
delete from SA_branch_broker
insert into SA_branch_broker
select brokerId,branchId,PPR,Specialty,firstName,lastName,nationalCode,cityId,address,hireDate,phoneNumber
from branch_broker
END


CREATE PROCEDURE procedureSa_salaryBroker
AS
BEGIN
delete from SA_salaryBroker
insert into SA_salaryBroker
select brokerId,branchId,amount,from_date,to_date
from salaryBroker
END



CREATE PROCEDURE procedureSa_attract_Customer
AS
BEGIN
delete from SA_attract_Customer
insert into SA_attract_Customer
select driverId,brokerId,description,contract_cost,startDateContract,endDateContract,createDate
from attract_Customer
END

CREATE PROCEDURE procedureSa_employee
AS
BEGIN
delete from SA_employee
insert into SA_employee
select personalCode,firstName,lastName,nationalCode,cityId,address,phoneNumber,emailAddress,branchId,hireDate
from employee
END


CREATE PROCEDURE procedureSa_salaryEmployee
AS
BEGIN

delete from SA_salaryEmployee
INSERT INTO SA_salaryEmployee
SELECT personalCode,branchId,amount,from_date,to_date
FROM salaryEmployee
END



CREATE PROCEDURE procedureSa_branch_boss
AS
BEGIN
delete from SA_branch_boss
INSERT INTO SA_branch_boss
SELECT BossId,firstName,lastName,nationalCode,'',cityId,address,phoneNumber,branchId,DateBcomeManager
FROM branch_boss
END

CREATE PROCEDURE procedureSa_salaryBoss
AS 
BEGIN
delete from SA_salaryBoss
insert into SA_salaryBoss
select BossId,branchId,amount,from_date,to_date
from salaryBoss
END


CREATE TABLE logRunningSA(
	massage VARCHAR(300)
);



CREATE PROCEDURE fillSA
AS
BEGIN
	IF EXISTS (SELECT * FROM dbo.logRunningSA)
		RETURN -1;

		INSERT INTO dbo.logRunningSA
						(
						    massage
						)
						VALUES
						('executing procedureSa_policy' -- massage - varchar(300)
						    );
							EXEC procedureSa_policy;

		INSERT INTO	dbo.logRunningSA
	(
	    massage
	)
	VALUES
	('executing procedureSa_state ...' -- massage - varchar(300)
	    );
	EXEC procedureSa_state;

	INSERT INTO dbo.logRunningSA
	(
	    massage
	)
	VALUES
	('executing procedureSa_city ...' -- massage - varchar(300)
	    );
		EXEC procedureSa_city;
		SELECT * FROM city
		INSERT INTO	dbo.logRunningSA
							(
							    massage
							)
							VALUES
							('executing procedureSa_branch' -- massage - varchar(300)
							    );
								EXEC procedureSa_branch;

					INSERT INTO dbo.logRunningSA
								(
								    massage
								)
								VALUES
								('executing procedureSa_expert' -- massage - varchar(300)
								    );
									EXEC procedureSa_expert;

									INSERT INTO dbo.logRunningSA
									(
									    massage
									)
									VALUES
									('executing procedureSa_Vehicle' -- massage - varchar(300)
									    );
										EXEC procedureSa_Vehicle;
										SELECT * FROM vehicle
										SELECT * FROM policy INNER join paymentOptions ON (policy.optionCode = paymentOptions.optionCode)
										SELECT * FROM policy;
										SELECT * FROM policy
										SELECT * FROM policy FULL OUTER JOIN vehicle ON policy.policyNumber=vehicle.policyNumber WHERE policy.policyNumber IS null
									

	INSERT INTO dbo.logRunningSA
	(
	    massage
	)
	VALUES
	('executing procedureSa_vehiclePart ... ' -- massage - varchar(300)
	    );
	EXEC dbo.procedureSa_vehiclePart;

	
		INSERT INTO dbo.logRunningSA
		(
		    massage
		)
		VALUES
		('executing procedureSa_location ...' -- massage - varchar(300)
		    );
			EXEC procedureSa_location;

			INSERT INTO dbo.logRunningSA
	(
	    massage
	)
	VALUES
	('executing procedureSa_gender ...' -- massage - varchar(300)
	    );
	EXEC procedureSa_gender;

	INSERT INTO dbo.logRunningSA
	(
	    massage
	)
	VALUES
	('executing procedureSa_martial ...' -- massage - varchar(300)
	    );
	EXEC procedureSa_martial;

	INSERT INTO dbo.logRunningSA
			(
			    massage
			)
			VALUES
			('executing procedureSa_driver ...' -- massage - varchar(300)
			    );
				EXEC procedureSa_driver;

				INSERT INTO dbo.logRunningSA
				(
				    massage
				)
				VALUES
				('executing procedureSa_accidentStatus ...' -- massage - varchar(300)
				    );
					EXEC procedureSa_accidentStatus;

					INSERT INTO dbo.logRunningSA
										(
										    massage
										)
										VALUES
										('executing procedureSa_accident ...' -- massage - varchar(300)
										    );
											EXEC procedureSa_accident;
											SELECT * FROM SA_accident

	INSERT INTO dbo.logRunningSA
	(
	    massage
	)
	VALUES
	('executing procedureSa_accidentVehiclePart ...' -- massage - varchar(300)
	    );
	EXEC procedureSa_accidentVehiclePart;
	SELECT * FROM sa_accidentVehiclePart
	

	

	
		
			

				

					INSERT INTO	dbo.logRunningSA
					(
					    massage
					)
					VALUES
					('executing procedureSa_drvierAddress' -- massage - varchar(300)
					    );
						EXEC procedureSa_drvierAddress;
						

							

										
											INSERT INTO dbo.logRunningSA
											(
											    massage
											)
											VALUES
											('executing procedureSa_accident_cost_by_expert ...' -- massage - varchar(300)
											    );
												EXEC procedureSa_accident_cost_by_expert;

												INSERT INTO dbo.logRunningSA
												(
												    massage
												)
												VALUES
												('executing procedureSa_salaryExpert ...' -- massage - varchar(300)
												    );
													EXEC procedureSa_salaryExpert;

													INSERT INTO dbo.logRunningSA
													(
													    massage
													)
													VALUES
													('executing procedureSa_branch_broker ...' -- massage - varchar(300)
													    );
														EXEC procedureSa_branch_broker;
														
													INSERT INTO dbo.logRunningSA
													(
													    massage
													)
													VALUES
													('executing procedureSa_salaryBroker ...' -- massage - varchar(300)
													    );
														EXEC procedureSa_salaryBroker;

														INSERT INTO dbo.logRunningSA
														(
														    massage
														)
														VALUES
														('executing procedureSa_attract_Customer ...' -- massage - varchar(300)
														    );
															EXEC procedureSa_attract_Customer;

															INSERT INTO dbo.logRunningSA
															(
															    massage
															)
															VALUES
															('executing procedureSa_employee' -- massage - varchar(300)
															    );
																EXEC procedureSa_employee;

																INSERT INTO dbo.logRunningSA
																(
																    massage
																)
																VALUES
																('executing procedureSa_salaryEmployee ...' -- massage - varchar(300)
																    );
																	EXEC procedureSa_salaryEmployee;

																	INSERT INTO dbo.logRunningSA
																	(
																	    massage
																	)
																	VALUES
																	('executing procedureSa_branch_boss ...' -- massage - varchar(300)
																	    );
																		EXEC procedureSa_branch_boss;

																		INSERT INTO dbo.logRunningSA
																		(
																		    massage
																		)
																		VALUES
																		('executing procedureSa_salaryBoss ...' -- massage - varchar(300)
																		    );
																			EXEC procedureSa_salaryBoss;

																			delete from dbo.logRunningSA;

END;

EXEC fillSA
TRUNCATE TABLE dbo.logRunningSA

SELECT * FROM dbo.logRunningSA

-----------------------------------------------------------------------------------------






create procedure  [fillSA_Bill]
as
begin
	insert into SA_Bill
	select billId, policyNumber, dueDate, minimumPayment, createDate, balance
	from bill
end


create procedure  [fillSA_Coverage]
as
begin
insert into SA_Coverage
	select coverageId, coverageName, coverageGroupCode, code
	from coverage
end


create procedure  [fillSA_CoverageGroup]
as
begin
insert into SA_CoverageGroup
	select 	groupCode, groupName, Explaintion, isPersonCoverage, isVehicleCoverage
	from coverageGroup
end


create procedure  [fillSA_InsurancePaymentToPerson]
as
begin
	insert into SA_InsurancePaymentToPerson
	select amount, loserNationalCode, latitude, longitude, happenDate, happenTime, paymnetDate, paymentTime
	from insurancePaymentToPerson
end


create procedure  [fillSA_Payment]
as
begin
	insert into SA_Payment
	select paymentId, billId, paidDate, amount, paymentMethodCode, payerFirstName, payerLastName, cardNumber, zipcode,
	cardExpireDate, cardType, debitOrCredit, bankName, AccountNNumber, addtionalInfo, createDate
	from payment
end


create procedure  [fillSA_PaymentOption]
as
begin
	insert into SA_PaymentOption
		select 	optionCode ,optionDesc ,lastUpdate
		from paymentOptions
end


create procedure  [fillSA_Policy]
as
begin
	insert into SA_Policy
		select policyNumber, policyEffectiveDate, policyExpireDate, optionCode, totalAmount, active,
		additionalInfo, createDate date
		from policy
end


create procedure  [fillSA_PolicyCoverage]
as
begin
	insert into SA_PolicyCoverage
	select policyNumber, coverageId, createDate, active
	from policy_coverage
end


create procedure  [fillSA_ThirdPartyAccident]
as
begin
	insert into SA_ThirdPartyAccident
	select driverIdL, vehicleId, latitude, longitude, happenDate, happenTime, trafficViolationCode, statusDamageCode
	from thirdPartyAccident
end


create procedure  [fillSA_TrafficViolationCode]
as
begin
	insert into SA_TrafficViolationCode
		select trafficViolationCodeId, trafficViolationQuestion, codeDescription, point
		from trafficViolationCode
end


create procedure  [fillSA_Vehicle]
as
begin
	insert into SA_Vehicle
	select vehicleId, policyNumber, year, make, model, trim, mileage, vinNumber, vehicleNumberPlate, vehicleRegisteredState,
		active
	from vehicle

end


create procedure  [fillSA_VehicleCoverage]
as
begin
	insert into SA_VehicleCoverage
	select vehicleId, coverageId, createDate, active
	from vehiclCoverage
end


create procedure  [fillSA_VehicleDriver]
as
begin
	insert into SA_VehicleDriver
	select vehicleId, driverId, driverForBussiness, isPrimaryDriver, everyDayMileage, createdDate, active
	from vehicle_driver
end