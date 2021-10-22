
create table sourceLocation (
branchId char(5),
address varchar(50),
cityID char(5),
cityName varchar(20),
stateCode char(5),
stateName varchar(20),
level bit,
primary key (branchId)
)
create table tempLocation (
branchId char(5),
address varchar(50),
cityID char(5),
cityName varchar(20),
stateCode char(5),
stateName varchar(20),
level bit,
primary key (branchId)
)

create table dimLocationBranchTemp (
branchId char(5),
address varchar(50),
cityID char(5),
cityName varchar(20),
stateCode char(5),
stateName varchar(20),
level3 bit,
level2 bit,
level2Date date,
level1 bit,
level1Date date,
primary key (branchId)
)

create table dimLocationBranchUpdated (
statusReport int,
branchId char(5),
address varchar(50),
cityID char(5),
cityName varchar(20),
stateCode char(5),
stateName varchar(20),
level3 bit,
level2 bit,
level2Date date,
level1 bit,
level1Date date,
primary key (branchId)
)

create procedure dimLocation
as
begin

if exists(select * from dimLocationBranchTemp) and
		not exists(select * from dimLocationBranch)
		return -1

		truncate table dimLocationBranchTemp;
		truncate table dimLocationBranchUpdated;
		truncate table tempLocation;
		truncate table sourceLocation;

		insert into dimLocationBranchUpdated
		select case
		    when level3 is NULL then 1
			when level2 is NULL then 2
			when level1 is NULL then 3
		   end as statusReport,
		   branchId ,address ,cityID ,cityName ,stateCode ,stateName ,level3 ,level2 ,level2Date ,level1 ,level1Date 
		   from dimLocationBranch;


		   insert into tempLocation (branchId,address,level,cityID,cityName,stateCode)
		   select b.branchId,b.address,b.level,b.cityID,c.cityName,c.stateId from SA_branch b inner join SA_city c on b.cityId=c.cityId

		   insert into sourceLocation (branchId,address,cityID,cityName,stateCode,stateName,level)
		   select t.branchId,t.address,t.cityID,t.cityName,t.stateCode,t.stateName,t.level from tempLocation t inner join SA_state s  on t.stateCode=s.stateId
		   


		   insert into dimLocationBranchTemp
		   select dbu.branchId ,dbu.address ,dbu.cityID ,dbu.cityName ,dbu.stateCode ,sl.stateName ,level3 ,level2 ,level2Date ,level1 ,level1Date 
		   from dimLocationBranchUpdated dbu left outer join sourceLocation sl on dbu.branchId=sl.branchId
		   where sl.branchId is null

		   insert into dimLocationBranchTemp
		   select dbt.branchId,dbt.address,dbt.cityID,dbt.cityName,dbt.stateCode,dbt.stateCode,
		   case
				when dbt.statusReport = 1 then sl.level
				else dbt.level3 end as level3,
			case 
				when dbt.statusReport = 2 and dbt.level3!=sl.level then GETDATE() 
				else dbt.level2Date end as  level2Date ,
			case 
				when dbt.statusReport = 2 and dbt.level3!=sl.level then sl.level 
				else dbt.level2 end as  level2Date ,
			case 
				when dbt.statusReport = 3 and dbt.level2!=sl.level then GETDATE() 
				else dbt.level1Date end as  level2Date ,
			case 
				when dbt.statusReport = 3 and dbt.level2!=sl.level then sl.level 
				else dbt.level1 end as  level2Date 
		   from dimLocationBranchUpdated dbt inner join sourceLocation sl on dbt.branchId=sl.branchId



		   insert into dimLocationBranchTemp
		   select sl.branchId ,sl.address ,sl.cityID ,sl.cityName ,sl.stateCode ,sl.stateName ,sl.level as level3 ,null as level2 ,null aslevel2Date ,null as level1 ,null as level1Date 
		   from dimLocationBranchUpdated dbu right outer join sourceLocation sl on dbu.branchId=sl.branchId
		   where dbu.branchId is null

		   truncate table  dimLocationBranch;
		   
		   insert into dimLocationBranch
		   select dbt.branchId,dbt.address,dbt.cityID,dbt.cityName,dbt.stateCode,dbt.stateName,dbt.level3,dbt.level2,dbt.level2Date,dbt.level1,dbt.level1Date
		   from dimLocationBranchTemp dbt

		   	truncate table dimLocationBranchTemp;
		truncate table dimLocationBranchUpdated;
		truncate table tempLocation;
		truncate table sourceLocation;

end