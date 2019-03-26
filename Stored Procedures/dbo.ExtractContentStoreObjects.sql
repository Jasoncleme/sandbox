SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[ExtractContentStoreObjects]
AS --SET IDENTITY_INSERT BI_Admin.dbo.ContentStoreObjects ON

    TRUNCATE TABLE BI_Admin.dbo.ContentStoreObjects

    INSERT  INTO BI_Admin.dbo.ContentStoreObjects
            ( [timestamp1] ,
              [class_type] ,
              [ObjectNAME] ,
              [ParentName] ,
              [SourceReportIfReportView] ,
              [ParentClass_Type] ,
              [parent_cmid] ,
              [object_cmid] ,
              [ObjectPath] ,
              [NC_Schedule_PK_ID] ,
              [MessageID] ,
              [obj_modified] ,
              [obj_disabled] ,
              [obj_classid] ,
              [DISPSEQ] ,
              [obj_owner] ,
              [Store_id] ,
              [news_type] ,
              [STARTDATE] ,
              [ENDDATE] ,
              [ENDTYPE] ,
              [EVERYNPERIODS] ,
              [DAILYPERIOD] ,
              [MONTHLYABSDAY] ,
              [MONTHLYRELDAY] ,
              [MONTHLYRELWEEK] ,
              [CMOBJPROP2_type] ,
              [YEARLYABSDAY] ,
              [YEARLYABSMONTH] ,
              [YEARLYRELDAY] ,
              [YEARLYRELMONTH] ,
              [YEARLYRELWEEK] ,
              [CMOBJPROPS2_active] ,
              [WEEKLYMONDAY] ,
              [WEEKLYTUESDAY] ,
              [WEEKLYWEDNESDAY] ,
              [WEEKLYTHURSDAY] ,
              [WEEKLYFRIDAY] ,
              [WEEKLYSATURDAY] ,
              [WEEKLYSUNDAY] ,
              [TaskSchedule_Description] ,
              [LAST_EXECUTION_AT] ,
              [NEXT_EXECUTION_REQUEST] ,
              [IS_ACTIVE] ,
              [IS_ESCALATION] ,
              [Schedule_type] ,
              [LASTMOD_BY] ,
              [LASTMOD_TIME] ,
              [MODCOUNT] ,
              [TIMEZONE] ,
              [START_DATE] ,
              [END_DATE] ,
              [REPEAT_FOREVER] ,
              [nc_schedule_active] ,
              [VALID_SCHEDULE] ,
              [USE_DAY_NUMBER] ,
              [DAY_OF_MONTH] ,
              [DAY_OF_WEEK] ,
              [DAY_OF_WEEK_IN_MONTH] ,
              [MONTH_OF_YEAR] ,
              [REPEAT_INTERVAL] ,
              [DAYS_OF_WEEK] ,
              [FIXED_INTERVAL_TYPE] ,
              [Trigger_name] ,
              [Bui]
            )
            SELECT  GETDATE() AS timestamp1 ,
                    class.name AS class_type ,
                    CASE WHEN names.NAME NOT LIKE '20%:%.%'
                              OR names2.name IS NULL THEN names.name
                         ELSE names2.name
                    END AS objectname ,
                    parentnames.name AS parentname ,
                    NULL AS SourceReportIfReportView ,
                    NULL AS ParentClass_Type ,
                    obj.PCMID AS parent_cmid ,
                    obj.cmid AS object_cmid ,
                    NULL AS ObjectPath ,
                    Sched1.PK_Schedule_ID AS NC_Schedule_PK_ID ,
                    msgstrc1.FK_MESSAGESTRUCT_ID AS MessageID ,
                    DATEADD(hh, -7, obj.MODIFIED) AS obj_modified ,
                    obj.DISABLED AS obj_disabled ,
                    obj.CLASSID AS obj_classid ,
                    obj.DISPSEQ ,
                    OWNER AS obj_owner , 
	--obj.HIDDEN as obj_hidden,
	--NULL AS obj_hidden,
                    store.storeid AS Store_id ,
                    news.Type AS news_type ,
                    prop2.STARTDATE ,
                    prop2.ENDDATE ,
                    prop2.ENDTYPE ,
                    prop2.EVERYNPERIODS ,
                    prop2.DAILYPERIOD ,
                    prop2.MONTHLYABSDAY ,
                    prop2.MONTHLYRELDAY ,
                    prop2.MONTHLYRELWEEK ,
                    prop2.TYPE AS CMOBJPROP2_type ,
                    prop2.YEARLYABSDAY ,
                    prop2.YEARLYABSMONTH ,
                    prop2.YEARLYRELDAY ,
                    prop2.YEARLYRELMONTH ,
                    prop2.YEARLYRELWEEK ,
                    prop2.ACTIVE AS CMOBJPROPS2_active ,
                    prop2.WEEKLYMONDAY ,
                    prop2.WEEKLYTUESDAY ,
                    prop2.WEEKLYWEDNESDAY ,
                    prop2.WEEKLYTHURSDAY ,
                    prop2.WEEKLYFRIDAY ,
                    prop2.WEEKLYSATURDAY ,
                    prop2.WEEKLYSUNDAY ,
                    TaskSched.DESCRIPTION AS TaskSchedule_Description ,
                    TaskSched.LAST_EXECUTION_AT ,
                    TaskSched.NEXT_EXECUTION_REQUEST ,
                    R_Sched.IS_ACTIVE ,
                    R_Sched.IS_ESCALATION ,
                    Sched1.NAME AS Schedule_type ,
                    Sched1.LASTMOD_BY ,
                    Sched1.LASTMOD_TIME ,
                    Sched1.MODCOUNT ,
                    Sched1.TIMEZONE ,
                    Sched1.START_DATE ,
                    Sched1.END_DATE ,
                    Sched1.REPEAT_FOREVER ,
                    Sched1.ACTIVE AS nc_schedule_active ,
                    Sched1.VALID_SCHEDULE ,
                    Sched1.USE_DAY_NUMBER ,
                    Sched1.DAY_OF_MONTH ,
                    Sched1.DAY_OF_WEEK ,
                    Sched1.DAY_OF_WEEK_IN_MONTH ,
                    Sched1.MONTH_OF_YEAR ,
                    Sched1.REPEAT_INTERVAL ,
                    Sched1.DAYS_OF_WEEK ,
                    Sched1.FIXED_INTERVAL_TYPE ,
                    Sched1.TRIGGER_ID AS Trigger_name ,
                    CASE WHEN TRIGGER_ID IS NULL THEN NULL
                         WHEN PATINDEX('%-%', Trigger_ID) = 0 THEN TRIGGER_ID
                         WHEN PATINDEX('%-%', Trigger_ID) > 0
                         THEN SUBSTRING(Trigger_ID, 1,
                                        PATINDEX('%-%', Trigger_ID) - 1)
                    END AS Bui
            FROM    Cognos_10.dbo.CMOBJECTS obj WITH ( NOLOCK )
                    JOIN Cognos_10.dbo.CMOBJNAMES names WITH ( NOLOCK )
                                                             ON names.cmid = obj.CMID
                    LEFT OUTER JOIN Cognos_10.dbo.CMOBJNAMES parentnames WITH ( NOLOCK )
                                                              ON parentnames.cmid = obj.PCMID
                    JOIN Cognos_10.dbo.CMCLASSES class WITH ( NOLOCK )
                                                            ON obj.classid = class.classid
                    JOIN Cognos_10.dbo.CMSTOREIDS store WITH ( NOLOCK )
                                                             ON obj.cmid = store.cmid
                    LEFT OUTER JOIN Cognos_10.dbo.CMOBJProps2 prop2 WITH ( NOLOCK )
                                                              ON obj.cmid = prop2.cmid
                    LEFT OUTER JOIN Cognos_10.dbo.R_NEWSITEMS_NCOBJECTS news
                    WITH ( NOLOCK )
                         ON prop2.TaskID = news.NID
                    LEFT OUTER JOIN Cognos_10.dbo.NC_TASKSCHEDULE TaskSched
                    WITH ( NOLOCK )
                         ON news.FK_NCID = TaskSched.FK_TASK_ID
                    LEFT OUTER JOIN Cognos_10.dbo.R_MESSAGESTRUCT_TASK msgstrc1
                    WITH ( NOLOCK )
                         ON TaskSched.FK_TASK_ID = msgstrc1.FK_TASK_ID
                    LEFT OUTER JOIN Cognos_10.dbo.R_TASKSCHEDULE_SCHEDULE R_Sched
                    WITH ( NOLOCK )
                         ON TaskSched.PK_TaskSchedule_ID = R_Sched.FK_TaskSchedule_ID
                    LEFT OUTER JOIN Cognos_10.dbo.NC_SCHEDULE Sched1 WITH ( NOLOCK )
                                                              ON R_Sched.FK_Schedule_ID = Sched1.PK_Schedule_ID
                    LEFT OUTER JOIN Cognos_10.dbo.CMREFNOORD1 Vers WITH ( NOLOCK )
                                                              ON obj.CMID = Vers.CMID
                    LEFT OUTER JOIN ( SELECT DISTINCT
                                                name ,
                                                cmid
                                      FROM      Cognos_10.dbo.CMOBJNAMES WITH ( NOLOCK )
                                      WHERE     localeid IN ( 48, 24 )
                                    ) names2
                        ON names2.cmid = Vers.Refcmid
            WHERE   ( names.localeid IN ( 48, 24 )
                      AND parentnames.localeid IN ( 48, 24 )
                    )
                    AND ( class.name IN ( 'schedule', 'reportView',
                                          'agentTaskDefinition',
                                          'agentDefinition', 'report',
                                          'packageconfiguration', 'folder',
                                          'jobDefinition', 'jobStepDefinition' )
                          OR class.name LIKE '%Package%'
                        )
