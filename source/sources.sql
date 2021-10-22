create table paymentOptions(
	optionCode char(3) primary key,
	optionDesc varchar(100),
	lastUpdate date
);
create table policy (
policyNumber varchar(20),
policyEffectiveDate date,
policyExpireDate date,
optionCode char(3),
totalAmount int ,
active bit ,
additionalInfo varchar(100),
createDate date,
primary key(policyNumber),
foreign key (optionCode) references paymentOptions(optionCode)
);

create table policyEditlogTable (
policyEditLogId char(3),
policy_Id   char(3),
editedTableName varchar(50),
editedDate date,
editedBy varchar(50),
additionalInfo varchar(100),
primary key(policyEditLogId)
);
create table status(
	statusCode char(2) primary key,
	statusName varchar(20),
	statusDesc varchar(100)
);

create table bill(
billId char(3),
policyNumber varchar(20),
dueDate date,
minimumPayment int,
createDate date,
balance int,
statusCode char(2),
primary key (billId),
foreign key(statusCode) references status(statusCode),
foreign key(policyNumber) references policy(policyNumber)
);

create table paymentMethod(
	paymentMethodCode char(3) primary key,
	paymentMethodDesc varchar(100),
	additionalInfo varchar(500),
	lastUpdate date
);

create table payment (
paymentId char(3),
billId char(3),
paidDate date,
amount int,
paymentMethodCode char(3),
payerFirstName varchar(50),
payerLastName varchar(50),
cardNumber varchar(50),
zipcode varchar(10),
cardExpireDate date,
cardType varchar (20),
debitOrCredit varchar(50),
bankName varchar(100),
AccountNNumber varchar(20),
addtionalInfo varchar(100),
createDate date,
primary key(paymentId),
foreign key (billId) references bill(billId),
foreign key (paymentMethodCode) references paymentMethod(paymentMethodCode)
);



create table gender(
	genderCode char(3) primary key,
	genderName varchar(20)
);

create table martial(
	statusCode char(3) primary key,
	statusName char(20),
	explaintion varchar(100)
);


create table licenseInfo(
	ID char(5) primary key,
	licenseIssuedDate date,
	licenseNumber varchar(20),
	lastUpdate date
);



create table driver (
driverId char(5),
policyNumber char(3),
title varchar(50),
firstName varchar(50),
lastName varchar(50),
middleInitial char(1),
DOB date,
emailAddress varchar(30),
phoneNumber varchar(20),
cellNumber varchar(20),
SSN varchar(12),
licenseId char(5),
isPrimaryPolicyHolder bit,
relationWithPrimaryPolicyHolder varchar(10),
genderCode char (3),
martialStatusCode char(3),
createdDate date,
active bit,
primary key(driverId),
foreign key(genderCode) references gender(genderCode),
foreign key(martialStatusCode) references martial(statusCode),
foreign key(licenseId) references licenseInfo(ID)
);

create table trafficViolationCode (
trafficViolationCodeId char(3),
trafficViolationQuestion varchar(100),
codeDescription varchar(100),
point int,
primary key (trafficViolationCodeId)
);




create table driver_trafficViolation_record (
Id char(5),
driverId char(5),
trafficViolationCodeId char(3),
active bit
primary key (Id),
foreign key(driverId) references driver(driverId),
foreign key (trafficViolationCodeId) references trafficViolationCode (trafficViolationCodeId)
)


create table vehicle (
vehicleId char(5),
policyNumber varchar(20),
year char(4),
make varchar(50),
model varchar(50),
trim varchar(50),
mileage int,
vinNumber varchar(20),
vehicleNumberPlate varchar(20),
vehicleRegisteredState varchar(50),
createdDate date,
active bit,
primary key (vehicleId),
foreign key (policyNumber) references policy(policyNumber)
);



create table vehicle_driver (
Id char (3),
vehicleId char(5),
driverId char(5),
driverForBussiness bit,
isPrimaryDriver bit,
everyDayMileage int,
createdDate date,
active bit,
primary key(Id),
foreign key (vehicleId) references vehicle(vehicleId),
foreign key (driverId) references driver (driverId)
)

