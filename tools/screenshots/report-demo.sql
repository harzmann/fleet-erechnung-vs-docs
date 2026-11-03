-- Nur auf der separaten LocalDB-Instanz EHFleetDocs ausführen.
USE master;
GO
IF ISNULL(CONVERT(int, SERVERPROPERTY('IsLocalDB')),0) <> 1
    THROW 51000, 'Vorschau-Fixture ist ausschließlich für LocalDB vorgesehen.',1;
IF DB_ID(N'EHFleet') IS NOT NULL
    THROW 51000, 'Vorhandene Datenbank EHFleet wird nicht verändert.',1;
GO
CREATE DATABASE EHFleet;
GO
USE EHFleet;
GO
CREATE TABLE dbo.DocsDemoMarker (FixtureVersion int NOT NULL, Purpose nvarchar(100));
INSERT dbo.DocsDemoMarker VALUES (1,N'Fiktive Berichtsvorschau – separate LocalDB');
CREATE TABLE dbo.Parameter (ParameterNr int PRIMARY KEY, [Text] nvarchar(1000), Aktiviert int,
    Modul1 nvarchar(100),Modul2 nvarchar(100),Modul3 nvarchar(100),Modul4 nvarchar(100),Ausgabepfad nvarchar(255));
INSERT dbo.Parameter(ParameterNr,Aktiviert,Ausgabepfad) VALUES
(210,-1,NULL),(211,-1,N'C:\FLEET-Demo\ERechnung'),(1211,-1,N'C:\FLEET-Demo\ERechnung'),(2211,-1,N'C:\FLEET-Demo\ERechnung');
CREATE TABLE dbo.DemoBeleg (RechnungsNr int, Firma nvarchar(100), Netto decimal(18,2), Steuer decimal(18,2), Brutto decimal(18,2));
INSERT dbo.DemoBeleg VALUES (260101,N'Demo-Spedition Nordhafen',453,86.07,539.07);
CREATE TABLE dbo.DemoDetails (RechnungsNr int, RechnungsDetailNr int, ArtikelNr int NULL, PersonalID int NULL);
INSERT dbo.DemoDetails VALUES (260101,1,NULL,1),(260101,2,2,NULL),(260101,3,3,NULL);
GO
CREATE VIEW dbo.abfr_wavkreport AS SELECT * FROM dbo.DemoBeleg;
GO
CREATE VIEW dbo.abfr_wavkabrdetail AS SELECT * FROM dbo.DemoDetails;
GO
CREATE VIEW dbo.abfr_wavksummekat AS SELECT * FROM dbo.DemoBeleg;
GO
CREATE VIEW dbo.abfr_wavkabrmwst AS SELECT * FROM dbo.DemoBeleg;
GO
