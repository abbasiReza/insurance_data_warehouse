
CREATE procedure  [fillDimCoverage]
as
begin
	
	if exists(select * from tempDimCoverage) and not exists(select * from dimCoverage)
		return -1;

	truncate table tempDimCoverage
	insert into tempDimCoverage
		select coverageId, coverageName, coverageGroupCode, groupName, Explaintion, isPersonCoverage, isVehicleCoverage, code
		from dimCoverage

	truncate table sourceDimCoverage
	insert into sourceDimCoverage
		select coverageId, coverageName, coverageGroupCode, groupName, Explaintion, isPersonCoverage, isVehicleCoverage, code
		from SA_Coverage as t1 inner join SA_CoverageGroup as t2 on t1.coverageGroupCode = t2.groupCode
	
	truncate table dimCoverage
	insert into dimCoverage
		select isnull(t1.coverageId, t2.coverageId), isnull(t1.coverageName, t1.coverageName),
		 isnull(t1.coverageGroupCode, t2.coverageGroupCode), isnull(t1.groupName, t2.groupName),
		  isnull(t1.Explaintion, t2.Explaintion), isnull(t1.isPersonCoverage, t2.isPersonCoverage), 
		  isnull(t1.isVehicleCoverage, t2.isVehicleCoverage), isnull(t1.code, t2.code)
		from sourceDimCoverage as t1 full outer join tempDimCoverage as t2 on t1.coverageId = t2.coverageId  
end

