
create procedure  [fillDimTrafficeViolationCode]
as
begin
		if exists(select * from tempDimTrafficViolationCode) and
		not exists(select * from dimTrafficViolationCode)
		return -1;
	
	--select the existing data from dimentaion
	truncate table tempDimTrafficViolationCode;
	insert into tempDimTrafficViolationCode
	select surregateKey, trafficViolationCodeId, trafficViolationQuestion, codeDescription, startDate, endDate, currentFlag,
		point
	from dimTrafficViolationCode;

	--select old data with flag = 0
	truncate table updatedTrafficViolationCode

	set IDENTITY_INSERT updatedTrafficViolationCode on;

	insert into updatedTrafficViolationCode(surregateKey, trafficViolationCodeId, trafficViolationQuestion, codeDescription,
	 startDate, endDate, currentFlag, point)
	select surregateKey, trafficViolationCodeId, trafficViolationQuestion, codeDescription,startDate, endDate, currentFlag,
	 point
	from dimTrafficViolationCode
	where currentFlag = 0;

	--select data without change
	insert into updatedTrafficViolationCode(surregateKey, trafficViolationCodeId, trafficViolationQuestion, codeDescription,
	 startDate, endDate, currentFlag, point)
	select t1.surregateKey, t1.trafficViolationCodeId, t1.trafficViolationQuestion, t1.codeDescription, t1.startDate,
	 t1.endDate,t1.currentFlag, t1.point
	from dimTrafficViolationCode as t1 left outer join SA_TrafficViolationCode as t2
	on(t1.trafficViolationCodeId = t2.trafficViolationCodeId)
	where (t2.trafficViolationCodeId is null and t1.currentFlag = 1) or (t2.point = t1.point and t1.currentFlag = 1);

	--insert record with flag = 0 for changed data
	insert into updatedTrafficViolationCode(surregateKey, trafficViolationCodeId, trafficViolationQuestion, codeDescription,
	 startDate, endDate, currentFlag, point)
	select t1.surregateKey, t1.trafficViolationCodeId, t1.trafficViolationQuestion, t1.codeDescription, t1.startDate,
	 GETDATE() as endDate, 0 as currentFlag, t1.point
	from dimTrafficViolationCode as t1 inner join SA_TrafficViolationCode as t2
	on(t1.trafficViolationCodeId = t2.trafficViolationCodeId)
	where t1.point != t2.point and t1.currentFlag = 1;

	set identity_insert updatedTrafficViolationCode off;
	
	--insert record with flag = 1 for changed data
	insert into updatedTrafficViolationCode
	select t1.trafficViolationCodeId, t1.trafficViolationQuestion, t1.codeDescription,
	 GETDATE() as startDate, NULL as endDate, 1 as currentFlag, t2.point
	from dimTrafficViolationCode as t1 inner join SA_TrafficViolationCode as t2
	on(t1.trafficViolationCodeId = t2.trafficViolationCodeId)
	where t1.point != t2.point and t1.currentFlag = 1;

	--select the new data
	insert into updatedTrafficViolationCode
	select t1.trafficViolationCodeId, t1.trafficViolationQuestion, t1.codeDescription,
	 GETDATE() as startDate, NULL as endDate, 1 as currentFlag, t2.point
	from dimTrafficViolationCode as t1 right outer join SA_TrafficViolationCode as t2
	on(t1.trafficViolationCodeId = t2.trafficViolationCodeId)
	where t1.trafficViolationCodeId is null
	
	truncate table dimTrafficViolationCode;

	set IDENTITY_INSERT dimTrafficViolationCode on;

	insert into dimTrafficViolationCode(surregateKey, trafficViolationCodeId, trafficViolationQuestion, codeDescription,
	 startDate, endDate, currentFlag, point)
	select t1.surregateKey, trafficViolationCodeId, trafficViolationQuestion, codeDescription, startDate, endDate, currentFlag,
	 point
	from updatedTrafficViolationCode as t1;

	set IDENTITY_INSERT dimTrafficViolationCode off;

end