create table coverageGroup(
	groupCode char(3) primary key,
	groupName varchar(20),
	Explaintion varchar(100),
	isPersonCoverage bit,
	isVehicleCoverage bit,
	lastUpdate date
);
create table coverage (
coverageId char(3),
coverageName varchar (20),
coverageGroupCode char(3),
code varchar(20),
description varchar (100)
primary key(coverageId),
foreign key (coverageGroupCode) references coverageGroup(groupCode)
)


create table vehicleCoverage (
Id char(3),
vehicleId char(5),
coverageId char(3),
createDate date,
active bit,
primary key(Id),
foreign key (vehicleId) references vehicle(vehicleId),
foreign key (coverageId) references coverage(coverageId)
)




create table policy_coverage (
policyNumber varchar (20),
coverageId char(3),
createDate date,
active bit,

foreign key (policyNumber) references policy(policyNumber),
foreign key (coverageId) references coverage(coverageId)

);

create table state(
stateId char(5),
stateName varchar(20),
primary key (stateId)
)

create table city(
cityId char(30),
cityName varchar(20),
stateId char(5)
primary key (cityId),
foreign key (stateId) references state(stateId)
)

create table location(
	x numeric(4,4),
	y numeric(4,4),
	street varchar(15),
	cityId char(30),
	primary key(x, y),
	foreign key(cityID) references city (cityId)
);


create table driverAddress (
driveraddressId char(5),
driverId char(5),
address varchar (50),
cityCode char(30),
zipCode varchar(20),
isItGarageAddress bit,
primary key (driveraddressId),
foreign key(driverId) references driver(driverId),
foreign key(cityCode) references city(cityID)
)

	

create table branch(
branchId char(5),
cityId char(30),
address varchar(50),
level int,
primary key (branchId),
foreign key (cityID) references city(cityID)

)

create table employee(
personalCode char(10),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
cityId char(30),
address varchar(50),
phoneNumber char(30),
emailAddress varchar(20),
branchId char (5),
hireDate date,
primary key (personalCode),
foreign key (cityId) references city(cityId),
foreign key (branchId) references branch(branchId)
)



create table branch_boss (
BossId char(5),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
cityId char(30),
address varchar(50),
phoneNumber char(30),
--personalCode char(10),
branchId char(5),
DateBcomeManager date,
primary key (BossId),
--foreign key (personalCode) references employee(personalCode),
foreign key (branchId) references branch(branchId)
)

create table branch_expert (
expertId char(5),
--personalCode char(10),
branchId char(5),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
cityId char(30),
address varchar(50),
hireDate date,
phoneNumber char(30),
Specialty varchar(30),
primary key (expertId),
--foreign key (personalCode) references employee(personalCode),
foreign key (branchId) references branch(branchId)
)

create table branch_broker (
brokerId char(5),
--personalCode char(10),
branchId char(5),
PPR int , --Percentage of profit received
Specialty varchar(30),
primary key (brokerId),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
cityId char(30),
address varchar(50),
hireDate date,
phoneNumber char(30),
--foreign key (personalCode) references employee(personalCode),
foreign key (branchId) references branch(branchId)
)


create table accidentStatus(
	accidentStatusCode char(2) primary key,
	accidentStat varchar(15),
	additionalInfo varchar(100)
);

create table vehiclePart(
	partId char(4) primary key,
	partName varchar(50),
	originalPrice numeric(5,2),
	additionalInfo varchar(100)
);




create table accident(
	vehicleId char(5),
	expertId char(5),
	happenTime date,
	coordinateX numeric(4,4),
	coordinateY numeric(4,4),
	totalFine numeric(7,2),
	payByInsurance numeric(7,2),
	accidentStatusCode char(2),
	driverId char(5),
	primary key(happenTime, coordinateX, coordinateY),
	foreign key(accidentStatusCode) references accidentStatus(accidentStatusCode),
	foreign key(expertId) references branch_expert(expertId),
	foreign key(vehicleId) references vehicle(vehicleId),
	foreign key(coordinateX, coordinateY) references location(x, y),
	foreign key(driverId) references driver(driverId)
);

create table accidentVehiclePart(
	partId char(4),
	happenTime date,
	coordinateX numeric(4,4),
	coordinateY numeric(4,4),
	damageCost numeric(6,2),
	foreign key (happenTime, coordinateX, coordinateY) references 
		accident(happenTime, coordinateX, coordinateY),
	foreign key(partId) references vehiclePart(partId)
);




create table salaryEmployee (
personalCode char(10),
branchId char(5),
amount int,
from_date date,
to_date date,
foreign key (personalCode) references employee(personalCode)
)


create table salaryBoss (
BossId char(5),
branchId char(5),
amount int,
from_date date,
to_date date,
foreign key (BossId) references branch_boss(BossId)
)


create table salaryExpert (
expertId char(5),
branchId char(5),
amount int,
from_date date,
to_date date,
foreign key (expertId) references branch_expert(expertId)
)


create table salaryBroker (
brokerId char(5),
branchId char(5),
amount int,
from_date date,
to_date date,
foreign key (brokerId) references branch_broker(brokerId)
)



create table attract_Customer (
driverId char(5),
brokerId char(5),
--branchId char(5),
description varchar(30), -- noe bima
contract_cost int,
startDateContract date,
endDateContract date,
createDate date,
foreign key (driverId) references driver(driverId),
foreign key (brokerId) references branch_broker(brokerId),
--foreign key (branchId) references branch(branchId)
)
create table accident_cost_by_expert (
latitude numeric(4,4) NOT NULL,
longitude numeric(4,4) NOT NULL,
happenDate DATE NOT NULL,
--branchId char (5),
expertId char (5),
factorNumber char(10),
amount int,
registrationDate date,
foreign key (expertId) references branch_expert(expertId),
foreign key (happenDate,longitude,latitude) references accident(happenTime, coordinateX, coordinateY)
--foreign key (branchId) references branch(branchId),
)

SELECT * from city

CREATE TABLE statusDamage (
	id CHAR(2) PRIMARY key,
	description VARCHAR(50) NOT NULL
)

CREATE TABLE thirdPartyAccident (
	driverId CHAR(5) NOT NULL,
	vehicleId CHAR(5) NOT NULL,
	latitude numeric(4,4) NOT NULL,
	longitude numeric(4,4) NOT NULL,
	happenDate DATE NOT NULL,
	happenTime TIME NOT NULL,
	trafficViolationCode CHAR(3) NOT NULL,
	statusDamageCode CHAR(2) NOT NULL,
	PRIMARY KEY(latitude, longitude, happenDate, happenTime),
	
	FOREIGN KEY (driverId) REFERENCES driver(driverId),
	FOREIGN KEY (vehicleId) REFERENCES vehicle(vehicleId),
	FOREIGN KEY(latitude, longitude) REFERENCES location(x, y),
	FOREIGN KEY (trafficViolationCode) REFERENCES trafficViolationCode(trafficViolationCodeId),
	FOREIGN KEY (statusDamageCode) REFERENCES statusDamage(id)
)


CREATE TABLE insurancePaymentToPerson(
	amount INT NOT NULL,
	loserNationalCode VARCHAR(10) NOT NULL,
	latitude numeric(4,4) NOT NULL,
	longitude numeric(4,4) NOT NULL,
	happenDate DATE NOT NULL,
	happenTime TIME NOT NULL,
	paymnetDate DATE NOT NULL,
	paymentTime TIME NOT NULL,
	PRIMARY KEY(latitude, longitude, happenDate, happenTime),
	
	FOREIGN KEY(latitude, longitude,  happenDate, happenTime) REFERENCES thirdPartyAccident(latitude, longitude, happenDate, happenTime),
)

CREATE TABLE insurancePaymentToPersonDetail (
	fromAccountNumber VARCHAR(13),
	fromCardNumber VARCHAR(16),
	fromBankName VARCHAR(20),
	toAccountNumber VARCHAR(13),
	toCardNumber VARCHAR(16),
	toBankName VARCHAR(20),
	routingNumber VARCHAR(20),
	checkNumber VARCHAR(20),
	latitude numeric(4,4),
	longitude numeric(4,4),
	happenDate DATE,
	happenTime TIME,
	PRIMARY KEY(latitude, longitude,  happenDate, happenTime),
	
	FOREIGN KEY(latitude, longitude,  happenDate, happenTime) REFERENCES insurancePaymentToPerson(latitude, longitude,  happenDate, happenTime)
)