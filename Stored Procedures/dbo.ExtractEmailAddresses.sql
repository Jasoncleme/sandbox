SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[ExtractEmailAddresses] as

-- This extracts the email addresses from the schedules that are set to deliver content.

--We'll need to process each contentstore record one at a time.
-- then store all the lines from the message in one varchar(max) variable
-- then parse that string with all the email addresses into another table (DeliveredEmailAddresses),
-- store with objectID, and Message ID

declare @MessageID as int
declare @object_cmid as int
declare @uid as int
declare @maxuid as int
declare @linenums as int
declare @text as varchar(max)
declare @xmltext as varchar(max)
declare @untrimmedxml as varchar(max)
declare @linecount as int
declare @len as int
declare @email as varchar(200)

truncate table BI_Admin.dbo.DeliveredEmailAddresses

set @uid = 1
set @maxuid = (select max(UID) from BI_Admin.dbo.ContentStoreObjects)

--loop through content store
while @uid <= @maxuid
begin

set @object_cmid = (select object_cmid from BI_Admin.dbo.ContentStoreObjects where UID = @uid)

if (select count(*) from BI_Admin.dbo.ContentStoreObjects where UID = @uid and MessageID is not null) > 0 
begin

Set @MessageID = (select MessageID from  BI_Admin.dbo.ContentStoreObjects where UID = @uid)
set @linenums = (select max(LINE_NO) from Cognos_10.dbo.NC_MESSAGELINE_ELEMENT where FK_MESSAGESTRUCT_ID = @MessageID)
set @text = ''
set @linecount = 0

--store xml as varchar
while @linecount <= @linenums
begin

set @text = @text + (select [Text] from Cognos_10.dbo.NC_MESSAGELINE_ELEMENT where LINE_NO = @linecount and FK_MESSAGESTRUCT_ID = @MessageID)

set @linecount = @linecount + 1
end

--store length of string
set @len = len(@text)

set @xmltext = @text
--print @text
--print cast(@len as varchar(10))

-- parse this text, and store it in 
-- loop until the item  '"ns1:addressSMTP[1]"><item>' can no longer be found in @xmltext

--print cast( patindex('%ns1:addressSMTP%',@xmltext) as varchar(10))

while patindex('%ns1:addressSMTP%',@xmltext) <> 0
begin

--print @text
--print substring(@xmltext,patindex('%ns1:addressSMTP%',@xmltext)+26,@len)
set @untrimmedxml = substring(@xmltext,patindex('%ns1:addressSMTP%',@xmltext)+26,@len)
--return email address
set @email = substring(@untrimmedxml,1,patindex('%</item>%',@untrimmedxml)-1)
set @xmltext = @untrimmedxml

insert into BI_Admin.dbo.DeliveredEmailAddresses
select @object_cmid,@MessageID,@email

--print @email
--print @xmltext
end

set @text = null

end
set @uid = @uid +1
end
GO