--and class.name = 'Schedule' and R_Sched.IS_ACTIVE = 1 
--and Sched1.NAME = 'Triggered Schedule'
GROUP BY            class.name ,
                    parentnames.name ,
                    CASE WHEN names.NAME NOT LIKE '20%:%.%'
                              OR names2.name IS NULL THEN names.name
                         ELSE names2.name
                    END ,
                    obj.PCMID ,
                    names.cmid ,
                    obj.cmid ,
                    Sched1.PK_Schedule_ID ,
                    msgstrc1.FK_MESSAGESTRUCT_ID ,
                    obj.MODIFIED ,
                    obj.DISABLED ,
                    obj.CLASSID ,
                    obj.DISPSEQ ,
                    OWNER , 
	--obj.HIDDEN,
                    store.storeid ,
                    news.Type ,
                    prop2.STARTDATE ,
                    prop2.ENDDATE ,
                    prop2.ENDTYPE ,
                    prop2.EVERYNPERIODS ,
                    prop2.DAILYPERIOD ,
                    prop2.MONTHLYABSDAY ,
                    prop2.MONTHLYRELDAY ,
                    prop2.MONTHLYRELWEEK ,
                    prop2.TYPE ,
                    prop2.YEARLYABSDAY ,
                    prop2.YEARLYABSMONTH ,
                    prop2.YEARLYRELDAY ,
                    prop2.YEARLYRELMONTH ,
                    prop2.YEARLYRELWEEK ,
                    prop2.ACTIVE ,
                    prop2.WEEKLYMONDAY ,
                    prop2.WEEKLYTUESDAY ,
                    prop2.WEEKLYWEDNESDAY ,
                    prop2.WEEKLYTHURSDAY ,
                    prop2.WEEKLYFRIDAY ,
                    prop2.WEEKLYSATURDAY ,
                    prop2.WEEKLYSUNDAY ,
                    TaskSched.DESCRIPTION ,
                    TaskSched.LAST_EXECUTION_AT ,
                    TaskSched.NEXT_EXECUTION_REQUEST ,
                    R_Sched.IS_ACTIVE ,
                    R_Sched.IS_ESCALATION ,
                    Sched1.NAME ,
                    Sched1.LASTMOD_BY ,
                    Sched1.LASTMOD_TIME ,
                    Sched1.MODCOUNT ,
                    Sched1.SCHEDULE_TYPE ,
                    Sched1.TIMEZONE ,
                    Sched1.START_DATE ,
                    Sched1.END_DATE ,
                    Sched1.REPEAT_FOREVER ,
                    Sched1.ACTIVE ,
                    Sched1.VALID_SCHEDULE ,
                    Sched1.USE_DAY_NUMBER ,
                    Sched1.DAY_OF_MONTH ,
                    Sched1.DAY_OF_WEEK ,
                    Sched1.DAY_OF_WEEK_IN_MONTH ,
                    Sched1.MONTH_OF_YEAR ,
                    Sched1.REPEAT_INTERVAL ,
                    Sched1.DAYS_OF_WEEK ,
                    Sched1.FIXED_INTERVAL_TYPE ,
                    Sched1.FIXED_INTERVAL_IN_MILLIS ,
                    Sched1.TRIGGER_ID


