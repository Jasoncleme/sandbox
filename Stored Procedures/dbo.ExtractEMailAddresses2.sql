SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--- Step3----
CREATE proc [dbo].[ExtractEMailAddresses2] as

-- slipts out delimited email addresses

declare @uid as int
declare @maxuid as int
declare @text as varchar(1000)
declare @temptext as varchar(1000)
declare @object_cmid as int
declare @MessageID as int


set @maxuid = (Select max(uid) from [BI_Admin].dbo.DeliveredEmailAddresses)
set @uid = 1

while @uid <= @maxuid
begin

set @text = (select EmailAddress from [BI_Admin].dbo.DeliveredEmailAddresses where UID = @uid)
set @object_cmid = (select object_cmid  from [BI_Admin].dbo.DeliveredEmailAddresses where UID = @uid)
set @MessageID = (select MessageID from [BI_Admin].dbo.DeliveredEmailAddresses where UID = @uid)

if patindex('%,%',@text) > 0 
begin

set @temptext = @text

while patindex('%,%',@temptext) <> 0
begin

/*print 'UID = ' + cast(@Uid as varchar(6))
print @temptext
print cast(patindex('%,%',@temptext) as varchar(10))
print 'emailaddress =' + substring(@temptext,1,patindex('%,%',@temptext) -1)
*/

insert into [BI_Admin].dbo.DeliveredEmailAddresses
select @object_cmid,@MessageID,substring(@temptext,1,patindex('%,%',@temptext) -1)

set @temptext = replace(@temptext,substring(@temptext,1,patindex('%,%',@temptext)),'')

update [BI_Admin].dbo.DeliveredEmailAddresses
set EMailAddress = replace(@temptext,' ','')
where [UID] = @uid

end


end

set @uid = @uid + 1

end
GO
