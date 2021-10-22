create table factTransactionAccident (

expertId char(5),
branchId char(5),
latitude numeric(4,4),
longitude numeric(4,4),
drvierSurKey char(5),
date datetime,
cost int,
--foreign key (expertId) references dimExperts(expertId),
--foreign key (branchId) references dimLocationBranch (branchId),
--foreign key (driverId) references dimDriver (driverId),
--foreign key (date) references dimDate (date),
--foreign key (latitude, longitude) references dimLocation(latitude, longitude),
--foreign key (time) references dimTime(TimeKey)
)


create table factTransactionBrokerBenefit(
branchId char(5),
SurKeybroker int,
drvierSurKey char(5),
policyNumber varchar(20),
createDate dateTime,
totalCost int,
Profits_earned int
--foreign key (branchId) references dimLocationBranch (branchId),
--foreign key (brokerId) references dimBrokers (surKeyBroker),
--foreign key (driverId) references dimDriver (driverId),
--foreign key (policyNumber) references dimPolicy (policyNumber),
--foreign key (createDate) references dimDate (Date) 
)


create table factSnapshotBrokerBenefit (
branchId char(5),
brokerSurKey int,

createDate dateTime,
totalCost int,
totalContract int,

Profits_earned int,
--foreign key (branchId) references dimLocationBranch (branchId),
--foreign key (brokerSurKey) references dimBrokers (surKeyBroker),
--foreign key (driverId) references dimDriver (driverId),
--foreign key (policyNumber) references dimPolicy (policyNumber),
--foreign key (createDate) references dimDate (Date) 
)



create table factSnapshotSalary (
ID char(10),
branchId char (5),
amount int,
fromDate dateTime,
toDate dateTime,
payDate dateTime,
NumberOfMonthPaied int,
--foreign key (ID) references dimEmployee(personalCode),
--foreign key (branchId) references dimLocationBranch (branchId),
--foreign key (fromDate) references dimDate (Date),
--foreign key (toDate) references dimDate (Date),
--foreign key (payDate) references dimDate (Date)
)


create table fact_acc_BrokerBenefit (
branchId char(5),
brokerSurKey int,
countContract int,
totalCost int,
profits_earned int,
--foreign key (branchId) references dimLocationBranch (branchId),
--foreign key (brokerSurKey) references dimBrokers (surKeyBroker),
)






create table transactionFactOverPart(
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


create table snapshotFactOverDriver(
	driverId char(5),
	cityCode char(4),
	date datetime,
	timeKey time,
	countOfAccident int,
	payByInsurance numeric(7,2)
	
);


create table accFactOverDriverAndVehicle(
	lastTimeAccident datetime,
	driverId char(5),
	vehicleId char(5),
	totalPayByInsurance numeric(7,2),
	totalAccident int
);




CREATE TABLE  [factAccInsuranceToPerson](
	[amount] [int] NOT NULL,
	[coverageId] [char](5) NOT NULL,
	[driverId] [char](10) NOT NULL,
	[vehicleId] [char](10) NOT NULL
)

CREATE TABLE  [factAccPersonToInsurance](
	[amount] [int] NULL,
	[balance] [int] NULL,
	[policyNumber] [varchar](25) NULL,
	[coverageId] [char](5) NULL,
	[driverId] [char](8) NULL
)

CREATE TABLE  [factSnapMonthInsuranceToPerson](
	[amount] [int] NOT NULL,
	[coverageId] [char](5) NOT NULL,
	[driverId] [char](10) NOT NULL,
	[vehicleId] [char](10) NOT NULL,
	[happenDate] [date] NOT NULL
)

CREATE TABLE  [factSnapMonthPersonToInsurance](
	[amount] [int] NULL,
	[balance] [int] NULL,
	[policyNumber] [varchar](25) NULL,
	[coverageId] [char](5) NULL,
	[driverId] [char](8) NULL,
	[paymentDate] [date] NULL
)

CREATE TABLE  [factTrnInsuranceToPerson](
	[amount] [int] NOT NULL,
	[policyNumber] [varchar](25) NOT NULL,
	[coverageId] [char](5) NOT NULL,
	[driverId] [char](10) NOT NULL,
	[vehicleId] [char](10) NOT NULL,
	[latitude] [numeric](6, 6) NOT NULL,
	[longitude] [numeric](6, 6) NOT NULL,
	[happenDate] [date] NOT NULL,
	[happenTime] [time](7) NOT NULL,
	[trafficViolationCode] [char](5) NOT NULL
)

CREATE TABLE  [factTrnPersonToInsurance](
	[amount] [int] NULL,
	[balance] [int] NULL,
	[policyNumber] [varchar](25) NULL,
	[coverageId] [char](5) NULL,
	[driverId] [char](8) NULL,
	[paymentDate] [date] NULL,
	[paymentTime] [time](7) NULL
)


