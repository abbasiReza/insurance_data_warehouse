

CREATE procedure  [fillDimPolicy]
as
begin

	if exists(select * from tempDimPolicy) and not exists(select * from dimPolicy)
		return -1;

	truncate table tempDimPolicy
	insert into tempDimPolicy
		select policyNumber, policyEffectiveDate, policyExpireDate, optionCode, optionDesc, lastUpdate, totalAmount,
		 active, additionalInfo, createDate
		from dimPolicy

	truncate table sourceDimPolicy
	insert into sourceDimPolicy
		select policyNumber, policyEffectiveDate, policyExpireDate, t1.optionCode, optionDesc, lastUpdate, totalAmount,
		 active, additionalInfo, createDate
		from SA_Policy as t1 inner join SA_PaymentOption as t2 on t1.optionCode = t2.optionCode
	
	truncate table dimPolicy
	insert into dimPolicy
		select isnull(t1.policyNumber, t2.policyNumber), isnull(t1.policyEffectiveDate, t1.policyEffectiveDate),
		 isnull(t1.policyExpireDate, t2.policyExpireDate), isnull(t1.optionCode, t2.optionCode),
		  isnull(t1.optionDesc, t2.optionDesc), isnull(t1.lastUpdate, t2.lastUpdate), 
		  isnull(t1.totalAmount, t2.totalAmount), isnull(t1.active, t2.active),
		  isnull(t1.additionalInfo, t2.additionalInfo), isnull(t1.createDate, t2.createDate)
		from sourceDimPolicy as t1 full outer join tempDimPolicy as t2 on t1.policyNumber = t2.policyNumber 

end