--Update Version names with real names
    UPDATE  dbo.ContentStoreObjects
    SET     ObjectNAME = REPLACE(ObjectNAME, 'Vers_', '')
    WHERE   ObjectName LIKE 'Vers_%'

--Update report views with report sources
    SELECT  cm1.object_cmid ,
            cm2.objectname
    INTO    #reportviewsources
    FROM    dbo.ContentStoreObjects cm1
            JOIN Cognos_10.dbo.CMREFNOORD1 ref
                ON cm1.object_cmid = ref.cmid
            JOIN dbo.ContentStoreObjects cm2
                ON ref.refcmid = cm2.object_cmid
    WHERE   cm1.class_type = 'reportview'

    UPDATE  dbo.ContentStoreObjects
    SET     SourceReportIfReportView = src.objectname
    FROM    #reportviewsources src
    WHERE   dbo.ContentStoreObjects.object_cmid = src.object_cmid 


--update parent object names

    UPDATE  dbo.ContentStoreObjects
    SET     ParentClass_Type = class.name
    FROM    Cognos_10.dbo.CMOBJECTS cn
            JOIN dbo.ContentStoreObjects obj
                ON cn.CMID = obj.parent_cmid
            JOIN Cognos_10.dbo.CMCLASSES class WITH ( NOLOCK )
                                                    ON cn.classid = class.classid

    EXECUTE ExtractEmailAddresses
    EXECUTE ExtractEMailAddresses2
    EXECUTE ExtractContentPaths

    DROP TABLE #reportviewsources

--SET IDENTITY_INSERT BI_Admin.dbo.ContentStoreObjects OFF

    PRINT 'Data from Cognos_10 DB loaded to BI_Admin.dbo.ContentStoreObjects, email addresses extracted, paths constructed'
GO
