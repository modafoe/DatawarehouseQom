USE [master]
GO
/****** Object:  Database [HerbalDW]    Script Date: 2026-05-04 20:21:18 ******/
CREATE DATABASE [HerbalDW]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HerbalDW', FILENAME = N'I:\SQL\MSSQL17.MSSQLSERVER25\MSSQL\DATA\HerbalDW.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'HerbalDW_log', FILENAME = N'I:\SQL\MSSQL17.MSSQLSERVER25\MSSQL\DATA\HerbalDW_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [HerbalDW] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HerbalDW].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HerbalDW] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HerbalDW] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HerbalDW] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HerbalDW] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HerbalDW] SET ARITHABORT OFF 
GO
ALTER DATABASE [HerbalDW] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [HerbalDW] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HerbalDW] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HerbalDW] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HerbalDW] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HerbalDW] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HerbalDW] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HerbalDW] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HerbalDW] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HerbalDW] SET  ENABLE_BROKER 
GO
ALTER DATABASE [HerbalDW] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HerbalDW] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HerbalDW] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HerbalDW] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HerbalDW] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HerbalDW] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HerbalDW] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HerbalDW] SET RECOVERY FULL 
GO
ALTER DATABASE [HerbalDW] SET  MULTI_USER 
GO
ALTER DATABASE [HerbalDW] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HerbalDW] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HerbalDW] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HerbalDW] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [HerbalDW] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [HerbalDW] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [HerbalDW] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'HerbalDW', N'ON'
GO
ALTER DATABASE [HerbalDW] SET QUERY_STORE = ON
GO
ALTER DATABASE [HerbalDW] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [HerbalDW]
GO
/****** Object:  Schema [dw]    Script Date: 2026-05-04 20:21:19 ******/
CREATE SCHEMA [dw]
GO
/****** Object:  Schema [etl]    Script Date: 2026-05-04 20:21:19 ******/
CREATE SCHEMA [etl]
GO
/****** Object:  Schema [ods]    Script Date: 2026-05-04 20:21:19 ******/
CREATE SCHEMA [ods]
GO
/****** Object:  Schema [staging]    Script Date: 2026-05-04 20:21:19 ******/
CREATE SCHEMA [staging]
GO
/****** Object:  Table [dw].[DimPlant]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimPlant](
	[PlantSK] [int] IDENTITY(1,1) NOT NULL,
	[PlantCanonicalKey] [varchar](64) NOT NULL,
	[CanonicalNameFa] [nvarchar](256) NULL,
	[CanonicalNameEn] [nvarchar](256) NULL,
	[ScientificName] [nvarchar](256) NULL,
	[Family] [nvarchar](128) NULL,
	[TaxonomyPath] [nvarchar](512) NULL,
	[SourceList] [nvarchar](1024) NULL,
	[CanonicalSource] [nvarchar](256) NULL,
	[TrustScore] [decimal](5, 4) NULL,
	[EffectiveFrom] [datetime2](7) NOT NULL,
	[EffectiveTo] [datetime2](7) NULL,
	[IsCurrent] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[PlantSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[PlantCanonicalKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dw].[vw_PlantLookup]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dw].[vw_PlantLookup]
AS
SELECT PlantCanonicalKey, PlantSK, CanonicalNameFa, ScientificName, TrustScore
FROM dw.DimPlant
WHERE IsCurrent = 1;
GO
/****** Object:  Table [dw].[DimBiologicalTarget]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimBiologicalTarget](
	[TargetSK] [int] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NULL,
	[TargetBusinessKey] [nvarchar](100) NULL,
	[TargetName] [nvarchar](150) NULL,
	[TargetType] [nvarchar](100) NULL,
	[OrganismSpecies] [nvarchar](100) NULL,
	[CellularLocalization] [nvarchar](100) NULL,
	[BiologicalPathway] [nvarchar](200) NULL,
	[BindingAffinity] [nvarchar](50) NULL,
	[TargetFunction] [nvarchar](max) NULL,
	[ExpressionPattern] [nvarchar](max) NULL,
	[ReceptorSubtype] [nvarchar](100) NULL,
	[StructuralFeatures] [nvarchar](max) NULL,
	[KnownLigands] [nvarchar](max) NULL,
	[RelatedDiseases] [nvarchar](200) NULL,
	[GeneticVariants] [nvarchar](max) NULL,
	[AlternateNames] [nvarchar](max) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TargetSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimChannel]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimChannel](
	[ChannelSK] [int] IDENTITY(1,1) NOT NULL,
	[ChannelKey] [varchar](64) NOT NULL,
	[ChannelName] [nvarchar](256) NOT NULL,
	[ChannelType] [nvarchar](128) NULL,
	[Description] [nvarchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[ChannelSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ChannelKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimClimate]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimClimate](
	[ClimateSK] [int] IDENTITY(1,1) NOT NULL,
	[ClimateKey] [varchar](64) NOT NULL,
	[TemperatureAvg] [decimal](6, 2) NULL,
	[HumidityAvg] [decimal](6, 2) NULL,
	[RainfallAvg] [decimal](10, 2) NULL,
	[ClimateClass] [nvarchar](128) NULL,
	[SourceList] [nvarchar](1024) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ClimateSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ClimateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimCompound]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimCompound](
	[CompoundSK] [int] IDENTITY(1,1) NOT NULL,
	[CompoundCanonicalKey] [varchar](64) NOT NULL,
	[InChIKey] [varchar](27) NULL,
	[CASNumber] [varchar](32) NULL,
	[CanonicalNameFa] [nvarchar](256) NULL,
	[CanonicalNameEn] [nvarchar](256) NULL,
	[Formula] [nvarchar](64) NULL,
	[MolWeight] [decimal](10, 4) NULL,
	[SourceList] [nvarchar](1024) NULL,
	[CanonicalSource] [nvarchar](256) NULL,
	[TrustScore] [decimal](5, 4) NULL,
	[EffectiveFrom] [datetime2](7) NOT NULL,
	[EffectiveTo] [datetime2](7) NULL,
	[IsCurrent] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[CompoundSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CompoundCanonicalKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimCompoundAlias]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimCompoundAlias](
	[AliasSK] [bigint] IDENTITY(1,1) NOT NULL,
	[CompoundCanonicalKey] [varchar](64) NOT NULL,
	[AliasLabelFa] [nvarchar](512) NULL,
	[AliasLabelEn] [nvarchar](512) NULL,
	[AliasType] [nvarchar](64) NULL,
	[SourceSystem] [nvarchar](128) NULL,
	[SourceRecordId] [nvarchar](256) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AliasSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimCultivation]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimCultivation](
	[CultivationSK] [int] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NULL,
	[PropagationMethod] [nvarchar](100) NULL,
	[SeedGerminationRate] [nvarchar](50) NULL,
	[OptimalSowingTime] [nvarchar](100) NULL,
	[HarvestTime] [nvarchar](100) NULL,
	[YieldPerHectare] [nvarchar](50) NULL,
	[CultivationSeason] [nvarchar](100) NULL,
	[FertilizerRequirements] [nvarchar](max) NULL,
	[PesticideUsage] [nvarchar](max) NULL,
	[IrrigationNeeds] [nvarchar](50) NULL,
	[PlantSpacing] [nvarchar](50) NULL,
	[GrowthDuration] [nvarchar](50) NULL,
	[SoilPreparation] [nvarchar](max) NULL,
	[PostHarvestHandling] [nvarchar](max) NULL,
	[ManagedEnvironment] [nvarchar](100) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CultivationSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimDosageForm]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimDosageForm](
	[DosageFormSK] [int] IDENTITY(1,1) NOT NULL,
	[FormBusinessKey] [nvarchar](100) NULL,
	[FormName] [nvarchar](100) NULL,
	[PhysicalState] [nvarchar](50) NULL,
	[Solvent] [nvarchar](100) NULL,
	[Concentration] [nvarchar](50) NULL,
	[DoseUnit] [nvarchar](50) NULL,
	[TypicalDose] [nvarchar](50) NULL,
	[MaxDailyDose] [nvarchar](50) NULL,
	[PreparationTime] [nvarchar](50) NULL,
	[StorageConditions] [nvarchar](200) NULL,
	[ShelfLife] [nvarchar](50) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DosageFormSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimHabitat]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimHabitat](
	[HabitatSK] [int] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NULL,
	[HabitatType] [nvarchar](100) NULL,
	[AltitudeRange] [nvarchar](50) NULL,
	[SoilMoistureLevel] [nvarchar](50) NULL,
	[ShadeTolerance] [nvarchar](50) NULL,
	[WaterRequirement] [nvarchar](50) NULL,
	[PHPreference] [nvarchar](50) NULL,
	[AssociatedVegetation] [nvarchar](200) NULL,
	[SalinityTolerance] [nvarchar](50) NULL,
	[DisturbanceTolerance] [nvarchar](50) NULL,
	[TypicalCommunity] [nvarchar](200) NULL,
	[HabitatDescription] [nvarchar](max) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[HabitatSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimPhytochemicalClass]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimPhytochemicalClass](
	[PhytoClassSK] [int] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NULL,
	[ClassBusinessKey] [nvarchar](100) NULL,
	[ClassName] [nvarchar](150) NULL,
	[ClassLevel] [nvarchar](50) NULL,
	[ParentClass] [nvarchar](150) NULL,
	[SubClass] [nvarchar](150) NULL,
	[Definition] [nvarchar](max) NULL,
	[StructuralCharacteristics] [nvarchar](max) NULL,
	[CommonExamples] [nvarchar](max) NULL,
	[Occurrence] [nvarchar](200) NULL,
	[ExtractionSolvent] [nvarchar](100) NULL,
	[ConcentrationRange] [nvarchar](100) NULL,
	[BioactivityProfile] [nvarchar](max) NULL,
	[AnalyticalMethods] [nvarchar](200) NULL,
	[RegulatoryStatus] [nvarchar](100) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PhytoClassSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimPlantAlias]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimPlantAlias](
	[AliasSK] [bigint] IDENTITY(1,1) NOT NULL,
	[PlantCanonicalKey] [varchar](64) NOT NULL,
	[AliasLabelFa] [nvarchar](512) NULL,
	[AliasLabelEn] [nvarchar](512) NULL,
	[AliasType] [nvarchar](64) NULL,
	[SourceSystem] [nvarchar](128) NULL,
	[SourceRecordId] [nvarchar](256) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AliasSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimProcessingMethod]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimProcessingMethod](
	[ProcessingSK] [int] IDENTITY(1,1) NOT NULL,
	[ProcessBusinessKey] [nvarchar](100) NULL,
	[ProcessName] [nvarchar](150) NULL,
	[Description] [nvarchar](max) NULL,
	[Temperature] [nvarchar](50) NULL,
	[Duration] [nvarchar](50) NULL,
	[SolventType] [nvarchar](100) NULL,
	[FilterType] [nvarchar](100) NULL,
	[YieldPercent] [nvarchar](50) NULL,
	[EquipmentNeeded] [nvarchar](200) NULL,
	[DryingMethod] [nvarchar](100) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProcessingSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimProduct]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimProduct](
	[ProductSK] [int] IDENTITY(1,1) NOT NULL,
	[ProductKey] [varchar](64) NOT NULL,
	[ProductNameFa] [nvarchar](256) NOT NULL,
	[ProductNameEn] [nvarchar](256) NULL,
	[ProductType] [nvarchar](128) NULL,
	[Packaging] [nvarchar](128) NULL,
	[Manufacturer] [nvarchar](256) NULL,
	[SourceList] [nvarchar](1024) NULL,
	[TrustScore] [decimal](5, 4) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ProductKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimProperty]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimProperty](
	[PropertySK] [int] IDENTITY(1,1) NOT NULL,
	[PropertyCanonicalKey] [varchar](64) NOT NULL,
	[CanonicalLabelFa] [nvarchar](256) NOT NULL,
	[CanonicalLabelEn] [nvarchar](256) NULL,
	[Category] [nvarchar](128) NULL,
	[SourceList] [nvarchar](1024) NULL,
	[CanonicalSource] [nvarchar](256) NULL,
	[TrustScore] [decimal](5, 4) NULL,
	[EffectiveFrom] [datetime2](7) NOT NULL,
	[EffectiveTo] [datetime2](7) NULL,
	[IsCurrent] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[PropertySK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[PropertyCanonicalKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimPropertyAlias]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimPropertyAlias](
	[AliasSK] [bigint] IDENTITY(1,1) NOT NULL,
	[PropertyCanonicalKey] [varchar](64) NOT NULL,
	[AliasLabelFa] [nvarchar](512) NULL,
	[AliasLabelEn] [nvarchar](512) NULL,
	[AliasType] [nvarchar](64) NULL,
	[SourceSystem] [nvarchar](128) NULL,
	[SourceRecordId] [nvarchar](256) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AliasSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimRegion]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimRegion](
	[RegionSK] [int] IDENTITY(1,1) NOT NULL,
	[RegionCanonicalKey] [varchar](64) NOT NULL,
	[Country] [nvarchar](128) NULL,
	[Province] [nvarchar](128) NULL,
	[District] [nvarchar](128) NULL,
	[Locality] [nvarchar](256) NULL,
	[GeoLat] [decimal](9, 6) NULL,
	[GeoLon] [decimal](9, 6) NULL,
	[SourceList] [nvarchar](1024) NULL,
	[TrustScore] [decimal](5, 4) NULL,
	[EffectiveFrom] [datetime2](7) NOT NULL,
	[EffectiveTo] [datetime2](7) NULL,
	[IsCurrent] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RegionSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[RegionCanonicalKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimSample]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimSample](
	[SampleSK] [bigint] IDENTITY(1,1) NOT NULL,
	[SampleKey] [varchar](64) NOT NULL,
	[SampleCode] [nvarchar](256) NULL,
	[CollectedAt] [datetime2](7) NULL,
	[Collector] [nvarchar](256) NULL,
	[StorageCondition] [nvarchar](256) NULL,
	[Notes] [nvarchar](1024) NULL,
PRIMARY KEY CLUSTERED 
(
	[SampleSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SampleKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimSamplePart]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimSamplePart](
	[SamplePartSK] [int] IDENTITY(1,1) NOT NULL,
	[SamplePartCanonicalKey] [varchar](64) NOT NULL,
	[LabelFa] [nvarchar](128) NOT NULL,
	[LabelEn] [nvarchar](128) NULL,
	[Description] [nvarchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[SamplePartSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SamplePartCanonicalKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimSource]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimSource](
	[SourceSK] [int] IDENTITY(1,1) NOT NULL,
	[SourceKey] [varchar](64) NOT NULL,
	[SourceName] [nvarchar](256) NOT NULL,
	[SourceType] [nvarchar](64) NULL,
	[SourceURI] [nvarchar](1024) NULL,
	[TrustLevel] [decimal](5, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[SourceSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SourceKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimStudy]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimStudy](
	[StudySK] [int] IDENTITY(1,1) NOT NULL,
	[StudyId] [varchar](128) NOT NULL,
	[Title] [nvarchar](512) NULL,
	[StudyType] [nvarchar](128) NULL,
	[Population] [nvarchar](256) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[SourceURI] [nvarchar](1024) NULL,
	[TrustScore] [decimal](5, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[StudySK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[StudyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimSynonym]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimSynonym](
	[SynonymSK] [int] IDENTITY(1,1) NOT NULL,
	[EntityType] [nvarchar](50) NOT NULL,
	[EntitySK] [int] NULL,
	[LabelFa] [nvarchar](512) NULL,
	[LabelEn] [nvarchar](512) NULL,
	[SynonymType] [nvarchar](50) NULL,
	[Language] [nvarchar](50) NULL,
	[ValidFrom] [date] NULL,
	[ValidTo] [date] NULL,
	[SourceSystem] [nvarchar](128) NULL,
	[SourceRecordId] [nvarchar](256) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SynonymSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimTaxonomy]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimTaxonomy](
	[TaxonomySK] [int] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NULL,
	[Kingdom] [nvarchar](100) NULL,
	[Phylum] [nvarchar](100) NULL,
	[Class] [nvarchar](100) NULL,
	[OrderRank] [nvarchar](100) NULL,
	[Family] [nvarchar](100) NULL,
	[Genus] [nvarchar](100) NULL,
	[Species] [nvarchar](100) NULL,
	[Subspecies] [nvarchar](100) NULL,
	[Cultivar] [nvarchar](100) NULL,
	[SynonymCount] [int] NULL,
	[TaxonomicStatus] [nvarchar](50) NULL,
	[TaxonomicAuthority] [nvarchar](200) NULL,
	[PublicationYear] [nvarchar](4) NULL,
	[IUCNCategory] [nvarchar](50) NULL,
	[CITESAppendix] [nvarchar](50) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TaxonomySK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimTime]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimTime](
	[TimeSK] [int] IDENTITY(1,1) NOT NULL,
	[DateKey] [int] NOT NULL,
	[FullDate] [date] NOT NULL,
	[Year] [int] NOT NULL,
	[Quarter] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Day] [int] NOT NULL,
	[WeekOfYear] [int] NULL,
	[IsHoliday] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[TimeSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[DimUsageMethod]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[DimUsageMethod](
	[UsageMethodSK] [int] IDENTITY(1,1) NOT NULL,
	[MethodBusinessKey] [nvarchar](100) NULL,
	[MethodName] [nvarchar](150) NULL,
	[ApplicationRoute] [nvarchar](100) NULL,
	[PreparationInstructions] [nvarchar](max) NULL,
	[DurationOfUse] [nvarchar](50) NULL,
	[Frequency] [nvarchar](50) NULL,
	[AdministrationConditions] [nvarchar](200) NULL,
	[Contraindications] [nvarchar](max) NULL,
	[RecommendedVehicle] [nvarchar](100) NULL,
	[TargetSymptoms] [nvarchar](200) NULL,
	[TraditionalUsage] [nvarchar](max) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UsageMethodSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dw].[FactAdverseEvent]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[FactAdverseEvent](
	[EventSK] [bigint] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NOT NULL,
	[PropertySK] [int] NULL,
	[StudySK] [int] NULL,
	[TimeSK] [int] NOT NULL,
	[EventDescription] [nvarchar](1024) NULL,
	[Severity] [nvarchar](64) NULL,
	[OccurrenceCount] [int] NULL,
	[SourceSK] [int] NULL,
	[LoadBatchId] [varchar](64) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[FactClinical]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[FactClinical](
	[ClinicalSK] [bigint] IDENTITY(1,1) NOT NULL,
	[StudySK] [int] NULL,
	[PlantSK] [int] NULL,
	[CompoundSK] [int] NULL,
	[TimeSK] [int] NOT NULL,
	[OutcomeMetric] [nvarchar](512) NULL,
	[OutcomeValue] [decimal](18, 6) NULL,
	[PopulationSize] [int] NULL,
	[ConfidenceScore] [decimal](5, 4) NULL,
	[SourceSK] [int] NULL,
	[LoadBatchId] [varchar](64) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ClinicalSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[FactCompoundConcentration]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[FactCompoundConcentration](
	[ConcentrationSK] [bigint] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NOT NULL,
	[CompoundSK] [int] NOT NULL,
	[SamplePartSK] [int] NULL,
	[RegionSK] [int] NULL,
	[TimeSK] [int] NOT NULL,
	[ConcentrationMgPerKg] [decimal](18, 6) NULL,
	[Method] [nvarchar](256) NULL,
	[ConfidenceScore] [decimal](5, 4) NULL,
	[SourceSK] [int] NULL,
	[LoadBatchId] [varchar](64) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ConcentrationSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[FactHarvest]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[FactHarvest](
	[HarvestSK] [bigint] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NOT NULL,
	[SamplePartSK] [int] NULL,
	[RegionSK] [int] NULL,
	[TimeSK] [int] NOT NULL,
	[TotalWeightKg] [decimal](12, 4) NULL,
	[MoisturePct] [decimal](6, 4) NULL,
	[SourceSK] [int] NULL,
	[LoadBatchId] [varchar](64) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[HarvestSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[FactLabResult]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[FactLabResult](
	[LabResultSK] [bigint] IDENTITY(1,1) NOT NULL,
	[SampleSK] [bigint] NULL,
	[PlantSK] [int] NULL,
	[CompoundSK] [int] NULL,
	[TimeSK] [int] NOT NULL,
	[ConcentrationMgPerKg] [decimal](18, 6) NULL,
	[Method] [nvarchar](128) NULL,
	[ConfidenceScore] [decimal](5, 4) NULL,
	[SourceSK] [int] NULL,
	[LoadBatchId] [varchar](64) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LabResultSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[FactMarketTransaction]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[FactMarketTransaction](
	[TransactionSK] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductSK] [int] NULL,
	[PlantSK] [int] NULL,
	[ChannelSK] [int] NULL,
	[RegionSK] [int] NULL,
	[TimeSK] [int] NOT NULL,
	[Quantity] [decimal](18, 4) NULL,
	[Revenue] [decimal](18, 4) NULL,
	[Currency] [nvarchar](16) NULL,
	[SourceSK] [int] NULL,
	[LoadBatchId] [varchar](64) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TransactionSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[FactPlantDistribution]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[FactPlantDistribution](
	[DistributionSK] [bigint] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NOT NULL,
	[RegionSK] [int] NOT NULL,
	[ClimateSK] [int] NULL,
	[TimeSK] [int] NOT NULL,
	[AbundanceScore] [decimal](10, 4) NULL,
	[Density] [decimal](10, 4) NULL,
	[SourceSK] [int] NULL,
	[LoadBatchId] [varchar](64) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DistributionSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[FactPlantUsage]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[FactPlantUsage](
	[UsageSK] [bigint] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NOT NULL,
	[PropertySK] [int] NULL,
	[SamplePartSK] [int] NULL,
	[TimeSK] [int] NOT NULL,
	[UsageMethod] [nvarchar](256) NULL,
	[Dosage] [nvarchar](256) NULL,
	[Frequency] [nvarchar](128) NULL,
	[SourceSK] [int] NULL,
	[LoadBatchId] [varchar](64) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UsageSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[FactPropertyObservation]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[FactPropertyObservation](
	[ObservationSK] [bigint] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NOT NULL,
	[PropertySK] [int] NOT NULL,
	[StudySK] [int] NULL,
	[TimeSK] [int] NOT NULL,
	[ObservationValue] [nvarchar](512) NULL,
	[ConfidenceScore] [decimal](5, 4) NULL,
	[SourceSK] [int] NULL,
	[LoadBatchId] [varchar](64) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ObservationSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[FactSales]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[FactSales](
	[SalesSK] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductSK] [int] NULL,
	[PlantSK] [int] NULL,
	[TimeSK] [int] NOT NULL,
	[ChannelSK] [int] NULL,
	[Quantity] [decimal](18, 4) NULL,
	[Revenue] [decimal](18, 4) NULL,
	[Currency] [nvarchar](16) NULL,
	[RegionSK] [int] NULL,
	[SourceSK] [int] NULL,
	[LoadBatchId] [varchar](64) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SalesSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[MediaFiles]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[MediaFiles](
	[MediaSK] [bigint] IDENTITY(1,1) NOT NULL,
	[EntityType] [nvarchar](64) NOT NULL,
	[EntityKey] [varchar](64) NOT NULL,
	[MediaURI] [nvarchar](2048) NOT NULL,
	[MediaType] [nvarchar](64) NULL,
	[Caption] [nvarchar](512) NULL,
	[SourceSystem] [nvarchar](128) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MediaSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [etl].[DimChangeLog]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [etl].[DimChangeLog](
	[ChangeId] [bigint] IDENTITY(1,1) NOT NULL,
	[DimName] [nvarchar](128) NOT NULL,
	[DimKey] [varchar](64) NOT NULL,
	[ChangeType] [nvarchar](64) NOT NULL,
	[OldValue] [nvarchar](max) NULL,
	[NewValue] [nvarchar](max) NULL,
	[ChangedBy] [nvarchar](128) NULL,
	[ChangedAt] [datetime2](7) NOT NULL,
	[LoadBatchId] [varchar](64) NULL,
PRIMARY KEY CLUSTERED 
(
	[ChangeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [etl].[ETLAudit]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [etl].[ETLAudit](
	[AuditId] [bigint] IDENTITY(1,1) NOT NULL,
	[LoadBatchId] [varchar](64) NULL,
	[StepName] [nvarchar](256) NULL,
	[Message] [nvarchar](2000) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [etl].[LoadBatch]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [etl].[LoadBatch](
	[LoadBatchId] [varchar](64) NOT NULL,
	[SourceSystem] [nvarchar](128) NULL,
	[StartedAt] [datetime2](7) NOT NULL,
	[FinishedAt] [datetime2](7) NULL,
	[Status] [nvarchar](32) NULL,
	[RowCountValue] [int] NULL,
	[Notes] [nvarchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[LoadBatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [staging].[RawPlantSource]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[RawPlantSource](
	[RawId] [bigint] IDENTITY(1,1) NOT NULL,
	[SourceSystem] [nvarchar](128) NULL,
	[SourceRecordId] [nvarchar](256) NULL,
	[NameFa] [nvarchar](512) NULL,
	[NameEn] [nvarchar](512) NULL,
	[ScientificName] [nvarchar](512) NULL,
	[AdditionalJson] [nvarchar](max) NULL,
	[RetrievedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RawId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [staging].[StgAliasMapping]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[StgAliasMapping](
	[MapId] [bigint] IDENTITY(1,1) NOT NULL,
	[SourceSystem] [nvarchar](128) NULL,
	[SourceRecordId] [nvarchar](256) NULL,
	[EntityType] [nvarchar](64) NULL,
	[AliasLabelFa] [nvarchar](512) NULL,
	[AliasLabelEn] [nvarchar](512) NULL,
	[CandidateCanonicalKey] [varchar](64) NULL,
	[MatchConfidence] [decimal](5, 4) NULL,
	[ResolvedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MapId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [staging].[StgCanonicalPlant]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[StgCanonicalPlant](
	[StgId] [bigint] IDENTITY(1,1) NOT NULL,
	[SourceSystem] [nvarchar](128) NULL,
	[SourceRecordId] [nvarchar](256) NULL,
	[PlantCanonicalKey] [varchar](64) NULL,
	[CanonicalNameFa] [nvarchar](256) NULL,
	[CanonicalNameEn] [nvarchar](256) NULL,
	[ScientificName] [nvarchar](256) NULL,
	[TrustScore] [decimal](5, 4) NULL,
	[ResolvedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StgId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_DimBiologicalTarget_PlantSK]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimBiologicalTarget_PlantSK] ON [dw].[DimBiologicalTarget]
(
	[PlantSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimCompound_CanonicalNameFa]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimCompound_CanonicalNameFa] ON [dw].[DimCompound]
(
	[CanonicalNameFa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimCompound_InChIKey]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimCompound_InChIKey] ON [dw].[DimCompound]
(
	[InChIKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimCompoundAlias_CompoundKey]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimCompoundAlias_CompoundKey] ON [dw].[DimCompoundAlias]
(
	[CompoundCanonicalKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_DimCultivation_PlantSK]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimCultivation_PlantSK] ON [dw].[DimCultivation]
(
	[PlantSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimDosageForm_FormName]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimDosageForm_FormName] ON [dw].[DimDosageForm]
(
	[FormName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_DimHabitat_PlantSK]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimHabitat_PlantSK] ON [dw].[DimHabitat]
(
	[PlantSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_DimPhytochemicalClass_PlantSK]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimPhytochemicalClass_PlantSK] ON [dw].[DimPhytochemicalClass]
(
	[PlantSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimPlant_CanonicalNameFa]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimPlant_CanonicalNameFa] ON [dw].[DimPlant]
(
	[CanonicalNameFa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimPlant_ScientificName]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimPlant_ScientificName] ON [dw].[DimPlant]
(
	[ScientificName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimPlantAlias_PlantKey]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimPlantAlias_PlantKey] ON [dw].[DimPlantAlias]
(
	[PlantCanonicalKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimProcessingMethod_ProcessName]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimProcessingMethod_ProcessName] ON [dw].[DimProcessingMethod]
(
	[ProcessName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimProduct_ProductNameFa]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimProduct_ProductNameFa] ON [dw].[DimProduct]
(
	[ProductNameFa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimProperty_LabelFa]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimProperty_LabelFa] ON [dw].[DimProperty]
(
	[CanonicalLabelFa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimPropertyAlias_PropertyKey]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimPropertyAlias_PropertyKey] ON [dw].[DimPropertyAlias]
(
	[PropertyCanonicalKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimSynonym_Entity]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimSynonym_Entity] ON [dw].[DimSynonym]
(
	[EntityType] ASC,
	[EntitySK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_DimTaxonomy_PlantSK]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimTaxonomy_PlantSK] ON [dw].[DimTaxonomy]
(
	[PlantSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimUsageMethod_MethodName]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_DimUsageMethod_MethodName] ON [dw].[DimUsageMethod]
(
	[MethodName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_FactClinical_Plant_Time]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_FactClinical_Plant_Time] ON [dw].[FactClinical]
(
	[PlantSK] ASC,
	[TimeSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_FactHarvest_Plant_Time]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_FactHarvest_Plant_Time] ON [dw].[FactHarvest]
(
	[PlantSK] ASC,
	[TimeSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_FactHarvest_Plant_Time_Include]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_FactHarvest_Plant_Time_Include] ON [dw].[FactHarvest]
(
	[PlantSK] ASC,
	[TimeSK] ASC
)
INCLUDE([TotalWeightKg],[MoisturePct],[SourceSK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_FactSales_Plant_Time]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_FactSales_Plant_Time] ON [dw].[FactSales]
(
	[PlantSK] ASC,
	[TimeSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_MediaFiles_Entity]    Script Date: 2026-05-04 20:21:19 ******/
