create table dimLocation(
	stateCode int,
	stateName varchar(20),
	cityCode int,
	cityName varchar(20),
	street varchar(100),
	latitude numeric(4,4),
	longitude numeric(4,4),
	primary key(latitude, longitude)
);

create table dimLocationCopy(
	stateCode int,
	stateName varchar(20),
	cityCode int,
	cityName varchar(20),
	street varchar(100),
	latitude numeric(4,4),
	longitude numeric(4,4),
	primary key(latitude, longitude)
);


create procedure procedureDimLocation
as
begin
	if exists(select * from dimLocationCopy) and not exists(select * from dimLocation)
		return -1;
	truncate table dimLocationCopy;
	insert into dimLocationCopy
		select stateCode, stateName, cityCode, cityName, street, latitude, longitude
		from dimLocation as d;

	with feedFromSource as(
		select l.x as longitude, l.y as latitude, l.street as street, c.cityId as cityCode,
				c.cityName as cityName, s.stateId as stateCode, s.stateName as stateName
		from sa_location as l inner join sa_city as c on(c.cityId = l.cityID) 
				inner join sa_state as s on (s.stateCode = c.stateCode)
	)insert into dimLocationCopy
		select ffs.stateCode, ffs.stateName, ffs.cityCode, ffs.cityName, ffs.street, ffs.latitude, ffs.longitude
		from feedFromSource as ffs left outer join dimLocation as dl on (dl.latitude = ffs.latitude and dl.longitude = ffs.longitude)
		where dl.latitude != NULL;

	truncate table dimLocation;

	insert into dimLocation
		select stateCode, stateName, cityCode, cityName, street, latitude, longitude
		from dimLocationCopy
end