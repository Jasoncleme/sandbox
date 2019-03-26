CREATE TABLE [dbo].[DeliveredEmailAddresses]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[object_cmid] [int] NULL,
[MessageID] [int] NULL,
[EMailAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
