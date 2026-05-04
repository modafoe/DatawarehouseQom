CREATE TABLE [dbo].[DimPlant](
    [PlantID] [uniqueidentifier] NOT NULL,
    [Name]  NULL,
    [ScientificName] [nvarchar](max) NULL,
    [Family] [nvarchar](max) NULL,
    [Description] [nvarchar](max) NULL,
    [UsagePart] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED ([PlantID] ASC)
);

CREATE TABLE [dbo].[DimChemicalCompound](
    [CompoundID] [uniqueidentifier] NOT NULL,
    [PlantID] [uniqueidentifier] NULL,
    [CompoundName]  NULL,
    [Concentration] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED ([CompoundID] ASC),
FOREIGN KEY ([PlantID]) REFERENCES [dbo].[DimPlant]([PlantID])
);

CREATE TABLE [dbo].[DimMedicinalProperty](
    [PropertyID] [uniqueidentifier] NOT NULL,
    [PlantID] [uniqueidentifier] NULL,
    [Property] [nvarchar](max) NULL,
    [Details] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED ([PropertyID] ASC),
FOREIGN KEY ([PlantID]) REFERENCES [dbo].[DimPlant]([PlantID])
);

CREATE TABLE [dbo].[DimRegion](
    [RegionID] [uniqueidentifier] NOT NULL,
    [PlantID] [uniqueidentifier] NULL,
    [RegionName] [nvarchar](max) NULL,
    [Climate] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED ([RegionID] ASC),
FOREIGN KEY ([PlantID]) REFERENCES [dbo].[DimPlant]([PlantID])
);

CREATE TABLE [dbo].[FactUsage](
    [UsageID] [uniqueidentifier] NOT NULL,
    [PlantID] [uniqueidentifier] NULL,
    [Method]  NULL,
    [Dosage] [nvarchar](max) NULL,
    [Details] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED ([UsageID] ASC),
FOREIGN KEY ([PlantID]) REFERENCES [dbo].[DimPlant]([PlantID])
);
