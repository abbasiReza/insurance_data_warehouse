

CREATE table SA_state(
stateId char(5),
stateName varchar(20),
primary key (stateId)
)

create table SA_city(
cityId char(30),
cityName varchar(20),
stateId char(5)
primary key (cityId),
foreign key (stateId) references SA_state(stateId)on delete cascade
)


create table SA_branch(
branchId char(5),
cityId char(30),
address varchar(50),
level int,
primary key (branchId),
foreign key (cityID) references SA_city(cityID)on delete cascade

)

create table SA_branch_boss (
BossId char(5),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
emailAddress varchar(20),
cityId char(30),
address varchar(50),
phoneNumber char(30),
branchId char(5),
DateBcomeManager date,
primary key (BossId),
foreign key (branchId) references SA_branch(branchId)on delete cascade
)



create table SA_location(
	x numeric(4,4),
	y numeric(4,4),
	street varchar(15),
	cityId char(30),
	primary key(x, y),
	foreign key(cityID) references SA_city (cityId)on delete cascade
);


create table SA_martial(
	statusCode char(3) primary key,
	statusName char(20),
	explaintion varchar(100)
);


create table SA_gender(
	genderCode char(3) primary key,
	genderName varchar(20)
);
create table SA_driver (
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
nationalCode varchar(12),
licenseId char(5),
licenseIssuedDate date,
licenseNumber varchar(20),
isPrimaryPolicyHolder bit,
relationWithPrimaryPolicyHolder varchar(10),
genderCode char (3),
martialStatusCode char(3),
createdDate date,
active bit,
primary key(driverId),
foreign key(genderCode) references SA_gender(genderCode)on delete cascade,
foreign key(martialStatusCode) references SA_martial(statusCode)on delete cascade
);

create table SA_driverAddress (
driveraddressId char(5),
driverId char(5),
address varchar (50),
cityCode char(30),
zipCode varchar(20),
isItGarageAddress bit,
primary key (driveraddressId),
foreign key(driverId) references SA_driver(driverId)on delete cascade,
foreign key(cityCode) references SA_city(cityID)on delete cascade
)

create table SA_employee(
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
foreign key (cityId) references SA_city(cityId)on delete cascade,
foreign key (branchId) references SA_branch(branchId)on delete NO ACTION
)

create table SA_branch_expert (
expertId char(5),
--personalCode char(10),
branchId char(5),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
emailAddress varchar(20),
cityId char(30),
address varchar(50),
hireDate date,
phoneNumber char(30),
Specialty varchar(30),
primary key (expertId),
--foreign key (personalCode) references employee(personalCode),
foreign key (branchId) references SA_branch(branchId)on delete cascade
)

create table SA_policy (
policyNumber varchar(20),
policyEffectiveDate date,
policyExpireDate date,
optionCode char(3),
optionDesc varchar(100),
totalAmount int ,
active bit ,
additionalInfo varchar(100),
createDate date,
primary key(policyNumber),

);


create table SA_vehicle (
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

active bit,
primary key (vehicleId),
foreign key (policyNumber) references SA_policy(policyNumber)on delete cascade
);



create table SA_accidentStatus(
	accidentStatusCode char(2) primary key,
	accidentStat varchar(15),
	additionalInfo varchar(100)
);

create table SA_vehiclePart(
	partId char(4) primary key,
	partName varchar(50),
	originalPrice numeric(5,2),
	additionalInfo varchar(100)
);

create table SA_accident(
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
	foreign key(accidentStatusCode) references SA_accidentStatus(accidentStatusCode)on delete cascade,
	foreign key(expertId) references SA_branch_expert(expertId)on delete NO ACTION,
	foreign key(vehicleId) references SA_vehicle(vehicleId)on delete cascade,
	foreign key(coordinateX, coordinateY) references SA_location(x, y)on delete cascade,
	foreign key(driverId) references SA_driver(driverId)on delete cascade
);


	create table SA_accident_cost_by_expert (
	happenTime date,
	coordinateX numeric(4,4),
	coordinateY numeric(4,4),
	--branchId char (5),
	expertId char (5),
	factorNumber char(10),
	amount int,
	registrationDate date,
	foreign key (expertId) references SA_branch_expert(expertId)on delete NO ACTION,
	foreign key (happenTime, coordinateX, coordinateY) references SA_accident(happenTime, coordinateX, coordinateY)on delete cascade
	--foreign key (branchId) references branch(branchId),
	)


	create table SA_branch_broker (
brokerId char(5),

branchId char(5),
PPR int , --Percentage of profit received
Specialty varchar(30),

firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
cityId char(30),
address varchar(50),
hireDate date,
phoneNumber char(30),

primary key (brokerId),
foreign key (branchId) references SA_branch(branchId)on delete cascade
)

create table SA_salaryEmployee (
personalCode char(10),
branchId char(5),
amount int,
from_date date,
to_date date,
foreign key (personalCode) references SA_employee(personalCode)on delete cascade
)


create table SA_salaryBoss (
BossId char(5),
branchId char(5),
amount int,
from_date date,
to_date date,
foreign key (BossId) references SA_branch_boss(BossId)on delete cascade
)



create table SA_salaryExpert (
expertId char(5),
branchId char(5),
amount int,
from_date date,
to_date date,
foreign key (expertId) references SA_branch_expert(expertId)on delete cascade
)


create table SA_salaryBroker (
brokerId char(5),
branchId char(5),
amount int,
from_date date,
to_date date,
foreign key (brokerId) references SA_branch_broker(brokerId)on delete cascade
)


create table SA_attract_Customer (
driverId char(5),
brokerId char(5),
--branchId char(5),
description varchar(30), -- noe bima
contract_cost int,
startDateContract date,
endDateContract date,
createDate date,
foreign key (driverId) references SA_driver(driverId)on delete cascade,
foreign key (brokerId) references SA_branch_broker(brokerId)on delete cascade
--foreign key (branchId) references branch(branchId)
)









create table SA_policyEditlogTable (
policyEditLogId char(3),
policy_Id   char(3),
editedTableName varchar(50),
editedDate date,
editedBy varchar(50),
additionalInfo varchar(100),
primary key(policyEditLogId)
);

create table SA_bill(
billId char(3),
policyNumber varchar(20),
dueDate date,
minimumPayment int,
createDate date,
balance int,
statusCode char(2),
	statusName varchar(20),
primary key (billId),

foreign key(policyNumber) references SA_policy(policyNumber)on delete cascade
);


create table SA_paymentMethod(
	paymentMethodCode char(3) primary key,
	paymentMethodDesc varchar(100),
	additionalInfo varchar(500)
);

create table SA_payment (
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
foreign key (billId) references SA_bill(billId)on delete cascade,
foreign key (paymentMethodCode) references SA_paymentMethod(paymentMethodCode)on delete cascade
);








create table SA_trafficViolationCode (
trafficViolationCodeId char(3),
trafficViolationQuestion varchar(100),
codeDescription varchar(100),
point int,
primary key (trafficViolationCodeId)
);




create table SA_driver_trafficViolation_record (
Id char(5),
driverId char(5),
trafficViolationCodeId char(3),
active bit
primary key (Id),
foreign key(driverId) references SA_driver(driverId)on delete cascade,
foreign key (trafficViolationCodeId) references SA_trafficViolationCode (trafficViolationCodeId)on delete cascade
)




create table SA_vehicle_driver (
Id char (3),
vehicleId char(5),
driverId char(5),
driverForBussiness bit,
isPrimaryDriver bit,
everyDayMileage int,
createdDate date,
active bit,
primary key(Id),
foreign key (vehicleId) references SA_vehicle(vehicleId)on delete cascade,
foreign key (driverId) references SA_driver (driverId)on delete cascade
)

create table SA_coverageGroup(
	groupCode char(3) primary key,
	groupName varchar(20),
	Explaintion varchar(100),
	isPersonCoverage bit,
	isVehicleCoverage bit
);
create table SA_coverage (
coverageId char(3),
coverageName varchar (20),
coverageGroupCode char(3),
code varchar(20),
primary key(coverageId),
foreign key (coverageGroupCode) references SA_coverageGroup(groupCode)on delete cascade
)