CREATE NONCLUSTERED INDEX [IX_MediaFiles_Entity] ON [dw].[MediaFiles]
(
	[EntityType] ASC,
	[EntityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dw].[DimBiologicalTarget] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimClimate] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimCompound] ADD  DEFAULT ((0.0)) FOR [TrustScore]
GO
ALTER TABLE [dw].[DimCompound] ADD  DEFAULT (sysutcdatetime()) FOR [EffectiveFrom]
GO
ALTER TABLE [dw].[DimCompound] ADD  DEFAULT ((1)) FOR [IsCurrent]
GO
ALTER TABLE [dw].[DimCompound] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimCompoundAlias] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimCultivation] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimDosageForm] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimHabitat] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimPhytochemicalClass] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimPlant] ADD  DEFAULT ((0.0)) FOR [TrustScore]
GO
ALTER TABLE [dw].[DimPlant] ADD  DEFAULT (sysutcdatetime()) FOR [EffectiveFrom]
GO
ALTER TABLE [dw].[DimPlant] ADD  DEFAULT ((1)) FOR [IsCurrent]
GO
ALTER TABLE [dw].[DimPlant] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimPlantAlias] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimProcessingMethod] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimProduct] ADD  DEFAULT ((0.5)) FOR [TrustScore]
GO
ALTER TABLE [dw].[DimProduct] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimProperty] ADD  DEFAULT ((0.0)) FOR [TrustScore]
GO
ALTER TABLE [dw].[DimProperty] ADD  DEFAULT (sysutcdatetime()) FOR [EffectiveFrom]
GO
ALTER TABLE [dw].[DimProperty] ADD  DEFAULT ((1)) FOR [IsCurrent]
GO
ALTER TABLE [dw].[DimProperty] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimPropertyAlias] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimRegion] ADD  DEFAULT ((0.0)) FOR [TrustScore]
GO
ALTER TABLE [dw].[DimRegion] ADD  DEFAULT (sysutcdatetime()) FOR [EffectiveFrom]
GO
ALTER TABLE [dw].[DimRegion] ADD  DEFAULT ((1)) FOR [IsCurrent]
GO
ALTER TABLE [dw].[DimSource] ADD  DEFAULT ((0.5)) FOR [TrustLevel]
GO
ALTER TABLE [dw].[DimStudy] ADD  DEFAULT ((0.5)) FOR [TrustScore]
GO
ALTER TABLE [dw].[DimSynonym] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimTaxonomy] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[DimUsageMethod] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[FactAdverseEvent] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[FactClinical] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[FactCompoundConcentration] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[FactHarvest] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[FactLabResult] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[FactMarketTransaction] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[FactPlantDistribution] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[FactPlantUsage] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[FactPropertyObservation] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[FactSales] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dw].[MediaFiles] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [etl].[DimChangeLog] ADD  DEFAULT (sysutcdatetime()) FOR [ChangedAt]
GO
ALTER TABLE [etl].[ETLAudit] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [etl].[LoadBatch] ADD  DEFAULT (sysutcdatetime()) FOR [StartedAt]
GO
ALTER TABLE [staging].[RawPlantSource] ADD  DEFAULT (sysutcdatetime()) FOR [RetrievedAt]
GO
ALTER TABLE [staging].[StgAliasMapping] ADD  DEFAULT (sysutcdatetime()) FOR [ResolvedAt]
GO
ALTER TABLE [staging].[StgCanonicalPlant] ADD  DEFAULT (sysutcdatetime()) FOR [ResolvedAt]
GO
ALTER TABLE [dw].[DimBiologicalTarget]  WITH CHECK ADD  CONSTRAINT [FK_DimBiologicalTarget_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[DimBiologicalTarget] CHECK CONSTRAINT [FK_DimBiologicalTarget_Plant]
GO
ALTER TABLE [dw].[DimCultivation]  WITH CHECK ADD  CONSTRAINT [FK_DimCultivation_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[DimCultivation] CHECK CONSTRAINT [FK_DimCultivation_Plant]
GO
ALTER TABLE [dw].[DimHabitat]  WITH CHECK ADD  CONSTRAINT [FK_DimHabitat_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[DimHabitat] CHECK CONSTRAINT [FK_DimHabitat_Plant]
GO
ALTER TABLE [dw].[DimPhytochemicalClass]  WITH CHECK ADD  CONSTRAINT [FK_DimPhytochemicalClass_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[DimPhytochemicalClass] CHECK CONSTRAINT [FK_DimPhytochemicalClass_Plant]
GO
ALTER TABLE [dw].[DimTaxonomy]  WITH CHECK ADD  CONSTRAINT [FK_DimTaxonomy_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[DimTaxonomy] CHECK CONSTRAINT [FK_DimTaxonomy_Plant]
GO
ALTER TABLE [dw].[FactAdverseEvent]  WITH CHECK ADD  CONSTRAINT [FK_Adv_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[FactAdverseEvent] CHECK CONSTRAINT [FK_Adv_Plant]
GO
ALTER TABLE [dw].[FactAdverseEvent]  WITH CHECK ADD  CONSTRAINT [FK_Adv_Property] FOREIGN KEY([PropertySK])
REFERENCES [dw].[DimProperty] ([PropertySK])
GO
ALTER TABLE [dw].[FactAdverseEvent] CHECK CONSTRAINT [FK_Adv_Property]
GO
ALTER TABLE [dw].[FactAdverseEvent]  WITH CHECK ADD  CONSTRAINT [FK_Adv_Source] FOREIGN KEY([SourceSK])
REFERENCES [dw].[DimSource] ([SourceSK])
GO
ALTER TABLE [dw].[FactAdverseEvent] CHECK CONSTRAINT [FK_Adv_Source]
GO
ALTER TABLE [dw].[FactAdverseEvent]  WITH CHECK ADD  CONSTRAINT [FK_Adv_Study] FOREIGN KEY([StudySK])
REFERENCES [dw].[DimStudy] ([StudySK])
GO
ALTER TABLE [dw].[FactAdverseEvent] CHECK CONSTRAINT [FK_Adv_Study]
GO
ALTER TABLE [dw].[FactAdverseEvent]  WITH CHECK ADD  CONSTRAINT [FK_Adv_Time] FOREIGN KEY([TimeSK])
REFERENCES [dw].[DimTime] ([TimeSK])
GO
ALTER TABLE [dw].[FactAdverseEvent] CHECK CONSTRAINT [FK_Adv_Time]
GO
ALTER TABLE [dw].[FactClinical]  WITH CHECK ADD  CONSTRAINT [FK_FactClinical_Compound] FOREIGN KEY([CompoundSK])
REFERENCES [dw].[DimCompound] ([CompoundSK])
GO
ALTER TABLE [dw].[FactClinical] CHECK CONSTRAINT [FK_FactClinical_Compound]
GO
ALTER TABLE [dw].[FactClinical]  WITH CHECK ADD  CONSTRAINT [FK_FactClinical_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[FactClinical] CHECK CONSTRAINT [FK_FactClinical_Plant]
GO
ALTER TABLE [dw].[FactClinical]  WITH CHECK ADD  CONSTRAINT [FK_FactClinical_Source] FOREIGN KEY([SourceSK])
REFERENCES [dw].[DimSource] ([SourceSK])
GO
ALTER TABLE [dw].[FactClinical] CHECK CONSTRAINT [FK_FactClinical_Source]
GO
ALTER TABLE [dw].[FactClinical]  WITH CHECK ADD  CONSTRAINT [FK_FactClinical_Study] FOREIGN KEY([StudySK])
REFERENCES [dw].[DimStudy] ([StudySK])
GO
ALTER TABLE [dw].[FactClinical] CHECK CONSTRAINT [FK_FactClinical_Study]
GO
ALTER TABLE [dw].[FactClinical]  WITH CHECK ADD  CONSTRAINT [FK_FactClinical_Time] FOREIGN KEY([TimeSK])
REFERENCES [dw].[DimTime] ([TimeSK])
GO
ALTER TABLE [dw].[FactClinical] CHECK CONSTRAINT [FK_FactClinical_Time]
GO
ALTER TABLE [dw].[FactCompoundConcentration]  WITH CHECK ADD  CONSTRAINT [FK_Conc_Compound] FOREIGN KEY([CompoundSK])
REFERENCES [dw].[DimCompound] ([CompoundSK])
GO
ALTER TABLE [dw].[FactCompoundConcentration] CHECK CONSTRAINT [FK_Conc_Compound]
GO
ALTER TABLE [dw].[FactCompoundConcentration]  WITH CHECK ADD  CONSTRAINT [FK_Conc_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[FactCompoundConcentration] CHECK CONSTRAINT [FK_Conc_Plant]
GO
ALTER TABLE [dw].[FactCompoundConcentration]  WITH CHECK ADD  CONSTRAINT [FK_Conc_Region] FOREIGN KEY([RegionSK])
REFERENCES [dw].[DimRegion] ([RegionSK])
GO
ALTER TABLE [dw].[FactCompoundConcentration] CHECK CONSTRAINT [FK_Conc_Region]
GO
ALTER TABLE [dw].[FactCompoundConcentration]  WITH CHECK ADD  CONSTRAINT [FK_Conc_SamplePart] FOREIGN KEY([SamplePartSK])
REFERENCES [dw].[DimSamplePart] ([SamplePartSK])
GO
ALTER TABLE [dw].[FactCompoundConcentration] CHECK CONSTRAINT [FK_Conc_SamplePart]
GO
ALTER TABLE [dw].[FactCompoundConcentration]  WITH CHECK ADD  CONSTRAINT [FK_Conc_Source] FOREIGN KEY([SourceSK])
REFERENCES [dw].[DimSource] ([SourceSK])
GO
ALTER TABLE [dw].[FactCompoundConcentration] CHECK CONSTRAINT [FK_Conc_Source]
GO
ALTER TABLE [dw].[FactCompoundConcentration]  WITH CHECK ADD  CONSTRAINT [FK_Conc_Time] FOREIGN KEY([TimeSK])
REFERENCES [dw].[DimTime] ([TimeSK])
GO
ALTER TABLE [dw].[FactCompoundConcentration] CHECK CONSTRAINT [FK_Conc_Time]
GO
ALTER TABLE [dw].[FactHarvest]  WITH CHECK ADD  CONSTRAINT [FK_FactHarvest_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[FactHarvest] CHECK CONSTRAINT [FK_FactHarvest_Plant]
GO
ALTER TABLE [dw].[FactHarvest]  WITH CHECK ADD  CONSTRAINT [FK_FactHarvest_Region] FOREIGN KEY([RegionSK])
REFERENCES [dw].[DimRegion] ([RegionSK])
GO
ALTER TABLE [dw].[FactHarvest] CHECK CONSTRAINT [FK_FactHarvest_Region]
GO
ALTER TABLE [dw].[FactHarvest]  WITH CHECK ADD  CONSTRAINT [FK_FactHarvest_SamplePart] FOREIGN KEY([SamplePartSK])
REFERENCES [dw].[DimSamplePart] ([SamplePartSK])
GO
ALTER TABLE [dw].[FactHarvest] CHECK CONSTRAINT [FK_FactHarvest_SamplePart]
GO
ALTER TABLE [dw].[FactHarvest]  WITH CHECK ADD  CONSTRAINT [FK_FactHarvest_Source] FOREIGN KEY([SourceSK])
REFERENCES [dw].[DimSource] ([SourceSK])
GO
ALTER TABLE [dw].[FactHarvest] CHECK CONSTRAINT [FK_FactHarvest_Source]
GO
ALTER TABLE [dw].[FactHarvest]  WITH CHECK ADD  CONSTRAINT [FK_FactHarvest_Time] FOREIGN KEY([TimeSK])
REFERENCES [dw].[DimTime] ([TimeSK])
GO
ALTER TABLE [dw].[FactHarvest] CHECK CONSTRAINT [FK_FactHarvest_Time]
GO
ALTER TABLE [dw].[FactLabResult]  WITH CHECK ADD  CONSTRAINT [FK_FactLab_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[FactLabResult] CHECK CONSTRAINT [FK_FactLab_Plant]
GO
ALTER TABLE [dw].[FactLabResult]  WITH CHECK ADD  CONSTRAINT [FK_FactLab_Source] FOREIGN KEY([SourceSK])
REFERENCES [dw].[DimSource] ([SourceSK])
GO
ALTER TABLE [dw].[FactLabResult] CHECK CONSTRAINT [FK_FactLab_Source]
GO
ALTER TABLE [dw].[FactLabResult]  WITH CHECK ADD  CONSTRAINT [FK_FactLab_Time] FOREIGN KEY([TimeSK])
REFERENCES [dw].[DimTime] ([TimeSK])
GO
ALTER TABLE [dw].[FactLabResult] CHECK CONSTRAINT [FK_FactLab_Time]
GO
ALTER TABLE [dw].[FactMarketTransaction]  WITH CHECK ADD  CONSTRAINT [FK_Market_Channel] FOREIGN KEY([ChannelSK])
REFERENCES [dw].[DimChannel] ([ChannelSK])
GO
ALTER TABLE [dw].[FactMarketTransaction] CHECK CONSTRAINT [FK_Market_Channel]
GO
ALTER TABLE [dw].[FactMarketTransaction]  WITH CHECK ADD  CONSTRAINT [FK_Market_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[FactMarketTransaction] CHECK CONSTRAINT [FK_Market_Plant]
GO
ALTER TABLE [dw].[FactMarketTransaction]  WITH CHECK ADD  CONSTRAINT [FK_Market_Product] FOREIGN KEY([ProductSK])
REFERENCES [dw].[DimProduct] ([ProductSK])
GO
ALTER TABLE [dw].[FactMarketTransaction] CHECK CONSTRAINT [FK_Market_Product]
GO
ALTER TABLE [dw].[FactMarketTransaction]  WITH CHECK ADD  CONSTRAINT [FK_Market_Region] FOREIGN KEY([RegionSK])
REFERENCES [dw].[DimRegion] ([RegionSK])
GO
ALTER TABLE [dw].[FactMarketTransaction] CHECK CONSTRAINT [FK_Market_Region]
GO
ALTER TABLE [dw].[FactMarketTransaction]  WITH CHECK ADD  CONSTRAINT [FK_Market_Source] FOREIGN KEY([SourceSK])
REFERENCES [dw].[DimSource] ([SourceSK])
GO
ALTER TABLE [dw].[FactMarketTransaction] CHECK CONSTRAINT [FK_Market_Source]
GO
ALTER TABLE [dw].[FactMarketTransaction]  WITH CHECK ADD  CONSTRAINT [FK_Market_Time] FOREIGN KEY([TimeSK])
REFERENCES [dw].[DimTime] ([TimeSK])
GO
ALTER TABLE [dw].[FactMarketTransaction] CHECK CONSTRAINT [FK_Market_Time]
GO
ALTER TABLE [dw].[FactPlantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_Dist_Climate] FOREIGN KEY([ClimateSK])
REFERENCES [dw].[DimClimate] ([ClimateSK])
GO
ALTER TABLE [dw].[FactPlantDistribution] CHECK CONSTRAINT [FK_Dist_Climate]
GO
ALTER TABLE [dw].[FactPlantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_Dist_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[FactPlantDistribution] CHECK CONSTRAINT [FK_Dist_Plant]
GO
ALTER TABLE [dw].[FactPlantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_Dist_Region] FOREIGN KEY([RegionSK])
REFERENCES [dw].[DimRegion] ([RegionSK])
GO
ALTER TABLE [dw].[FactPlantDistribution] CHECK CONSTRAINT [FK_Dist_Region]
GO
ALTER TABLE [dw].[FactPlantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_Dist_Source] FOREIGN KEY([SourceSK])
REFERENCES [dw].[DimSource] ([SourceSK])
GO
ALTER TABLE [dw].[FactPlantDistribution] CHECK CONSTRAINT [FK_Dist_Source]
GO
ALTER TABLE [dw].[FactPlantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_Dist_Time] FOREIGN KEY([TimeSK])
REFERENCES [dw].[DimTime] ([TimeSK])
GO
ALTER TABLE [dw].[FactPlantDistribution] CHECK CONSTRAINT [FK_Dist_Time]
GO
ALTER TABLE [dw].[FactPlantUsage]  WITH CHECK ADD  CONSTRAINT [FK_Usage_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[FactPlantUsage] CHECK CONSTRAINT [FK_Usage_Plant]
GO
ALTER TABLE [dw].[FactPlantUsage]  WITH CHECK ADD  CONSTRAINT [FK_Usage_Property] FOREIGN KEY([PropertySK])
REFERENCES [dw].[DimProperty] ([PropertySK])
GO
ALTER TABLE [dw].[FactPlantUsage] CHECK CONSTRAINT [FK_Usage_Property]
GO
ALTER TABLE [dw].[FactPlantUsage]  WITH CHECK ADD  CONSTRAINT [FK_Usage_SamplePart] FOREIGN KEY([SamplePartSK])
REFERENCES [dw].[DimSamplePart] ([SamplePartSK])
GO
ALTER TABLE [dw].[FactPlantUsage] CHECK CONSTRAINT [FK_Usage_SamplePart]
GO
ALTER TABLE [dw].[FactPlantUsage]  WITH CHECK ADD  CONSTRAINT [FK_Usage_Source] FOREIGN KEY([SourceSK])
REFERENCES [dw].[DimSource] ([SourceSK])
GO
ALTER TABLE [dw].[FactPlantUsage] CHECK CONSTRAINT [FK_Usage_Source]
GO
ALTER TABLE [dw].[FactPlantUsage]  WITH CHECK ADD  CONSTRAINT [FK_Usage_Time] FOREIGN KEY([TimeSK])
REFERENCES [dw].[DimTime] ([TimeSK])
GO
ALTER TABLE [dw].[FactPlantUsage] CHECK CONSTRAINT [FK_Usage_Time]
GO
ALTER TABLE [dw].[FactPropertyObservation]  WITH CHECK ADD  CONSTRAINT [FK_Obs_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[FactPropertyObservation] CHECK CONSTRAINT [FK_Obs_Plant]
GO
ALTER TABLE [dw].[FactPropertyObservation]  WITH CHECK ADD  CONSTRAINT [FK_Obs_Property] FOREIGN KEY([PropertySK])
REFERENCES [dw].[DimProperty] ([PropertySK])
GO
ALTER TABLE [dw].[FactPropertyObservation] CHECK CONSTRAINT [FK_Obs_Property]
GO
ALTER TABLE [dw].[FactPropertyObservation]  WITH CHECK ADD  CONSTRAINT [FK_Obs_Source] FOREIGN KEY([SourceSK])
REFERENCES [dw].[DimSource] ([SourceSK])
GO
ALTER TABLE [dw].[FactPropertyObservation] CHECK CONSTRAINT [FK_Obs_Source]
GO
ALTER TABLE [dw].[FactPropertyObservation]  WITH CHECK ADD  CONSTRAINT [FK_Obs_Study] FOREIGN KEY([StudySK])
REFERENCES [dw].[DimStudy] ([StudySK])
GO
ALTER TABLE [dw].[FactPropertyObservation] CHECK CONSTRAINT [FK_Obs_Study]
GO
ALTER TABLE [dw].[FactPropertyObservation]  WITH CHECK ADD  CONSTRAINT [FK_Obs_Time] FOREIGN KEY([TimeSK])
REFERENCES [dw].[DimTime] ([TimeSK])
GO
ALTER TABLE [dw].[FactPropertyObservation] CHECK CONSTRAINT [FK_Obs_Time]
GO
ALTER TABLE [dw].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_Channel] FOREIGN KEY([ChannelSK])
REFERENCES [dw].[DimChannel] ([ChannelSK])
GO
ALTER TABLE [dw].[FactSales] CHECK CONSTRAINT [FK_FactSales_Channel]
GO
ALTER TABLE [dw].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_Plant] FOREIGN KEY([PlantSK])
REFERENCES [dw].[DimPlant] ([PlantSK])
GO
ALTER TABLE [dw].[FactSales] CHECK CONSTRAINT [FK_FactSales_Plant]
GO
ALTER TABLE [dw].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_Product] FOREIGN KEY([ProductSK])
REFERENCES [dw].[DimProduct] ([ProductSK])
GO
ALTER TABLE [dw].[FactSales] CHECK CONSTRAINT [FK_FactSales_Product]
GO
ALTER TABLE [dw].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_Region] FOREIGN KEY([RegionSK])
REFERENCES [dw].[DimRegion] ([RegionSK])
GO
ALTER TABLE [dw].[FactSales] CHECK CONSTRAINT [FK_FactSales_Region]
GO
ALTER TABLE [dw].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_Source] FOREIGN KEY([SourceSK])
REFERENCES [dw].[DimSource] ([SourceSK])
GO
ALTER TABLE [dw].[FactSales] CHECK CONSTRAINT [FK_FactSales_Source]
GO
ALTER TABLE [dw].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_Time] FOREIGN KEY([TimeSK])
REFERENCES [dw].[DimTime] ([TimeSK])
GO
ALTER TABLE [dw].[FactSales] CHECK CONSTRAINT [FK_FactSales_Time]
GO
/****** Object:  StoredProcedure [etl].[usp_SCD2_Load_DimProperty]    Script Date: 2026-05-04 20:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- پروسیجر عمومی نمونه برای SCD2 روی DimProperty (الگو؛ برای سایر ابعاد مشابه قابل کپی است)
CREATE PROCEDURE [etl].[usp_SCD2_Load_DimProperty]
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        -- فرض: staging.StgProperty (source) با ستون‌های PropertyCanonicalKey, CanonicalLabelFa, CanonicalLabelEn, TrustScore
        MERGE INTO dw.DimProperty AS target
        USING (
            SELECT DISTINCT PropertyCanonicalKey, CanonicalLabelFa, CanonicalLabelEn, TrustScore, SourceSystem = 'staging' FROM staging.StgProperty
        ) AS src
        ON target.PropertyCanonicalKey = src.PropertyCanonicalKey AND target.IsCurrent = 1
        WHEN MATCHED AND (
            ISNULL(target.CanonicalLabelFa,'') <> ISNULL(src.CanonicalLabelFa,'')
            OR ISNULL(target.TrustScore,0) <> ISNULL(src.TrustScore,0)
        )
        THEN
            -- غیرفعال‌سازی رکورد جاری
            UPDATE SET target.IsCurrent = 0, target.EffectiveTo = SYSUTCDATETIME(), target.UpdatedAt = SYSUTCDATETIME()
        WHEN NOT MATCHED BY TARGET
        THEN
            INSERT (PropertyCanonicalKey, CanonicalLabelFa, CanonicalLabelEn, TrustScore, EffectiveFrom, IsCurrent, CreatedAt)
            VALUES (src.PropertyCanonicalKey, src.CanonicalLabelFa, src.CanonicalLabelEn, src.TrustScore, SYSUTCDATETIME(), 1, SYSUTCDATETIME());

        -- درج رکورد جدید برای مواردی که تغییر کرده‌اند
        INSERT INTO dw.DimProperty (PropertyCanonicalKey, CanonicalLabelFa, CanonicalLabelEn, TrustScore, EffectiveFrom, IsCurrent, CreatedAt)
        SELECT src.PropertyCanonicalKey, src.CanonicalLabelFa, src.CanonicalLabelEn, src.TrustScore, SYSUTCDATETIME(), 1, SYSUTCDATETIME()
        FROM staging.StgProperty src
        LEFT JOIN dw.DimProperty dp ON dp.PropertyCanonicalKey = src.PropertyCanonicalKey AND dp.IsCurrent = 1
        WHERE dp.PropertySK IS NULL OR (ISNULL(dp.CanonicalLabelFa,'') <> ISNULL(src.CanonicalLabelFa,'') OR ISNULL(dp.TrustScore,0) <> ISNULL(src.TrustScore,0));

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END
GO
USE [master]
GO
ALTER DATABASE [HerbalDW] SET  READ_WRITE 
GO
