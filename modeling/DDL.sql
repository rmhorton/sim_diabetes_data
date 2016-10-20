USE [contosodemodb]
GO


CREATE TABLE [dbo].[Patients](
	[Id] [nvarchar](128) NOT NULL,
	[Patient_num] [nvarchar](max) NULL,
	[Encounter_id] [nvarchar](max) NULL,
	[First_name] [nvarchar](max) NULL,
	[Last_name] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[Admission_source_id] [nvarchar](max) NULL,
	[Admission_type_id] [nvarchar](max) NULL,
	[DiabetesMed] [nvarchar](max) NULL,
	[Diag_1] [nvarchar](max) NULL,
	[Discharge_disposition_id] [nvarchar](max) NULL,
	[Gender] [nvarchar](max) NULL,
	[Insulin] [nvarchar](max) NULL,
	[Metformin] [nvarchar](max) NULL,
	[Num_age] [nvarchar](max) NULL,
	[Discharge_time] [nvarchar](max) NULL,
	[Date_of_birth] [nvarchar](max) NULL,
	[Num_lab_procedures] [nvarchar](max) NULL,
	[Num_procedures] [nvarchar](max) NULL,
	[Number_diagnoses] [nvarchar](max) NULL,
	[Number_emergency] [nvarchar](max) NULL,
	[Number_inpatient] [nvarchar](max) NULL,
	[Number_outpatient] [nvarchar](max) NULL,
	[Pioglitazone] [nvarchar](max) NULL,
	[Rosiglitazone] [nvarchar](max) NULL,
	[Time_in_hospital] [nvarchar](max) NULL,
	[Bmi] [nvarchar](max) NULL,
	[Weight] [nvarchar](max) NULL,
	[Height] [nvarchar](max) NULL,
	[Zipcode] [nvarchar](max) NULL,
	[Pct_calories_from_carbs] [nvarchar](max) NULL,
	[Daily_minutes_walking] [nvarchar](max) NULL,
	[Sd_glucose] [nvarchar](max) NULL,
	[Readmitted] [nvarchar](max) NULL,
	[Imageuri] [nvarchar](max) NULL,
	[Version] [timestamp] NOT NULL,
	[CreatedAt] [datetimeoffset](7) NOT NULL,
	[UpdatedAt] [datetimeoffset](7) NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Patients] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)
)

GO

ALTER TABLE [dbo].[Patients] ADD  DEFAULT (newid()) FOR [Id]
GO

ALTER TABLE [dbo].[Patients] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO


