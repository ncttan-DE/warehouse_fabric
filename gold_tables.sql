SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gold].[dim_category](
	[cat_key] [uniqueidentifier] NOT NULL,
	[catgroup] [varchar](30) NULL,
	[catname] [varchar](30) NULL,
	[catdesc] [varchar](100) NULL,
	[created_at] [datetime2](6) NULL,
	[updated_at] [datetime2](6) NULL,
	[batch_id] [int] NULL,
	[hash] [varchar](128) NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gold].[dim_date](
	[date_key] [int] NOT NULL,
	[caldate] [date] NOT NULL,
	[day] [char](3) NOT NULL,
	[week] [int] NOT NULL,
	[month] [char](5) NOT NULL,
	[qtr] [char](5) NOT NULL,
	[year] [int] NOT NULL,
	[holiday] [smallint] NULL,
	[created_at] [datetime2](6) NULL,
	[updated_at] [datetime2](6) NULL,
	[batch_id] [int] NULL,
	[hash] [varchar](128) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gold].[dim_event](
	[event_key] [uniqueidentifier] NOT NULL,
	[venue_key] [uniqueidentifier] NOT NULL,
	[cat_key] [uniqueidentifier] NOT NULL,
	[date_key] [int] NOT NULL,
	[eventname] [varchar](200) NULL,
	[starttime] [datetime2](6) NULL,
	[created_at] [datetime2](6) NULL,
	[updated_at] [datetime2](6) NULL,
	[batch_id] [int] NULL,
	[hash] [varchar](128) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gold].[dim_user](
	[user_key] [uniqueidentifier] NOT NULL,
	[username] [char](8) NULL,
	[firstname] [varchar](30) NULL,
	[lastname] [varchar](30) NULL,
	[city] [varchar](30) NULL,
	[state] [char](2) NULL,
	[email] [varchar](100) NULL,
	[phone] [char](14) NULL,
	[likesports] [smallint] NULL,
	[liketheatre] [smallint] NULL,
	[likeconcerts] [smallint] NULL,
	[likejazz] [smallint] NULL,
	[likeclassical] [smallint] NULL,
	[likeopera] [smallint] NULL,
	[likerock] [smallint] NULL,
	[likevegas] [smallint] NULL,
	[likebroadway] [smallint] NULL,
	[likemusicals] [smallint] NULL,
	[topic] [varchar](20) NULL,
	[created_at] [datetime2](6) NULL,
	[updated_at] [datetime2](6) NULL,
	[batch_id] [int] NULL,
	[hash] [varchar](128) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gold].[dim_venue](
	[venue_key] [uniqueidentifier] NOT NULL,
	[venuename] [varchar](100) NULL,
	[venuecity] [varchar](30) NULL,
	[venuestate] [varchar](2) NULL,
	[venueseats] [int] NULL,
	[created_at] [datetime2](6) NULL,
	[updated_at] [datetime2](6) NULL,
	[batch_id] [int] NULL,
	[hash] [varchar](128) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gold].[fact_sales](
	[sales_key] [uniqueidentifier] NOT NULL,
	[seller_key] [uniqueidentifier] NULL,
	[buyer_key] [uniqueidentifier] NULL,
	[event_key] [uniqueidentifier] NOT NULL,
	[date_key] [int] NOT NULL,
	[qtysold] [int] NOT NULL,
	[pricepaid] [decimal](8, 2) NULL,
	[commission] [decimal](8, 2) NULL,
	[saletime] [datetime2](6) NULL,
	[created_at] [datetime2](6) NULL,
	[updated_at] [datetime2](6) NULL,
	[batch_id] [int] NULL,
	[hash] [varchar](128) NULL
) ON [PRIMARY]
GO
