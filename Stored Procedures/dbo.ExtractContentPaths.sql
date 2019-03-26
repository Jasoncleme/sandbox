SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[ExtractContentPaths] as
--work through each UID, look up the parent_cmid, then pull the parent name from the 'object_cmid'
--, then pull the parent of that parent, until a parent can't be found, then go to the next UID
-- 


declare @uid as int
declare @maxuid as int
declare @parent as int
declare @child as int
declare @childname as varchar(400)
declare @parentname as varchar(400)
declare @path as varchar(4000)

set @maxuid = (select max(uid) from BI_Admin.dbo.ContentStoreObjects)
set @uid = 1

while @uid <= @maxuid

begin
set @path = ''

--grab the item name, and parent_cmid
set @child = (select Object_cmid from BI_Admin.dbo.ContentStoreObjects where UID = @uid)
set @childname = (select ObjectNAME from BI_Admin.dbo.ContentStoreObjects where Object_cmid = @child)
set @parent = (select parent_cmid from BI_Admin.dbo.ContentStoreObjects where Object_cmid = @child)
set @parentname = (select ParentNAME from BI_Admin.dbo.ContentStoreObjects where Object_cmid = @child)

set @path = @parentname + ' > ' + @childname

while (select count(*) from BI_Admin.dbo.ContentStoreObjects where object_cmid = @parent) > 0
   begin

/*
print 'FIrst Path = ' + @path
print 'First Child = ' + @childname
print 'ChildID = ' + cast(@child as varchar(10))
print 'First Parent = ' + @parentname
print 'ParentID = ' + cast(@parent as varchar(10))
*/

set @child = (select Object_cmid from BI_Admin.dbo.ContentStoreObjects where Object_cmid = @parent)
set @childname = (select ParentNAME from BI_Admin.dbo.ContentStoreObjects where Object_cmid = @child)

set @parent = (select parent_cmid from BI_Admin.dbo.ContentStoreObjects where Object_cmid = @child)
set @parentname = (select ObjectNAME from BI_Admin.dbo.ContentStoreObjects where Object_cmid = @parent)

set @path = @childname + ' > ' + @path

/*print 'Second Path = ' + @path
print 'Second Child = ' + @childname
print 'Second Parent = ' + @parentname
print 'ChildID = ' + cast(@child as varchar(10))
print 'ParentID = ' + cast(@parent as varchar(10))
*/

end
--select ObjectNAME from BI_Admin.dbo.ContentStoreObjects where Object_cmid = 2

update BI_Admin.dbo.ContentStoreObjects
set ObjectPath = @path
where UID = @uid

set @uid = @uid + 1

end


-- loop through email records

-- if the record has a ',', then parse out the email addresses,
-- and insert seperate records for each email address (with same object_cmid, and MessageID
GO
