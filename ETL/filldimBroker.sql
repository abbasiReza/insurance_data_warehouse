


create table dimBrokerTemp
(
surregateKey bigint primary key identity(1,1),
brokerId char(5),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
emailAddress varchar(20),
phoneNumber char(10),
PPR int , --Percentage of profit received,
startDate date,
endDate date,
currentFlag bit

);


create table dimBrokerLastInfo(
surKeyBroker bigint,
brokerId char(5),
--personalCode char(10),
firstName varchar(20),
lastName varchar(20),
nationalCode char(10),
emailAddress varchar(20),
phoneNumber varchar(13),
--hireDate date,
--branchId char(5),
PPR int , --Percentage of profit received
startDate date,
endDate date,
currentFlag bit,

)



create procedure dimBrokerSD2
as
begin

	if exists(select * from dimBrokerTemp) and
		not exists(select * from dimBrokers)
		return -1;

		truncate table dimBrokerTemp;
		truncate table dimBrokerLastInfo;

		insert into dimBrokerLastInfo
		select db.surKeyBroker,db.brokerId,db.firstName,db.lastName,db.nationalCode,db.emailAddress,db.phoneNumber,db.PPR,db.startDate,db.endDate,db.currentFlag
		from dimBrokers db

		set IDENTITY_INSERT dimBrokerTemp on;

		insert into dimBrokerTemp (surregateKey,brokerId,firstName,lastName,nationalCode,emailAddress,phoneNumber,PPR,startDate,endDate,currentFlag)
		select dl.surKeyBroker,dl.brokerId,dl.firstName,dl.lastName,dl.nationalCode,dl.emailAddress,dl.phoneNumber,dl.PPR,dl.startDate,dl.endDate,dl.currentFlag
		from dimBrokerLastInfo dl
		where dl.currentFlag=0



		insert into dimBrokerTemp (surregateKey,brokerId,firstName,lastName,nationalCode,emailAddress,phoneNumber,PPR,startDate,endDate,currentFlag)
		select dl.surKeyBroker,dl.brokerId,dl.firstName,dl.lastName,dl.nationalCode,dl.emailAddress,dl.phoneNumber,dl.PPR,dl.startDate,dl.endDate,dl.currentFlag
		from dimBrokerLastInfo dl left outer join SA_branch_broker bb on dl.brokerId=bb.brokerId
		where (bb.brokerId is null and dl.currentFlag=1) or (bb.PPR=dl.PPR and dl.currentFlag=1)


		insert into dimBrokerTemp (surregateKey,brokerId,firstName,lastName,nationalCode,emailAddress,phoneNumber,PPR,startDate,endDate,currentFlag)
		select dl.surKeyBroker,dl.brokerId,dl.firstName,dl.lastName,dl.nationalCode,dl.emailAddress,dl.phoneNumber,dl.PPR,dl.startDate,GETDATE() as endDate,0 as currentFlag
		from dimBrokerLastInfo dl inner join SA_branch_broker bb on dl.brokerId=bb.brokerId
		where dl.PPR != bb.PPR and dl.currentFlag=1
		
		set IDENTITY_INSERT dimBrokerTemp off;

		insert into dimBrokerTemp (brokerId,firstName,lastName,nationalCode,emailAddress,phoneNumber,PPR,startDate,endDate,currentFlag)
		select dl.brokerId,dl.firstName,dl.lastName,dl.nationalCode,dl.emailAddress,dl.phoneNumber,bb.PPR,GETDATE() as startDate,null as endDate,1 as currentFlag
		from dimBrokerLastInfo dl inner join SA_branch_broker bb on dl.brokerId=bb.brokerId
		where dl.PPR != bb.PPR and dl.currentFlag=1

		insert into dimBrokerTemp (surregateKey,brokerId,firstName,lastName,nationalCode,emailAddress,phoneNumber,PPR,startDate,endDate,currentFlag)
		select bb.brokerId,bb.firstName,bb.lastName,bb.nationalCode,bb.emailAddress,bb.phoneNumber,bb.PPR,GETDATE() as startDate,null as endDate,1 as currentFlag
		from dimBrokerLastInfo dl inner join SA_branch_broker bb on dl.brokerId=bb.brokerId
		where dl.brokerId is null

		truncate table dimBrokers;

		set IDENTITY_INSERT dimBrokers on;

		insert into dimBrokers(surKeyBroker,brokerId,firstName,lastName,nationalCode,emailAddress,phoneNumber,PPR,startDate,endDate,currentFlag)
		select db.surregateKey,db.brokerId,db.firstName,db.lastName,db.nationalCode,db.emailAddress,db.phoneNumber,db.phoneNumber,db.PPR,db.startDate,db.endDate,db.currentFlag
		from dimBrokerTemp db

		set IDENTITY_INSERT dimBrokers off;

		truncate table dimBrokerLastInfo
		truncate table dimBrokerTemp
		




end