create table SA_vehicleCoverage (
Id char(3),
vehicleId char(5),
coverageId char(3),
createDate date,
active bit,
primary key(Id),
foreign key (vehicleId) references SA_vehicle(vehicleId)on delete cascade,
foreign key (coverageId) references SA_coverage(coverageId)on delete cascade
)




create table SA_policy_coverage (
policyNumber varchar (20),
coverageId char(3),
createDate date,
active bit,

foreign key (policyNumber) references SA_policy(policyNumber)on delete cascade,
foreign key (coverageId) references SA_coverage(coverageId)on delete cascade

);



create table SA_accidentVehiclePart(
	partId char(4),
	happenTime date,
	coordinateX numeric(4,4),
	coordinateY numeric(4,4),
	damageCost numeric(6,2),
	foreign key (happenTime, coordinateX, coordinateY) references SA_accident(happenTime, coordinateX, coordinateY) on delete cascade,
	foreign key(partId) references SA_vehiclePart(partId)on delete cascade
);







create table SA_statusDamage (
	id CHAR(2) PRIMARY key,
	description VARCHAR(50) NOT NULL
)

create table SA_thirdPartyAccident (
	driverId CHAR(5) NOT NULL,
	vehicleId CHAR(5) NOT NULL,
	latitude numeric(4,4) NOT NULL,
	longitude numeric(4,4) NOT NULL,
	happenDate DATE NOT NULL,
	happenTime TIME NOT NULL,
	trafficViolationCode CHAR(3) NOT NULL,
	statusDamageCode CHAR(2) NOT NULL,
	PRIMARY KEY(latitude, longitude, happenDate, happenTime),
	
	FOREIGN KEY (driverId) references SA_driver(driverId)on delete cascade,
	FOREIGN KEY (vehicleId) references SA_vehicle(vehicleId)on delete cascade,
	FOREIGN KEY(latitude, longitude) references SA_location(x, y)on delete cascade,
	FOREIGN KEY (trafficViolationCode) references SA_trafficViolationCode(trafficViolationCodeId)on delete cascade,
	FOREIGN KEY (statusDamageCode) references SA_statusDamage(id)on delete cascade
)


create table SA_insurancePaymentToPerson(
	amount INT NOT NULL,
	loserNationalCode VARCHAR(10) NOT NULL,
	latitude numeric(4,4) NOT NULL,
	longitude numeric(4,4) NOT NULL,
	happenDate DATE NOT NULL,
	happenTime TIME NOT NULL,
	paymnetDate DATE NOT NULL,
	paymentTime TIME NOT NULL,
	PRIMARY KEY(latitude, longitude, happenDate, happenTime),
	
	FOREIGN KEY(latitude, longitude,  happenDate, happenTime) references SA_thirdPartyAccident(latitude, longitude, happenDate, happenTime)on delete cascade
)

create table SA_insurancePaymentToPersonDetail (
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
	
	FOREIGN KEY(latitude, longitude,  happenDate, happenTime) references SA_insurancePaymentToPerson(latitude, longitude,  happenDate, happenTime)on delete cascade
)

CREATE TABLE  [SA_Bill](
	[billId] [char](3) NOT NULL,
	[policyNumber] [varchar](20) NULL,
	[dueDate] [date] NULL,
	[minimumPayment] [int] NULL,
	[createDate] [date] NULL,
	[balance] [int] NULL
	
	foreign key (policyNumber) references SA_Policy(policyNumber)
)

CREATE TABLE  [SA_Coverage](
	[coverageId] [char](3) NOT NULL,
	[coverageName] [varchar](20) NULL,
	[coverageGroupCode] [char](3) NULL,
	[code] [varchar](20) NULL
	
	foreign key (coverageGroupCode) references SA_CoverageGroup(groupCode)
)

CREATE TABLE  [SA_CoverageGroup](
	[groupCode] [char](3) NOT NULL,
	[groupName] [varchar](20) NULL,
	[Explaintion] [varchar](100) NULL,
	[isPersonCoverage] [bit] NULL,
	[isVehicleCoverage] [bit] NULL
)

