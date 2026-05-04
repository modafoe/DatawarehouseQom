CREATE DATABASE [MedicinalPlantsDW];
GO

-- تنظیم Recovery model پیشنهادی برای Data Warehouse
ALTER DATABASE [MedicinalPlantsDW] SET RECOVERY SIMPLE;
GO

ALTER DATABASE [MedicinalPlantsDW]
ADD FILEGROUP [FSImageFG] CONTAINS FILESTREAM;
GO

ALTER DATABASE [MedicinalPlantsDW]
ADD FILE (
    NAME = N'FSImageStore',
    FILENAME = N'C:\MedicinalPlants'
) TO FILEGROUP [FSImageFG];
GO
---------------------------



USE [MedicinalPlantsDW];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- 1. جدول DimPlant
CREATE TABLE [dbo].[DimPlant](
    -- کلید جایگزین (Surrogate Key)
    SurrogateKey        UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای هر گیاه

    -- ویژگی‌های اختصاصی
    PlantBusinessKey    NVARCHAR(100)      NULL,    -- کلید کسب‌وکاری (مثلاً کد منبع یا شناسه خارجی)
    PlantName           NVARCHAR(255)      NULL,    -- نام رایج گیاه
    ScientificName      NVARCHAR(255)      NULL,    -- نام علمی گیاه
    Family              NVARCHAR(150)      NULL,    -- خانواده گیاه‌شناسی
    CommonName          NVARCHAR(150)      NULL,    -- نام‌های عمومی/محلی
    Genus               NVARCHAR(100)      NULL,    -- جنس گیاه
    Species             NVARCHAR(100)      NULL,    -- گونه گیاه
    Description         NVARCHAR(MAX)      NULL,    -- توضیحات کلی درباره گیاه
    UsagePart           NVARCHAR(100)      NULL,    -- بخش مورد استفاده (برگ، ریشه، گل و ...)
    LifeCycle           NVARCHAR(50)       NULL,    -- چرخه زندگی (یک‌ساله، چندساله و ...)
    GrowthForm          NVARCHAR(50)       NULL,    -- فرم رشد (درختچه، علفی و ...)
    NativeRegion        NVARCHAR(150)      NULL,    -- منطقه بومی گیاه

    -- ویژگی‌های مشترک
    SourceSystem        NVARCHAR(100)      NULL,    -- نام سیستم/منبع استخراج داده
    SourceURL           NVARCHAR(MAX)      NULL,    -- آدرس اینترنتی منبع
    SourceType          NVARCHAR(100)      NULL,    -- نوع منبع (وب، مقاله، کتاب و ...)
    ExtractionDate      DATETIME           NULL,    -- تاریخ استخراج داده
    LoadDate            DATETIME           NULL,    -- تاریخ بارگذاری در دیتاورهاوس
    EffectiveDate       DATETIME           NULL,    -- تاریخ شروع اعتبار رکورد
    ExpiryDate          DATETIME           NULL,    -- تاریخ پایان اعتبار رکورد
    IsActive            BIT                NULL,    -- وضعیت فعال/غیرفعال بودن رکورد
    RowVersion          ROWVERSION         NOT NULL,-- نسخه ردیف برای کنترل تغییرات
    LoadBatchID         UNIQUEIDENTIFIER   NULL,    -- شناسه دسته بارگذاری
    CreatedBy           NVARCHAR(50)       NULL,    -- کاربر/فرآیند ایجادکننده رکورد
    UpdatedBy           NVARCHAR(50)       NULL,    -- کاربر/فرآیند آخرین به‌روزرسانی
    ChangeType          NVARCHAR(20)       NULL,    -- نوع تغییر (Insert/Update/Delete)
    DataQualityStatus   NVARCHAR(50)       NULL,    -- وضعیت کیفیت داده
    ConfidenceScore     FLOAT              NULL,    -- امتیاز اطمینان داده
    HashKey             NVARCHAR(200)      NULL,    -- هش رکورد برای تشخیص تغییرات
    PartitionKey        NVARCHAR(50)       NULL,    -- کلید پارتیشن‌بندی
    Comments            NVARCHAR(MAX)      NULL,    -- توضیحات یا یادداشت‌های اضافی

    CONSTRAINT PK_DimPlant PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

-- 2. جدول DimTaxonomy
CREATE TABLE [dbo].[DimTaxonomy](
    -- کلید جایگزین
    SurrogateKey        UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد طبقه‌بندی

    -- کلید کسب‌وکاری برای ارتباط با DimPlant
    PlantBusinessKey    NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    Kingdom             NVARCHAR(100)      NULL,       -- سلسله
    Phylum              NVARCHAR(100)      NULL,       -- شاخه
    Class               NVARCHAR(100)      NULL,       -- رده
    OrderRank           NVARCHAR(100)      NULL,       -- راسته
    Family              NVARCHAR(100)      NULL,       -- خانواده
    Genus               NVARCHAR(100)      NULL,       -- جنس
    Species             NVARCHAR(100)      NULL,       -- گونه
    Subspecies          NVARCHAR(100)      NULL,       -- زیرگونه
    Cultivar            NVARCHAR(100)      NULL,       -- رقم/کولتوار
    SynonymCount        INT                NULL,       -- تعداد نام‌های مترادف
    TaxonomicStatus     NVARCHAR(50)       NULL,       -- وضعیت طبقه‌بندی (معتبر/نامعتبر)
    TaxonomicAuthority  NVARCHAR(200)      NULL,       -- مرجع علمی طبقه‌بندی
    PublicationYear     NVARCHAR(4)        NULL,       -- سال انتشار مرجع
    IUCNCategory        NVARCHAR(50)       NULL,       -- دسته‌بندی حفاظتی IUCN
    CITESAppendix       NVARCHAR(50)       NULL,       -- ضمیمه CITES (حفاظت بین‌المللی)

    CONSTRAINT PK_DimTaxonomy PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

-- 3. جدول DimSynonym
CREATE TABLE [dbo].[DimSynonym](
    -- کلید جایگزین
    SurrogateKey        UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد مترادف

    -- کلید کسب‌وکاری برای ارتباط با DimPlant
    PlantBusinessKey    NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    Synonym             NVARCHAR(255)      NULL,       -- نام مترادف
    SynonymType         NVARCHAR(50)       NULL,       -- نوع مترادف (علمی، محلی، تاریخی)
    Language            NVARCHAR(50)       NULL,       -- زبان مترادف
    ValidFrom           DATETIME           NULL,       -- تاریخ شروع اعتبار
    ValidTo             DATETIME           NULL,       -- تاریخ پایان اعتبار
    Notes               NVARCHAR(500)      NULL,       -- توضیحات اضافی

    CONSTRAINT PK_DimSynonym PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------
-- 4. جدول DimGeography: پراکنش جغرافیایی و محل رشد گیاه
CREATE TABLE [dbo].[DimGeography](
    -- کلید جایگزین
    SurrogateKey           UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد جغرافیا

    -- کلید کسب‌وکاری برای لینک به DimPlant
    PlantBusinessKey       NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    CountryDistribution    NVARCHAR(200)      NULL,       -- کشورهایی که گیاه در آن‌ها پراکنش دارد
    RegionDistribution     NVARCHAR(200)      NULL,       -- نواحی/استان‌های پراکنش
    Continent              NVARCHAR(100)      NULL,       -- قاره محل رشد
    LatitudeMin            NVARCHAR(50)       NULL,       -- حداقل عرض جغرافیایی
    LatitudeMax            NVARCHAR(50)       NULL,       -- حداکثر عرض جغرافیایی
    LongitudeMin           NVARCHAR(50)       NULL,       -- حداقل طول جغرافیایی
    LongitudeMax           NVARCHAR(50)       NULL,       -- حداکثر طول جغرافیایی
    ElevationMin           NVARCHAR(50)       NULL,       -- حداقل ارتفاع از سطح دریا
    ElevationMax           NVARCHAR(50)       NULL,       -- حداکثر ارتفاع از سطح دریا
    AvgTemperature         NVARCHAR(50)       NULL,       -- میانگین دما
    TemperatureRange       NVARCHAR(50)       NULL,       -- بازه دمایی
    AvgPrecipitation       NVARCHAR(50)       NULL,       -- میانگین بارش
    PrecipitationRange     NVARCHAR(50)       NULL,       -- بازه بارش
    Biome                  NVARCHAR(100)      NULL,       -- بوم‌سازگان (جنگل، بیابان و ...)
    WetlandIndicator       NVARCHAR(50)       NULL,       -- شاخص تالابی بودن
    SoilMoistureLevel      NVARCHAR(50)       NULL,       -- سطح رطوبت خاک

    
    CONSTRAINT PK_DimGeography PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- 5. جدول DimClimate: ویژگی‌های اقلیمی محل رشد
CREATE TABLE [dbo].[DimClimate](
    -- کلید جایگزین
    SurrogateKey           UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد اقلیم

    -- کلید کسب‌وکاری برای لینک به DimPlant
    PlantBusinessKey       NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    ClimateType            NVARCHAR(100)      NULL,       -- نوع اقلیم (مدیترانه‌ای، بیابانی و ...)
    AvgAnnualTemp          NVARCHAR(50)       NULL,       -- میانگین دمای سالانه
    TempSeasonality        NVARCHAR(50)       NULL,       -- تغییرات فصلی دما
    AvgAnnualRainfall      NVARCHAR(50)       NULL,       -- میانگین بارش سالانه
    RainfallPattern        NVARCHAR(100)      NULL,       -- الگوی بارش (فصلی، یکنواخت و ...)
    HumidityRange          NVARCHAR(50)       NULL,       -- بازه رطوبت
    FrostDaysPerYear       NVARCHAR(50)       NULL,       -- تعداد روزهای یخبندان در سال
    DroughtFrequency       NVARCHAR(50)       NULL,       -- فراوانی خشکسالی
    AridityIndex           NVARCHAR(50)       NULL,       -- شاخص خشکی
    GrowingDegreeDays      NVARCHAR(50)       NULL,       -- مجموع درجه‌روز رشد
    WindExposure           NVARCHAR(50)       NULL,       -- میزان مواجهه با باد
    SolarRadiationLevel    NVARCHAR(50)       NULL,       -- سطح تابش خورشید
    MonsoonInfluence       NVARCHAR(50)       NULL,       -- تأثیر موسمی
    SeasonalVariationDesc  NVARCHAR(MAX)      NULL,       -- توضیحات تغییرات فصلی

    CONSTRAINT PK_DimClimate PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- 6. جدول DimSoil: ویژگی‌های خاک محل رشد
CREATE TABLE [dbo].[DimSoil](
    -- کلید جایگزین
    SurrogateKey           UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد خاک

    -- کلید کسب‌وکاری برای لینک به DimPlant
    PlantBusinessKey       NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    SoilType               NVARCHAR(100)      NULL,       -- نوع خاک (رسی، شنی و ...)
    SoilTexture            NVARCHAR(100)      NULL,       -- بافت خاک
    pHRange                NVARCHAR(50)       NULL,       -- بازه pH خاک
    OrganicMatterContent   NVARCHAR(50)       NULL,       -- میزان ماده آلی
    DrainageClassification NVARCHAR(50)       NULL,       -- طبقه‌بندی زهکشی
    SalinityLevel          NVARCHAR(50)       NULL,       -- سطح شوری
    CationExchangeCapacity NVARCHAR(50)       NULL,       -- ظرفیت تبادل کاتیونی
    BulkDensity            NVARCHAR(50)       NULL,       -- چگالی ظاهری خاک
    WaterHoldingCapacity   NVARCHAR(50)       NULL,       -- ظرفیت نگهداری آب
    NutrientStatusN        NVARCHAR(50)       NULL,       -- وضعیت نیتروژن
    NutrientStatusP        NVARCHAR(50)       NULL,       -- وضعیت فسفر
    NutrientStatusK        NVARCHAR(50)       NULL,       -- وضعیت پتاسیم
    SoilClassificationSys  NVARCHAR(100)      NULL,       -- سیستم طبقه‌بندی خاک
    SoilColor              NVARCHAR(50)       NULL,       -- رنگ خاک
    RockFragmentPercent    NVARCHAR(50)       NULL,       -- درصد قطعات سنگی

    CONSTRAINT PK_DimSoil PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------
USE [MedicinalPlantsDW];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

--------------------------------------------------------------------------------
-- 7. جدول DimHabitat: ویژگی‌های زیستگاه
CREATE TABLE [dbo].[DimHabitat](
    -- Surrogate Key
    SurrogateKey           UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد زیستگاه

    -- کلید کسب‌وکاری به DimPlant
    PlantBusinessKey       NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    HabitatType            NVARCHAR(100)      NULL,  -- نوع زیستگاه (مثلاً جنگل، علفزار)
    AltitudeRange          NVARCHAR(50)       NULL,  -- بازه ارتفاعی زیستگاه
    SoilMoistureLevel      NVARCHAR(50)       NULL,  -- سطح رطوبت خاک
    ShadeTolerance         NVARCHAR(50)       NULL,  -- میزان تحمل سایه
    WaterRequirement       NVARCHAR(50)       NULL,  -- نیاز آبی گیاه در زیستگاه
    pHPreference           NVARCHAR(50)       NULL,  -- بازه pH مطلوب
    AssociatedVegetation   NVARCHAR(200)      NULL,  -- گونه‌های گیاهی همراه
    SalinityTolerance      NVARCHAR(50)       NULL,  -- میزان تحمل شوری
    DisturbanceTolerance   NVARCHAR(50)       NULL,  -- تحمل اختلالات محیطی
    TypicalCommunity       NVARCHAR(200)      NULL,  -- اجتماع گیاهی معمول
    HabitatDescription     NVARCHAR(MAX)      NULL,  -- توضیح کامل زیستگاه


    CONSTRAINT PK_DimHabitat PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- 8. جدول DimCultivation: ویژگی‌های کشت و پرورش
CREATE TABLE [dbo].[DimCultivation](
    SurrogateKey           UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد کشت
    PlantBusinessKey       NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    PropagationMethod      NVARCHAR(100)      NULL,  -- روش تکثیر (بذر، قلمه و ...)
    SeedGerminationRate    NVARCHAR(50)       NULL,  -- درصد جوانه‌زنی بذر
    OptimalSowingTime      NVARCHAR(100)      NULL,  -- زمان مناسب کاشت
    HarvestTime            NVARCHAR(100)      NULL,  -- زمان برداشت
    YieldPerHectare        NVARCHAR(50)       NULL,  -- عملکرد در هکتار
    CultivationSeason      NVARCHAR(100)      NULL,  -- فصل کشت
    FertilizerRequirements NVARCHAR(MAX)      NULL,  -- نیاز به کود
    PesticideUsage         NVARCHAR(MAX)      NULL,  -- مصرف سموم
    IrrigationNeeds        NVARCHAR(50)       NULL,  -- نیاز آبیاری
    PlantSpacing           NVARCHAR(50)       NULL,  -- فاصله کاشت
    GrowthDuration         NVARCHAR(50)       NULL,  -- مدت زمان رشد
    SoilPreparation        NVARCHAR(MAX)      NULL,  -- آماده‌سازی خاک
    PostHarvestHandling    NVARCHAR(MAX)      NULL,  -- عملیات پس از برداشت
    ManagedEnvironment     NVARCHAR(100)      NULL,  -- محیط کنترل‌شده (گلخانه و ...)


    CONSTRAINT PK_DimCultivation PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- 9. جدول DimChemicalCompound: مشخصات ترکیبات شیمیایی
CREATE TABLE [dbo].[DimChemicalCompound](
    SurrogateKey           UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد ترکیب
    PlantBusinessKey       NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    CompoundBusinessKey    NVARCHAR(100)      NULL,  -- شناسه کسب‌وکاری ترکیب
    CompoundName           NVARCHAR(255)      NULL,  -- نام ترکیب
    IUPACName              NVARCHAR(255)      NULL,  -- نام IUPAC
    ChemicalFormula        NVARCHAR(100)      NULL,  -- فرمول شیمیایی
    MolecularWeight        NVARCHAR(50)       NULL,  -- وزن مولکولی
    CASNumber              NVARCHAR(50)       NULL,  -- شماره CAS
    SMILES                 NVARCHAR(200)      NULL,  -- نمایش SMILES
    InChIKey               NVARCHAR(200)      NULL,  -- کلید InChI
    CompoundClass          NVARCHAR(100)      NULL,  -- دسته ترکیب (آلکالوئید، فلاونوئید و ...)
    Bioactivity            NVARCHAR(MAX)      NULL,  -- فعالیت زیستی ترکیب
    Solubility             NVARCHAR(100)      NULL,  -- حلالیت
    MeltingPoint           NVARCHAR(50)       NULL,  -- نقطه ذوب
    BoilingPoint           NVARCHAR(50)       NULL,  -- نقطه جوش
    Density                NVARCHAR(50)       NULL,  -- چگالی
    LogP                   NVARCHAR(50)       NULL,  -- ضریب LogP
    pKa                    NVARCHAR(50)       NULL,  -- مقدار pKa
    AnalyticalMethod       NVARCHAR(200)      NULL,  -- روش آنالیز ترکیب

    

    CONSTRAINT PK_DimChemicalCompound PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- 10. جدول DimPhytochemicalClass: طبقه‌بندی شیمیایی
CREATE TABLE [dbo].[DimPhytochemicalClass](
    -- کلید جایگزین
    SurrogateKey                UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد کلاس شیمیایی

    -- کلید کسب‌وکاری برای لینک به DimPlant
    PlantBusinessKey            NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    ClassBusinessKey            NVARCHAR(100)      NULL,    -- شناسه کسب‌وکاری کلاس
    ClassName                   NVARCHAR(150)      NULL,    -- نام کلاس فیتوشیمیایی
    ClassLevel                  NVARCHAR(50)       NULL,    -- سطح طبقه‌بندی (اصلی، فرعی و ...)
    ParentClass                 NVARCHAR(150)      NULL,    -- کلاس والد
    SubClass                    NVARCHAR(150)      NULL,    -- زیرکلاس
    Definition                  NVARCHAR(MAX)      NULL,    -- تعریف کلاس
    StructuralCharacteristics   NVARCHAR(MAX)      NULL,    -- ویژگی‌های ساختاری
    CommonExamples              NVARCHAR(MAX)      NULL,    -- نمونه‌های رایج
    Occurrence                  NVARCHAR(200)      NULL,    -- محل وقوع/وجود
    ExtractionSolvent           NVARCHAR(100)      NULL,    -- حلال استخراج
    ConcentrationRange          NVARCHAR(100)      NULL,    -- بازه غلظت
    BioactivityProfile          NVARCHAR(MAX)      NULL,    -- پروفایل فعالیت زیستی
    AnalyticalMethods           NVARCHAR(200)      NULL,    -- روش‌های آنالیز
    RegulatoryStatus            NVARCHAR(100)      NULL,    -- وضعیت قانونی/مقرراتی

    

    CONSTRAINT PK_DimPhytochemicalClass PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- 11. جدول DimMedicinalProperty: خواص دارویی
CREATE TABLE [dbo].[DimMedicinalProperty](
    -- کلید جایگزین
    SurrogateKey                UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد خاصیت دارویی

    -- کلید کسب‌وکاری برای لینک به DimPlant
    PlantBusinessKey            NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    PropertyBusinessKey         NVARCHAR(100)      NULL,    -- شناسه کسب‌وکاری خاصیت
    PropertyName                NVARCHAR(150)      NULL,    -- نام خاصیت دارویی
    PropertyCategory            NVARCHAR(100)      NULL,    -- دسته‌بندی خاصیت (مثلاً ضدالتهاب)
    MechanismOfAction           NVARCHAR(MAX)      NULL,    -- مکانیسم اثر
    OnsetOfAction               NVARCHAR(50)       NULL,    -- زمان شروع اثر
    DurationOfAction            NVARCHAR(50)       NULL,    -- مدت اثر
    TherapeuticDoseRange        NVARCHAR(50)       NULL,    -- بازه دوز درمانی
    ToxicDoseRange              NVARCHAR(50)       NULL,    -- بازه دوز سمی
    SideEffects                 NVARCHAR(MAX)      NULL,    -- عوارض جانبی
    Contraindications           NVARCHAR(MAX)      NULL,    -- موارد منع مصرف
    SynergisticEffects          NVARCHAR(MAX)      NULL,    -- اثرات هم‌افزایی
    AntagonisticEffects         NVARCHAR(MAX)      NULL,    -- اثرات آنتاگونیستی
    Pharmacodynamics            NVARCHAR(MAX)      NULL,    -- فارماکودینامیک
    OnsetDescription            NVARCHAR(MAX)      NULL,    -- توضیحات تکمیلی درباره شروع اثر
    RegulatoryApproval          NVARCHAR(100)      NULL,    -- وضعیت تأیید قانونی

    

    CONSTRAINT PK_DimMedicinalProperty PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- 12. جدول DimBiologicalTarget: اهداف زیستی (مشتریان مولکولی)
CREATE TABLE [dbo].[DimBiologicalTarget](
    -- کلید جایگزین
    SurrogateKey                UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد هدف زیستی

    -- کلید کسب‌وکاری برای لینک به DimPlant
    PlantBusinessKey            NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    TargetBusinessKey           NVARCHAR(100)      NULL,    -- شناسه کسب‌وکاری هدف
    TargetName                  NVARCHAR(150)      NULL,    -- نام هدف زیستی
    TargetType                  NVARCHAR(100)      NULL,    -- نوع هدف (آنزیم، گیرنده، کانال یونی و ...)
    OrganismSpecies             NVARCHAR(100)      NULL,    -- گونه ارگانیسم
    CellularLocalization        NVARCHAR(100)      NULL,    -- محل سلولی
    BiologicalPathway           NVARCHAR(200)      NULL,    -- مسیر زیستی
    BindingAffinity             NVARCHAR(50)       NULL,    -- میل اتصال
    TargetFunction              NVARCHAR(MAX)      NULL,    -- عملکرد هدف
    ExpressionPattern           NVARCHAR(MAX)      NULL,    -- الگوی بیان
    ReceptorSubtype             NVARCHAR(100)      NULL,    -- زیرنوع گیرنده
    StructuralFeatures          NVARCHAR(MAX)      NULL,    -- ویژگی‌های ساختاری
    KnownLigands                NVARCHAR(MAX)      NULL,    -- لیگاندهای شناخته‌شده
    RelatedDiseases             NVARCHAR(200)      NULL,    -- بیماری‌های مرتبط
    GeneticVariants             NVARCHAR(MAX)      NULL,    -- واریانت‌های ژنتیکی
    AlternativeNames            NVARCHAR(MAX)      NULL,    -- نام‌های جایگزین

    

    CONSTRAINT PK_DimBiologicalTarget PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------
USE [MedicinalPlantsDW];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

--------------------------------------------------------------------------------
-- جدول DimUsageMethod: روش‌های مصرف
CREATE TABLE [dbo].[DimUsageMethod](
    -- کلید جایگزین
    SurrogateKey             UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد روش مصرف

    -- کلید کسب‌وکاری برای لینک به DimPlant
    PlantBusinessKey         NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    MethodBusinessKey        NVARCHAR(100)      NULL,   -- شناسه کسب‌وکاری روش
    MethodName               NVARCHAR(150)      NULL,   -- نام روش (oral, topical…)
    ApplicationRoute         NVARCHAR(100)      NULL,   -- مسیر مصرف (خوراکی، موضعی و ...)
    PreparationInstructions  NVARCHAR(MAX)      NULL,   -- دستورالعمل آماده‌سازی
    DurationOfUse            NVARCHAR(50)       NULL,   -- مدت زمان مصرف
    Frequency                NVARCHAR(50)       NULL,   -- دفعات مصرف
    AdministrationConditions NVARCHAR(200)      NULL,   -- شرایط مصرف (قبل غذا، بعد غذا و ...)
    Contraindications        NVARCHAR(MAX)      NULL,   -- موارد منع مصرف
    RecommendedVehicle       NVARCHAR(100)      NULL,   -- حامل توصیه‌شده (مثلاً آب، روغن)
    TargetSymptoms           NVARCHAR(200)      NULL,   -- علائم هدف
    TraditionalUsage         NVARCHAR(MAX)      NULL,   -- کاربرد سنتی


    CONSTRAINT PK_DimUsageMethod PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- جدول DimDosageForm: شکل‌های دارویی
CREATE TABLE [dbo].[DimDosageForm](
    -- کلید جایگزین
    SurrogateKey             UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد شکل دارویی

    -- کلید کسب‌وکاری برای لینک به DimPlant
    PlantBusinessKey         NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    FormBusinessKey          NVARCHAR(100)      NULL,   -- شناسه کسب‌وکاری شکل
    FormName                 NVARCHAR(100)      NULL,   -- نام شکل (tincture, decoction…)
    PhysicalState            NVARCHAR(50)       NULL,   -- حالت فیزیکی (مایع، جامد و ...)
    Solvent                  NVARCHAR(100)      NULL,   -- حلال مورد استفاده
    Concentration            NVARCHAR(50)       NULL,   -- غلظت
    DoseUnit                 NVARCHAR(50)       NULL,   -- واحد دوز
    TypicalDose              NVARCHAR(50)       NULL,   -- دوز معمول
    MaxDailyDose             NVARCHAR(50)       NULL,   -- حداکثر دوز روزانه
    PreparationTime          NVARCHAR(50)       NULL,   -- زمان آماده‌سازی
    StorageConditions        NVARCHAR(200)      NULL,   -- شرایط نگهداری
    ShelfLife                NVARCHAR(50)       NULL,   -- طول عمر/تاریخ انقضا


    CONSTRAINT PK_DimDosageForm PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- جدول DimProcessingMethod: روش‌های فرآوری و استخراج
CREATE TABLE [dbo].[DimProcessingMethod](
    -- کلید جایگزین
    SurrogateKey             UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد فرآوری

    -- کلید کسب‌وکاری برای لینک به DimPlant
    PlantBusinessKey         NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    ProcessBusinessKey       NVARCHAR(100)      NULL,   -- شناسه کسب‌وکاری روش
    ProcessName              NVARCHAR(150)      NULL,   -- نام روش فرآوری/استخراج
    Description              NVARCHAR(MAX)      NULL,   -- توضیحات روش
    Temperature              NVARCHAR(50)       NULL,   -- دمای فرآیند
    Duration                 NVARCHAR(50)       NULL,   -- مدت زمان فرآیند
    SolventType              NVARCHAR(100)      NULL,   -- نوع حلال
    FilterType               NVARCHAR(100)      NULL,   -- نوع فیلتر
    YieldPercent             NVARCHAR(50)       NULL,   -- درصد بازده
    EquipmentNeeded          NVARCHAR(200)      NULL,   -- تجهیزات مورد نیاز
    DryingMethod             NVARCHAR(100)      NULL,   -- روش خشک‌کردن
    StoragePackaging         NVARCHAR(200)      NULL,   -- بسته‌بندی و نگهداری


    CONSTRAINT PK_DimProcessingMethod PRIMARY KEY CLUSTERED (SurrogateKey ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------
USE [MedicinalPlantsDW];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- جدول DimSeasonality: ویژگی‌های فصلی
CREATE TABLE [dbo].[DimSeasonality](
    [SurrogateKey]               UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد فصلی
    [PlantBusinessKey]           NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    [SeasonBusinessKey]          NVARCHAR(100)      NULL,   -- شناسه کسب‌وکاری فصل
    [SeasonName]                 NVARCHAR(100)      NULL,   -- نام فصل
    [FloweringStart]             NVARCHAR(50)       NULL,   -- شروع گل‌دهی
    [FloweringEnd]               NVARCHAR(50)       NULL,   -- پایان گل‌دهی
    [FruitingStart]              NVARCHAR(50)       NULL,   -- شروع میوه‌دهی
    [FruitingEnd]                NVARCHAR(50)       NULL,   -- پایان میوه‌دهی
    [DormancyPeriod]             NVARCHAR(100)      NULL,   -- دوره رکود
    [GrowingSeasonLength]        NVARCHAR(50)       NULL,   -- طول فصل رشد
    [PhotoperiodSensitivity]     NVARCHAR(100)      NULL,   -- حساسیت به طول روز
    [HarvestSeasonStart]         NVARCHAR(50)       NULL,   -- شروع فصل برداشت
    [HarvestSeasonEnd]           NVARCHAR(50)       NULL,   -- پایان فصل برداشت
    [VernalizationRequirement]   NVARCHAR(100)      NULL,   -- نیاز سرمایی (ورنالیزاسیون)
    [TemperatureThresholds]      NVARCHAR(100)      NULL,   -- آستانه‌های دمایی
    [PrecipitationThresholds]    NVARCHAR(100)      NULL,   -- آستانه‌های بارشی
    [SeasonalBiomassVariation]   NVARCHAR(MAX)      NULL,   -- تغییرات فصلی بیوماس
    [SeasonalCompoundVariation]  NVARCHAR(MAX)      NULL,   -- تغییرات فصلی ترکیبات


    CONSTRAINT PK_DimSeasonality PRIMARY KEY CLUSTERED ([SurrogateKey] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- جدول DimSafetyProfile: نمایه ایمنی
CREATE TABLE [dbo].[DimSafetyProfile](
    [SurrogateKey]               UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد ایمنی
    [PlantBusinessKey]           NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    [ProfileBusinessKey]         NVARCHAR(100)      NULL,   -- شناسه کسب‌وکاری نمایه ایمنی
    [ToxicityClassification]     NVARCHAR(100)      NULL,   -- طبقه‌بندی سمیت
    [LD50]                       NVARCHAR(100)      NULL,   -- دوز کشنده 50%
    [ExposureRoute]              NVARCHAR(100)      NULL,   -- مسیر مواجهه
    [Carcinogenicity]            NVARCHAR(100)      NULL,   -- سرطان‌زایی
    [Mutagenicity]               NVARCHAR(100)      NULL,   -- جهش‌زایی
    [Teratogenicity]             NVARCHAR(100)      NULL,   -- ناهنجاری‌زایی
    [AllergenicPotential]        NVARCHAR(100)      NULL,   -- پتانسیل آلرژی‌زایی
    [MaxSafeDose]                NVARCHAR(50)       NULL,   -- حداکثر دوز ایمن
    [AcceptableDailyIntake]      NVARCHAR(100)      NULL,   -- میزان مجاز مصرف روزانه
    [DrugInteractions]           NVARCHAR(MAX)      NULL,   -- تداخلات دارویی
    [Warnings]                   NVARCHAR(MAX)      NULL,   -- هشدارها
    [RegulatoryRestrictions]     NVARCHAR(200)      NULL,   -- محدودیت‌های قانونی
    [SafetyNotes]                NVARCHAR(MAX)      NULL,   -- یادداشت‌های ایمنی

    

    CONSTRAINT PK_DimSafetyProfile PRIMARY KEY CLUSTERED ([SurrogateKey] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- جدول DimPharmacokinetics: پارامترهای داروشناسی
CREATE TABLE [dbo].[DimPharmacokinetics](
    -- کلید جایگزین
    [SurrogateKey]               UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد فارماکوکینتیک

    -- کلید کسب‌وکاری برای لینک به DimPlant
    [PlantBusinessKey]           NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    [PKBusinessKey]              NVARCHAR(100)      NULL,   -- شناسه کسب‌وکاری پارامتر PK
    [AbsorptionRate]             NVARCHAR(50)       NULL,   -- نرخ جذب
    [Bioavailability]            NVARCHAR(50)       NULL,   -- فراهمی زیستی
    [DistributionVolume]         NVARCHAR(50)       NULL,   -- حجم توزیع
    [ProteinBindingPercentage]   NVARCHAR(50)       NULL,   -- درصد اتصال پروتئینی
    [MetabolismPathways]         NVARCHAR(MAX)      NULL,   -- مسیرهای متابولیکی
    [HalfLife]                   NVARCHAR(50)       NULL,   -- نیمه‌عمر
    [ClearanceRate]              NVARCHAR(50)       NULL,   -- نرخ پاکسازی
    [Tmax]                       NVARCHAR(50)       NULL,   -- زمان رسیدن به غلظت ماکزیمم
    [Cmax]                       NVARCHAR(50)       NULL,   -- غلظت ماکزیمم
    [AUC]                        NVARCHAR(50)       NULL,   -- سطح زیر منحنی
    [ExcretionRoute]             NVARCHAR(100)      NULL,   -- مسیر دفع
    [ExcretionRate]              NVARCHAR(50)       NULL,   -- نرخ دفع
    [PeakPlasmaConcentration]    NVARCHAR(50)       NULL,   -- غلظت پیک پلاسمایی
    [SteadyStateConcentration]   NVARCHAR(50)       NULL,   -- غلظت پایدار
    [MetaboliteProfiles]         NVARCHAR(MAX)      NULL,   -- پروفایل متابولیت‌ها


    CONSTRAINT PK_DimPharmacokinetics PRIMARY KEY CLUSTERED ([SurrogateKey] ASC)
) 
ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------
USE [MedicinalPlantsDW];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

--------------------------------------------------------------------------------
-- جدول DimEconomicData: داده‌های اقتصادی گیاه
CREATE TABLE [dbo].[DimEconomicData](
    -- کلید جایگزین
    [SurrogateKey]                   UNIQUEIDENTIFIER   NOT NULL,
    
    -- کلید کسب‌وکاری برای لینک به DimPlant
    [PlantBusinessKey]               NVARCHAR(100)      NULL,

    -- ویژگی‌های اختصاصی
    [EconomicBusinessKey]            NVARCHAR(100)      NULL,    -- شناسه کسب‌وکاری داده اقتصادی
    [MarketPrice]                    NVARCHAR(50)       NULL,    -- قیمت بازار (واحد پول)
    [DemandTrend]                    NVARCHAR(50)       NULL,    -- روند تقاضا (افزایشی/کاهشی)
    [SupplyTrend]                    NVARCHAR(50)       NULL,    -- روند عرضه
    [ProductionVolume]               NVARCHAR(50)       NULL,    -- حجم تولید سالانه
    [ExportVolume]                   NVARCHAR(50)       NULL,    -- حجم صادرات
    [ImportVolume]                   NVARCHAR(50)       NULL,    -- حجم واردات
    [MarketGrowthRate]               NVARCHAR(50)       NULL,    -- نرخ رشد بازار
    [PriceVolatilityIndex]           NVARCHAR(50)       NULL,    -- شاخص نوسان قیمت
    [TradeBalance]                   NVARCHAR(50)       NULL,    -- تراز تجاری
    [ConsumerPreferenceIndex]        NVARCHAR(50)       NULL,    -- شاخص ترجیح مصرف‌کننده
    [CostOfCultivation]              NVARCHAR(50)       NULL,    -- هزینه کشت (واحد پول)
    [ROI]                            NVARCHAR(50)       NULL,    -- بازگشت سرمایه (درصد)
    [EconomicSustainabilityScore]    NVARCHAR(50)       NULL,    -- امتیاز پایداری اقتصادی
    [PriceForecast]                  NVARCHAR(50)       NULL,    -- پیش‌بینی قیمت آینده
    [SubsidyAmount]                  NVARCHAR(50)       NULL,    -- مقدار یارانه (واحد پول)
    [TransportationCost]             NVARCHAR(50)       NULL,    -- هزینه حمل‌ونقل
    [PackagingCost]                  NVARCHAR(50)       NULL,    -- هزینه بسته‌بندی
    [StorageCost]                    NVARCHAR(50)       NULL,    -- هزینه نگهداری
    [EmploymentPerHectare]           NVARCHAR(50)       NULL,    -- اشتغال‌زایی به ازای هکتار
    [ValueChainLength]               NVARCHAR(50)       NULL,    -- طول زنجیره ارزش
    [ProfitMargin]                   NVARCHAR(50)       NULL,    -- حاشیه سود (درصد)
    [PriceElasticity]                NVARCHAR(50)       NULL,    -- کشش قیمتی
    [TaxRate]                        NVARCHAR(50)       NULL,    -- نرخ مالیات (درصد)


    CONSTRAINT PK_DimEconomicData PRIMARY KEY CLUSTERED ([SurrogateKey] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- جدول DimLiteratureReference: منابع مکتوب و مقالات
CREATE TABLE [dbo].[DimLiteratureReference](
    -- کلید جایگزین
    [SurrogateKey]               UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد مرجع

    -- کلید کسب‌وکاری برای لینک به DimPlant
    [PlantBusinessKey]           NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    [ReferenceBusinessKey]       NVARCHAR(100)      NULL,    -- شناسه کسب‌وکاری مرجع
    [Title]                      NVARCHAR(500)      NULL,    -- عنوان مقاله/کتاب
    [Authors]                    NVARCHAR(500)      NULL,    -- نویسندگان
    [Journal]                    NVARCHAR(255)      NULL,    -- نام ژورنال
    [PublicationYear]            NVARCHAR(4)        NULL,    -- سال انتشار
    [DOI]                        NVARCHAR(100)      NULL,    -- شناسه DOI
    [ReferenceURL]               NVARCHAR(MAX)      NULL,    -- لینک مرجع
    [Abstract]                   NVARCHAR(MAX)      NULL,    -- چکیده
    [Keywords]                   NVARCHAR(500)      NULL,    -- کلیدواژه‌ها
    [CitationCount]              INT                NULL,    -- تعداد استنادها
    [ImpactFactor]               NVARCHAR(50)       NULL,    -- ضریب تأثیر ژورنال
    [Language]                   NVARCHAR(50)       NULL,    -- زبان مرجع
    [Publisher]                  NVARCHAR(255)      NULL,    -- ناشر
    [ReferenceType]              NVARCHAR(50)       NULL,    -- نوع مرجع (JournalArticle, Book, Conference)
    [PageRange]                  NVARCHAR(50)       NULL,    -- محدوده صفحات
    [Volume]                     NVARCHAR(50)       NULL,    -- جلد
    [Issue]                      NVARCHAR(50)       NULL,    -- شماره
    [PubMedID]                   NVARCHAR(100)      NULL,    -- شناسه PubMed


    CONSTRAINT PK_DimLiteratureReference PRIMARY KEY CLUSTERED ([SurrogateKey] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------
USE [MedicinalPlantsDW];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

--------------------------------------------------------------------------------
-- جدول DimImageMetadata: متادیتای تصاویر گیاهان
CREATE TABLE [dbo].[DimImageMetadata](
    -- کلید جایگزین
    [SurrogateKey]          UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد تصویر

    -- کلید کسب‌وکاری برای لینک به DimPlant
    [PlantBusinessKey]      NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    [ImageBusinessKey]      NVARCHAR(100)      NULL,    -- شناسه کسب‌وکاری تصویر
    [ImageURL]              NVARCHAR(MAX)      NULL,    -- آدرس کامل تصویر
    [ThumbnailURL]          NVARCHAR(MAX)      NULL,    -- آدرس بندانگشتی
    [Caption]               NVARCHAR(MAX)      NULL,    -- توضیح یا عنوان تصویر
    [Photographer]          NVARCHAR(200)      NULL,    -- نام عکاس
    [SourceRepository]      NVARCHAR(200)      NULL,    -- مخزن یا آرشیو تصویر
    [ImageDate]             DATETIME           NULL,    -- تاریخ ثبت تصویر
    [Resolution]            NVARCHAR(50)       NULL,    -- وضوح تصویر (مثلاً 1920x1080)
    [Width]                 NVARCHAR(50)       NULL,    -- عرض تصویر (پیکسل)
    [Height]                NVARCHAR(50)       NULL,    -- ارتفاع تصویر (پیکسل)
    [ImageFormat]           NVARCHAR(50)       NULL,    -- فرمت تصویر (JPEG, PNG…)
    [FileSize]              NVARCHAR(50)       NULL,    -- حجم فایل (مثلاً 2.5MB)
    [ColorDepth]            NVARCHAR(50)       NULL,    -- عمق رنگ (بیت)
    [ImagingTechnique]      NVARCHAR(100)      NULL,    -- تکنیک تصویربرداری (عکاسی، اسکن و ...)
    [SemanticTags]          NVARCHAR(MAX)      NULL,    -- برچسب‌های معنایی/موضوعی
    [EXIFData]              NVARCHAR(MAX)      NULL,    -- داده‌های EXIF
    [UsageContext]          NVARCHAR(200)      NULL,    -- محل نمایش یا کاربرد تصویر


    CONSTRAINT PK_DimImageMetadata PRIMARY KEY CLUSTERED ([SurrogateKey] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- جدول DimQualityMetrics: معیارهای کیفیت داده
CREATE TABLE [dbo].[DimQualityMetrics](
    -- کلید جایگزین
    [SurrogateKey]             UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد معیار کیفیت

    -- کلید کسب‌وکاری برای لینک به DimPlant
    [PlantBusinessKey]         NVARCHAR(100)      NULL,       -- کلید کسب‌وکاری گیاه

    -- ویژگی‌های اختصاصی
    [MetricBusinessKey]        NVARCHAR(100)      NULL,    -- شناسه کسب‌وکاری معیار
    [TableName]                NVARCHAR(100)      NULL,    -- نام جدول مورد ارزیابی
    [ColumnName]               NVARCHAR(100)      NULL,    -- نام ستون مورد ارزیابی
    [CompletenessPercent]      NVARCHAR(50)       NULL,    -- درصد تکمیل داده
    [UniquenessRatio]          NVARCHAR(50)       NULL,    -- نسبت یکتایی داده
    [ValidityRatio]            NVARCHAR(50)       NULL,    -- نسبت اعتبار داده
    [AccuracyRatio]            NVARCHAR(50)       NULL,    -- نسبت دقت داده
    [ConsistencyRatio]         NVARCHAR(50)       NULL,    -- نسبت انسجام داده
    [TimelinessRatio]          NVARCHAR(50)       NULL,    -- نسبت به‌موقع بودن داده
    [ConformityRatio]          NVARCHAR(50)       NULL,    -- نسبت انطباق با استاندارد
    [IntegrityRatio]           NVARCHAR(50)       NULL,    -- نسبت تمامیت مرجع
    [NullValueCount]           INT                NULL,    -- تعداد مقادیر NULL
    [DuplicateCount]           INT                NULL,    -- تعداد رکوردهای تکراری
    [OutlierCount]             INT                NULL,    -- تعداد مقادیر پرت
    [ValidRecordCount]         INT                NULL,    -- تعداد رکوردهای معتبر
    [InvalidRecordCount]       INT                NULL,    -- تعداد رکوردهای نامعتبر
    [LastAuditDate]            DATETIME           NULL,    -- تاریخ آخرین ممیزی
    [AuditFrequency]           NVARCHAR(50)       NULL,    -- تناوب ممیزی
    [Reviewer]                 NVARCHAR(100)      NULL,    -- نام ممیز


    CONSTRAINT PK_DimQualityMetrics PRIMARY KEY CLUSTERED ([SurrogateKey] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

--------------------------------------------------------------------------------
-- FactPlantUsage: ثبت رویدادهای مصرف گیاه
CREATE TABLE [dbo].[FactPlantUsage](
    -- کلید جایگزین
    [FactPlantUsageKey]            UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد Fact

    -- روابط به ابعاد
    [PlantSurrogateKey]            UNIQUEIDENTIFIER   NOT NULL,   -- ارتباط به DimPlant
    [UsageMethodSurrogateKey]      UNIQUEIDENTIFIER   NULL,       -- ارتباط به DimUsageMethod
    [DosageFormSurrogateKey]       UNIQUEIDENTIFIER   NULL,       -- ارتباط به DimDosageForm
    [ProcessingMethodSurrogateKey] UNIQUEIDENTIFIER   NULL,       -- ارتباط به DimProcessingMethod

    -- ویژگی‌های اختصاصی حقایق
    [UsageDate]                    DATETIME           NULL,  -- زمان مصرف
    [DosageQuantity]               NVARCHAR(50)       NULL,  -- مقدار دوز
    [DosageUnit]                   NVARCHAR(50)       NULL,  -- واحد دوز
    [Frequency]                    NVARCHAR(50)       NULL,  -- دفعات مصرف
    [AdministrationRoute]          NVARCHAR(100)      NULL,  -- مسیر مصرف
    [PartUsed]                     NVARCHAR(100)      NULL,  -- بخش گیاه مصرف‌شده
    [UsageDuration]                NVARCHAR(50)       NULL,  -- مدت مصرف
    [ObservedEffect]               NVARCHAR(MAX)      NULL,  -- اثر مشاهده‌شده
    [EnvironmentContext]           NVARCHAR(200)      NULL,  -- شرایط محیطی مصرف


    CONSTRAINT PK_FactPlantUsage PRIMARY KEY CLUSTERED ([FactPlantUsageKey] ASC)
);
GO

--------------------------------------------------------------------------------
-- FactCompoundConcentration: غلظت ترکیبات شیمیایی
CREATE TABLE [dbo].[FactCompoundConcentration](
    -- کلید جایگزین
    [FactCompoundConcentrationKey] UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد Fact

    -- روابط به ابعاد
    [PlantSurrogateKey]            UNIQUEIDENTIFIER   NOT NULL,   -- ارتباط به DimPlant
    [CompoundSurrogateKey]         UNIQUEIDENTIFIER   NOT NULL,   -- ارتباط به DimChemicalCompound
    [ProcessingMethodSurrogateKey] UNIQUEIDENTIFIER   NULL,       -- ارتباط به DimProcessingMethod

    -- ویژگی‌های اختصاصی حقایق
    [MeasurementDate]              DATETIME           NULL,       -- تاریخ اندازه‌گیری
    [PartUsed]                     NVARCHAR(100)      NULL,       -- بخش گیاه مورد استفاده (برگ، ریشه و ...)
    [ConcentrationValue]           FLOAT              NULL,       -- مقدار غلظت
    [ConcentrationUnit]            NVARCHAR(50)       NULL,       -- واحد غلظت (mg/g, ppm, % و ...)
    [MeasurementMethod]            NVARCHAR(200)      NULL,       -- روش اندازه‌گیری
    [ExtractionSolvent]            NVARCHAR(100)      NULL,       -- حلال استخراج
    [ExtractionDuration]           NVARCHAR(50)       NULL,       -- مدت زمان استخراج
    [Temperature]                  NVARCHAR(50)       NULL,       -- دمای فرآیند
    [pH]                           NVARCHAR(50)       NULL,       -- مقدار pH در زمان اندازه‌گیری


    CONSTRAINT PK_FactCompoundConcentration PRIMARY KEY CLUSTERED ([FactCompoundConcentrationKey] ASC)
);
GO

--------------------------------------------
USE [MedicinalPlantsDW];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

--------------------------------------------------------------------------------
-- FactPropertyObservation: مشاهدات کمی و کیفی خواص گیاه
CREATE TABLE [dbo].[FactPropertyObservation](
    -- کلید جایگزین
    [FactPropertyObservationKey]    UNIQUEIDENTIFIER   NOT NULL,

    -- روابط به جداول ابعادی
    [PlantSurrogateKey]             UNIQUEIDENTIFIER   NOT NULL,
    [PropertySurrogateKey]          UNIQUEIDENTIFIER   NULL,
    [TargetSurrogateKey]            UNIQUEIDENTIFIER   NULL,
    [CompoundSurrogateKey]          UNIQUEIDENTIFIER   NULL,

    -- ویژگی‌های اختصاصی حقایق
    [ObservationDate]               DATETIME           NULL,    -- زمان ثبت مشاهده
    [ObservedValue]                 FLOAT              NULL,    -- مقدار اندازه‌گیری‌شده
    [ValueUnit]                     NVARCHAR(50)       NULL,    -- واحد مقدار
    [MeasurementMethod]             NVARCHAR(200)      NULL,    -- روش اندازه‌گیری
    [ObservationContext]            NVARCHAR(200)      NULL,    -- شرایط محیطی یا بالینی
    [ObservationDuration]           NVARCHAR(50)       NULL,    -- مدت زمان مشاهده
    [EnvironmentalConditions]       NVARCHAR(200)      NULL,    -- دما، رطوبت و …
    [Remarks]                       NVARCHAR(MAX)      NULL,    -- یادداشت تکمیلی

    

    CONSTRAINT PK_FactPropertyObservation PRIMARY KEY CLUSTERED ([FactPropertyObservationKey] ASC)
);
GO

--------------------------------------------------------------------------------
-- FactPlantDistribution: ثبت رویداد پراکنش گیاه
CREATE TABLE [dbo].[FactPlantDistribution](
    -- کلید جایگزین
    [FactPlantDistributionKey]      UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد Fact

    -- روابط به جداول ابعادی
    [PlantSurrogateKey]             UNIQUEIDENTIFIER   NOT NULL,   -- ارتباط به DimPlant
    [GeographySurrogateKey]         UNIQUEIDENTIFIER   NULL,       -- ارتباط به DimGeography
    [ClimateSurrogateKey]           UNIQUEIDENTIFIER   NULL,       -- ارتباط به DimClimate
    [HabitatSurrogateKey]           UNIQUEIDENTIFIER   NULL,       -- ارتباط به DimHabitat

    -- ویژگی‌های اختصاصی حقایق
    [DistributionDate]              DATETIME           NULL,    -- زمان مشاهده یا گزارش
    [DistributionType]              NVARCHAR(100)      NULL,    -- نوع پراکنش (native, introduced, invasive)
    [OccurrenceCount]               INT                NULL,    -- تعداد مشاهده
    [PopulationDensity]             NVARCHAR(50)       NULL,    -- تراکم جمعیت (واحد بر km2 یا ha)
    [ObservationMethod]             NVARCHAR(200)      NULL,    -- روش جمع‌آوری داده پراکنش
    [CoordinateSystem]              NVARCHAR(100)      NULL,    -- سیستم مختصات (EPSG code یا WKT)
    [Remarks]                       NVARCHAR(MAX)      NULL,    -- یادداشت تکمیلی


    CONSTRAINT PK_FactPlantDistribution PRIMARY KEY CLUSTERED ([FactPlantDistributionKey] ASC)
);
GO

--------------------------------------------------------------------------------
-- FactMarketTransaction: رویدادهای معاملاتی بازار
CREATE TABLE [dbo].[FactMarketTransaction](
    -- کلید جایگزین
    [FactMarketTransactionKey]     UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد Fact

    -- روابط به ابعاد
    [PlantSurrogateKey]            UNIQUEIDENTIFIER   NOT NULL,   -- ارتباط به DimPlant
    [EconomicDataSurrogateKey]     UNIQUEIDENTIFIER   NULL,       -- ارتباط به DimEconomicData
    [GeographySurrogateKey]        UNIQUEIDENTIFIER   NULL,       -- ارتباط به DimGeography

    -- ویژگی‌های اختصاصی حقایق
    [TransactionDate]              DATETIME           NULL,    -- تاریخ معامله
    [TransactionType]              NVARCHAR(100)      NULL,    -- نوع معامله (نقدی، اعتباری، قرارداد)
    [Buyer]                        NVARCHAR(200)      NULL,    -- خریدار
    [Seller]                       NVARCHAR(200)      NULL,    -- فروشنده
    [Quantity]                     FLOAT              NULL,    -- مقدار
    [QuantityUnit]                 NVARCHAR(50)       NULL,    -- واحد مقدار
    [TotalPrice]                   FLOAT              NULL,    -- قیمت کل
    [PricePerUnit]                 FLOAT              NULL,    -- قیمت واحد
    [Currency]                     NVARCHAR(20)       NULL,    -- ارز
    [PaymentTerms]                 NVARCHAR(200)      NULL,    -- شرایط پرداخت
    [ContractLength]               NVARCHAR(50)       NULL,    -- مدت قرارداد
    [CertificationType]            NVARCHAR(100)      NULL,    -- نوع گواهی
    [TransportationMode]           NVARCHAR(100)      NULL,    -- روش حمل‌ونقل
    [StorageCondition]             NVARCHAR(200)      NULL,    -- شرایط نگهداری
    [ShipmentDate]                 DATETIME           NULL,    -- تاریخ ارسال
    [DeliveryDate]                 DATETIME           NULL,    -- تاریخ تحویل
    [TaxAmount]                    FLOAT              NULL,    -- مبلغ مالیات
    [FeeAmount]                    FLOAT              NULL,    -- مبلغ کارمزد
    [ExchangeRate]                 FLOAT              NULL,    -- نرخ ارز
    [InvoiceNumber]                NVARCHAR(100)      NULL,    -- شماره فاکتور
    [TradeChannel]                 NVARCHAR(100)      NULL,    -- کانال تجاری (عمده، خرده، آنلاین)
    [BuyerType]                    NVARCHAR(100)      NULL,    -- نوع خریدار
    [SellerType]                   NVARCHAR(100)      NULL,    -- نوع فروشنده


    CONSTRAINT PK_FactMarketTransaction PRIMARY KEY CLUSTERED ([FactMarketTransactionKey] ASC)
);
GO

--------------------------------------------------------------------------------
-- FactAdverseEvent: ثبت رویدادهای عوارض جانبی
CREATE TABLE [dbo].[FactAdverseEvent](
    -- کلید جایگزین
    [FactAdverseEventKey]          UNIQUEIDENTIFIER   NOT NULL,   -- کلید یکتای داخلی برای رکورد Fact

    -- روابط به ابعاد
    [PlantSurrogateKey]            UNIQUEIDENTIFIER   NOT NULL,   -- ارتباط به DimPlant
    [UsageMethodSurrogateKey]      UNIQUEIDENTIFIER   NULL,       -- ارتباط به DimUsageMethod
    [DosageFormSurrogateKey]       UNIQUEIDENTIFIER   NULL,       -- ارتباط به DimDosageForm

    -- ویژگی‌های اختصاصی حقایق
    [EventDate]                    DATETIME           NULL,    -- تاریخ گزارش
    [AdverseEventType]             NVARCHAR(200)      NULL,    -- نوع عارضه
    [Severity]                     NVARCHAR(100)      NULL,    -- شدت (خفیف، متوسط، شدید)
    [Outcome]                      NVARCHAR(100)      NULL,    -- پیامد (بهبود، ماندگار، مرگ)
    [NumberOfCases]                INT                NULL,    -- تعداد موارد
    [ReporterType]                 NVARCHAR(100)      NULL,    -- نوع گزارش‌دهنده (پزشک، بیمار، سازمان)
    [ReportSource]                 NVARCHAR(200)      NULL,    -- منبع گزارش
    [AgeGroup]                     NVARCHAR(50)       NULL,    -- گروه سنی
    [GenderRatio]                  NVARCHAR(50)       NULL,    -- نسبت جنسیتی (زنان/مردان)
    [DoseAtEvent]                  NVARCHAR(50)       NULL,    -- دوز مصرف‌شده در زمان عارضه
    [DurationToOnset]              NVARCHAR(50)       NULL,    -- مدت زمان تا شروع عارضه
    [TreatmentAdministered]        NVARCHAR(MAX)      NULL,    -- درمان انجام‌شده
    [RecoveryTime]                 NVARCHAR(50)       NULL,    -- زمان بهبودی
    [HospitalizationRequired]      BIT                NULL,    -- نیاز به بستری
    [RegulatoryAction]             NVARCHAR(MAX)      NULL,    -- اقدام قانونی/نظارتی

    

    CONSTRAINT PK_FactAdverseEvent PRIMARY KEY CLUSTERED ([FactAdverseEventKey] ASC)
);
GO

--------------------------------------------
-- 1. فعال‌سازی FILESTREAM در دیتابیس (یک‌بار اجرا می‌شود)
ALTER DATABASE [MedicinalPlantsDW]
ADD FILEGROUP [FSImageFG] CONTAINS FILESTREAM;
GO

ALTER DATABASE [MedicinalPlantsDW]
ADD FILE (
    NAME = N'FSImageStore',
    FILENAME = N'C:\DW\MedicinalPlants\FSStore'
) TO FILEGROUP [FSImageFG];
GO

--------------------------------------------------------------------------------
-- 2. اصلاح DimImageMetadata برای ارتباط مستقیم با DimPlant (اضافه کردن کلید جایگزین)
ALTER TABLE [dbo].[DimImageMetadata]
ADD 
    [PlantSurrogateKey] UNIQUEIDENTIFIER NULL;
GO

ALTER TABLE [dbo].[DimImageMetadata]
WITH NOCHECK
ADD CONSTRAINT FK_DimImageMetadata_DimPlant
    FOREIGN KEY([PlantSurrogateKey]) 
    REFERENCES [dbo].[DimPlant]([SurrogateKey]);
GO

--------------------------------------------------------------------------------
-- 3. جدول جدید DimPlantImageStorage: نگهداری فایل‌های تصویر با FILESTREAM
USE [MedicinalPlantsDW];
GO
CREATE TABLE dbo.DimPlantImageStorage(
    SurrogateKey      UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL 
                      CONSTRAINT UQ_DimPlantImageStorage_SurrogateKey UNIQUE, -- کلید یکتای داخلی برای رکورد فایل تصویر
    PlantSurrogateKey UNIQUEIDENTIFIER NOT NULL,   -- ارتباط به DimPlant
    ImageMetadataKey  UNIQUEIDENTIFIER NOT NULL,   -- ارتباط به DimImageMetadata
    FileName          NVARCHAR(512) NOT NULL,      -- نام فایل ذخیره‌شده
    ImageStream       VARBINARY(MAX) FILESTREAM NULL, -- محتوای باینری تصویر (FILESTREAM)
    CreatedDate       DATETIME NOT NULL DEFAULT GETUTCDATE(), -- تاریخ ایجاد رکورد

    CONSTRAINT PK_DimPlantImageStorage PRIMARY KEY CLUSTERED (SurrogateKey)
) ON [PRIMARY] FILESTREAM_ON [FSImageFG];
GO
