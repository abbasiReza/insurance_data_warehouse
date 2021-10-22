
DROP TABLE dimBoss
create table dimBoss (
BossId char(10),
firstName varchar(30),
lastName varchar(30),
nationalCode char(20),
emailAddress varchar(30),
phoneNumber varchar(30),
primary key (BossId)
)

drop TABLE dimBrokers
create table dimBrokers (
surKeyBroker int identity(1,1),
brokerId char(10),
firstName varchar(30),
lastName varchar(30),
nationalCode char(20),
emailAddress varchar(30),
phoneNumber varchar(30),
PPR int , --Percentage of profit received
startDate date,
endDate date,
currentFlag bit,
primary key (surKeyBroker)
);


create table dimDriver (
drvierSurKey int IDENTITY(1,1),
driverId char(10),
firstName varchar(50),
lastName varchar(50),
emailAddress varchar(30),
phoneNumber varchar(30),
cellNumber varchar(20),
nationalCode varchar(20),
licenseIssuedDate date,
licenseNumber varchar(20),
isPrimaryPolicyHolder bit,
relationWithPrimaryPolicyHolder varchar(20),
gender varchar (10),
address varchar (70),
cityId char(30),
cityName varchar(20),
stateId char(30),
stateName varchar(20),
zipCode varchar(30),
start_date date,
end_date date,
currentFlag bit,
primary key (driverId)
)

create table dimEmployee(
personalCode char(10),
firstName varchar(30),
lastName varchar(30),
nationalCode char(20),
emailAddress varchar(30),
phoneNumber varchar(30),
primary key (personalCode)
);


create table dimExperts (

expertId char(10),
firstName varchar(30),
lastName varchar(30),
nationalCode char(20),
emailAddress varchar(30),
phoneNumber varchar(30),
Specialty varchar(50),
primary key (expertId)
)

create table dimLocationBranch (
branchId char(10),
address varchar(70),
cityID char(30),
cityName varchar(30),
stateCode char(30),
stateName varchar(30),
level3 bit,
level2 bit,
level2Date date,
level1 bit,
level1Date date,
primary key (branchId)
)


create table dimVehicle (
	vehicleId char(5) primary key,
	year char(4),
	make varchar(50),
	model varchar(50),
	type varchar(50),
	mileage int,
	vinNumber varchar(20),
	vehicleNumberPlate varchar(20)
);

create table dimPolicy(
	policyNumber varchar(20),
	policyEffectiveDate date,
	policyExpireDate date,
	paymentOption1 varchar(100),
	effectiveDate1 date,
	paymentOption2 varchar(100),
	effectiveDate2 date,
	paymentOption3 varchar(100),
	totalAmount int ,
	active bit ,
	--additionalInfo varchar(100),
	createDate date,
	--coverageId char(3),
	--coverageName varchar (20),
	--civerageGroup varchar (50),
	--code varchar(20),
	primary key (policyNumber)
);


CREATE TABLE	dimDate
(	
--[DateKey] INT primary key, 
	[Date] DATETIME primary key,
	--[FullDateUK] CHAR(10), -- Date in dd-MM-yyyy format
	--[FullDateUSA] CHAR(10),-- Date in MM-dd-yyyy format
	[DayOfMonth] VARCHAR(2), -- Field will hold day number of Month
	[DaySuffix] VARCHAR(4), -- Apply suffix as 1st, 2nd ,3rd etc
	[DayName] VARCHAR(9), -- Contains name of the day, Sunday, Monday 
	--[DayOfWeekUSA] CHAR(1),-- First Day Sunday=1 and Saturday=7
	--[DayOfWeekUK] CHAR(1),-- First Day Monday=1 and Sunday=7
	[DayOfWeekInMonth] VARCHAR(2), --1st Monday or 2nd Monday in Month
	[DayOfWeekInYear] VARCHAR(2),
	[DayOfQuarter] VARCHAR(3),
	[DayOfYear] VARCHAR(3),
	[WeekOfMonth] VARCHAR(1),-- Week Number of Month 
	[WeekOfQuarter] VARCHAR(2), --Week Number of the Quarter
	[WeekOfYear] VARCHAR(2),--Week Number of the Year
	[Month] VARCHAR(2), --Number of the Month 1 to 12
	[MonthName] VARCHAR(9),--January, February etc
	[MonthOfQuarter] VARCHAR(2),-- Month Number belongs to Quarter
	[Quarter] CHAR(1),
	[QuarterName] VARCHAR(9),--First,Second..
	[Year] CHAR(4),-- Year value of Date stored in Row
	[YearName] CHAR(7), --CY 2012,CY 2013
	[MonthYear] CHAR(10), --Jan-2013,Feb-2013
	--[MMYYYY] CHAR(6),
	--[FirstDayOfMonth] DATE,
	--[LastDayOfMonth] DATE,
	--[FirstDayOfQuarter] DATE,
	--[LastDayOfQuarter] DATE,
	--[FirstDayOfYear] DATE,
	--[LastDayOfYear] DATE,
	--[IsHolidayUSA] BIT,-- Flag 1=National Holiday, 0-No National Holiday
	--[IsWeekday] BIT,-- 0=Week End ,1=Week Day
	--[HolidayUSA] VARCHAR(50),--Name of Holiday in US
	--[IsHolidayUK] BIT Null,-- Flag 1=National Holiday, 0-No National Holiday
	--[HolidayUK] VARCHAR(50) Null --Name of Holiday in UK
);


CREATE TABLE dimTime
     ([TimeKey]        TIME     NOT NULL
    , [Hour12]         TINYINT  NOT NULL
    , [Hour24]         TINYINT  NOT NULL
    , [MinuteOfHour]   TINYINT  NOT NULL
    , [SecondOfMinute] TINYINT  NOT NULL
    , [ElapsedMinutes] SMALLINT NOT NULL
    , [ElapsedSeconds] INT      NOT NULL
    , [AMPM]           CHAR(2)  NOT NULL
    , [HHMMSS]         CHAR(8)  NOT NULL
    , CONSTRAINT [pk_dimtime] PRIMARY KEY CLUSTERED ([TimeKey])
);

CREATE TABLE dimDate(
  dateKey BIGINT PRIMARY KEY,
  quarter INT,
  year INT,
  month INT,
  day INT,
  date DATE
);

create table dimVehiclePart(
	vehiclePartSurregateKey int identity(1,1),
	partId char(4) primary key,
	partName varchar(50),
	startdate date,
	originalPrice numeric(7,2),
	enddate date,
	currentFlag bit,
	version varchar(10),
);


create table dimCityLocation(
	stateCode varchar(30) ,
	stateName varchar(20),
	cityCode varchar(30),
	cityName varchar(20),
	primary key(cityCode)
);

CREATE TABLE  [dimCoverage](
	[coverageId] [char](5) NOT NULL,
	[coverageName] [varchar](25) NULL,
	[coverageGroupCode] [char](5) NULL,
	[groupName] [varchar](25) NULL,
	[Explaintion] [varchar](110) NULL,
	[isPersonCoverage] [bit] NULL,
	[isVehicleCoverage] [bit] NULL,
	[code] [varchar](25) NULL
)

CREATE TABLE  [dimTrafficViolationCode](
	[surregateKey] [int] NOT NULL,
	[trafficViolationCodeId] [char](6) NOT NULL,
	[trafficViolationQuestion] [varchar](120) NULL,
	[codeDescription] [varchar](120) NULL,
	[startDate] [date] NULL,
	[endDate] [date] NULL,
	[currentFlag] [bit] NULL,
	[point] [int] NULL
)