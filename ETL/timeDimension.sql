create procedure procedureDimTime
as
begin
	truncate table dimTime;
	declare @timeCount time = '00:00:00';
	declare @AMPM char = 'A';
	declare @elapsedSecond int = 0;
	declare @elapsedMinute int = 0;
	declare @temp varchar(8) = '00000000';
	insert into dimtime values(@timeCount ,'12' ,'00' ,'00' ,'00' ,0 ,0 ,'AM' ,@timeCount);
	set @timeCount = convert(varchar(8), DATEADD(SECOND, 5, '00:00:00'), 108);
	set @elapsedSecond = @elapsedSecond + 1;
	while(@timeCount != '00:00:00')
	begin
		set @temp = CONVERT(varchar(15),@timeCount,100);
		insert into dimTime values(@timeCount, DATEPART(HOUR, @temp), DATEPART(hour, @timeCount), datepart(minute, @timeCount),
									 datepart(SECOND, @timeCount), @elapsedMinute, @elapsedSecond, substring(@temp,6,7) ,@timeCount);
		
		set @timeCount = convert(varchar(8), DATEADD(SECOND, 5, '00:00:00'), 108);
		set @elapsedSecond = @elapsedSecond + 1;
		if(@elapsedSecond % 60 = 0)
			set @elapsedMinute = @elapsedMinute + 1;
		
	end
end

drop table dimtime
create table dimTime(
	timeKey time primary key,
	Hour12 char(2),
	Hour24 char(2),
	MinuteOfHour char(2),
	SecondOfMinute char(2),
	ElapsedMinutes int,
	ElapsedSeconds int,
	AMPM char(2),
	HHMMSS time
);

--	SELECT CONVERT(VARCHAR(8), DATEADD(SECOND, 1, '23:59:59'), 108)

--select DATEADD(SECOND, 5, '00:00:00')

--declare @t time
--set @t = '00:04:00'

--select CONVERT(varchar(15),@t,100)


  --select DATEPARt(HOUR, CONVERT(time, CURRENT_TIMESTAMP));  

  --SELECT DATEPART(HOUR, GETDATE());