CREATE TABLE  [SA_InsurancePaymentToPerson](
	[amount] [int] NOT NULL,
	[loserNationalCode] [varchar](10) NOT NULL,
	[latitude] [numeric](4, 4) NOT NULL,
	[longitude] [numeric](4, 4) NOT NULL,
	[happenDate] [date] NOT NULL,
	[happenTime] [time](7) NOT NULL,
	[paymnetDate] [date] NOT NULL,
	[paymentTime] [time](7) NOT NULL
	
	foreign key (latitude) references SA_ThirdPartyAccident(latitude),
	foreign key (longitude) references SA_ThirdPartyAccident(longitude),
	foreign key (happenDate) references SA_ThirdPartyAccident(happenDate),
	foreign key (happenTime) references SA_ThirdPartyAccident(happenTime)
)

CREATE TABLE  [SA_Payment](
	[paymentId] [char](3) NOT NULL,
	[billId] [char](3) NULL,
	[paidDate] [date] NULL,
	[paidTime] [time](7) NULL,
	[amount] [int] NULL,
	[payerFirstName] [varchar](50) NULL,
	[payerLastName] [varchar](50) NULL,
	[cardNumber] [varchar](50) NULL,
	[zipcode] [varchar](10) NULL,
	[cardExpireDate] [date] NULL,
	[cardType] [varchar](20) NULL,
	[debitOrCredit] [varchar](50) NULL,
	[bankName] [varchar](100) NULL,
	[AccountNNumber] [varchar](20) NULL,
	[addtionalInfo] [varchar](100) NULL,
	[createDate] [date] NULL
	
	foreign key (billId) references SA_ThirdPartyAccident(billId)
)







CREATE TABLE  [SA_PolicyCoverage](
	[policyNumber] [varchar](20) NULL,
	[coverageId] [char](3) NULL,
	[createDate] [date] NULL,
	[active] [bit] NULL
	
	foreign key (policyNumber) references SA_Policy(policyNumber),
	foreign key (coverageId) references SA_Policy(coverageId)
)

CREATE TABLE  [SA_ThirdPartyAccident](
	[driverId] [char](5) NOT NULL,
	[vehicleId] [char](5) NOT NULL,
	[latitude] [numeric](4, 4) NOT NULL,
	[longitude] [numeric](4, 4) NOT NULL,
	[happenDate] [date] NOT NULL,
	[happenTime] [time](7) NOT NULL,
	[trafficViolationCode] [char](3) NOT NULL
	
	foreign key (driverId) references SA_driver(driverId),
	foreign key (vehicleId) references SA_Vehicle(vehicleId),
	foreign key (latitude) references SA_location(y)
	foreign key (longitude) references SA_location(x)
)

CREATE TABLE  [SA_TrafficViolationCode](
	[trafficViolationCodeId] [char](3) NOT NULL,
	[trafficViolationQuestion] [varchar](100) NULL,
	[codeDescription] [varchar](100) NULL,
	[point] [int] NULL
)

CREATE TABLE  [SA_Vehicle](
	[vehicleId] [char](5) NOT NULL,
	[policyNumber] [varchar](20) NULL,
	[year] [char](4) NULL,
	[make] [varchar](50) NULL,
	[model] [varchar](50) NULL,
	[trim] [varchar](50) NULL,
	[mileage] [int] NULL,
	[vinNumber] [varchar](20) NULL,
	[vehicleNumberPlate] [varchar](20) NULL,
	[vehicleRegisteredState] [varchar](50) NULL,
	[active] [bit] NULL
	
	foreign key (policyNumber) references SA_Policy(policyNumber)
)

CREATE TABLE  [SA_VehicleCoverage](
	[vehicleId] [char](5) NULL,
	[coverageId] [char](3) NULL,
	[createDate] [date] NULL,
	[active] [bit] NULL
	
	foreign key (vehicleId) references SA_Vehicle(vehicleId),
	foreign key (coverageId) references SA_Coverage(coverageId)
)

CREATE TABLE  [SA_VehicleDriver](
	[vehicleId] [char](5) NULL,
	[driverId] [char](5) NULL,
	[driverForBussiness] [bit] NULL,
	[isPrimaryDriver] [bit] NULL,
	[everyDayMileage] [int] NULL,
	[createdDate] [date] NULL,
	[active] [bit] NULL
	
	foreign key (vehicleId) references SA_Vehicle(vehicleId),
	foreign key (driverId) references SA_driver(driverId)
)














