create table dimCityLocationCopy(
	stateCode int,
	stateName varchar(20),
	cityCode int primary key,
	cityName varchar(20)
);

create procedure procedureDimCityLocation
as
begin
	if exists(select * from dimCityLocationCopy) and not exists(select * from dimCityLocation)
		return -1;
	truncate table dimCityLocationCopy;

	insert into dimCityLocationCopy
		select stateCode, stateName, cityCode, cityName
		from dimCityLocation as d;

	with feedFromSource as(
		select c.cityId as cityCode, c.cityName as cityName, s.stateId as stateCode, s.stateName as stateName
		from sa_city as c inner join sa_state as s on (s.stateCode = c.stateCode)
	)insert into dimCityLocationCopy
		select ffs.stateCode, ffs.stateName, ffs.cityCode, ffs.cityName
		from feedFromSource as ffs left outer join dimCityLocation as dcl on (ffs.cityCode = dcl.cityCode)
		where dcl.cityCode != NULL;

	truncate table dimCityLocation;

	insert into dimCityLocation
		select stateCode, stateName, cityCode, cityName
		from dimCityLocationCopy
end