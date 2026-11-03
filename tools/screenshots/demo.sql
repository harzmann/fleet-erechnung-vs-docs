-- Ausschließlich synthetische Daten für Dokumentationsaufnahmen.
-- Vorhandene Datenbanken werden NICHT überschrieben oder zurückgesetzt.
USE master;
GO
IF DB_ID(N'EHFleet_Docs_Demo') IS NOT NULL
    THROW 51000, 'EHFleet_Docs_Demo existiert bereits. Keine Änderung ausgeführt.', 1;
GO
CREATE DATABASE EHFleet_Docs_Demo COLLATE Latin1_General_100_BIN2;
GO
USE EHFleet_Docs_Demo;
GO
CREATE TABLE dbo.DocsDemoMarker (Purpose nvarchar(100) NOT NULL, FixtureVersion int NOT NULL);
INSERT dbo.DocsDemoMarker VALUES (N'Fiktive Dokumentationsdaten – kein Produktivbestand', 1);

CREATE TABLE dbo.Parameter (
    ParameterNr int NOT NULL PRIMARY KEY, Aktiviert int NOT NULL DEFAULT -1,
    Firma nvarchar(100), Name nvarchar(100), [Straße] nvarchar(100), Strasse nvarchar(100),
    PLZ nvarchar(10), Ort nvarchar(100), Telefon nvarchar(50), Steuernummer nvarchar(50),
    Modul1 nvarchar(100), Modul2 nvarchar(100), Modul3 nvarchar(100), Modul4 nvarchar(100),
    Ausgabepfad nvarchar(255)
);
INSERT dbo.Parameter (ParameterNr,Firma,Name,[Straße],Strasse,PLZ,Ort,Telefon,Steuernummer)
SELECT n,N'Demo-Werkstatt Elbtal',N'Demo-Rechnungsstelle',N'Demo-Werkhof 12',N'Demo-Werkhof 12',
       N'00000',N'Demo-Hafenstadt',N'030 0000000 (Demo)',N'DE000000000 (Demo)'
FROM (VALUES (1),(11),(21)) AS p(n);
INSERT dbo.Parameter (ParameterNr,Modul1,Modul2,Modul3,Modul4,Ausgabepfad)
SELECT n,N'rechnung@elbtal.example',N'DE00 0000 0000 0000 0000 00',N'DEMODE00XXX',
       N'Demo-Bank (Platzhalter)',N'C:\FLEET-Demo\ERechnung'
FROM (VALUES (211),(1211),(2211)) AS p(n);

CREATE TABLE dbo.Mengeneinheit (
    ID int PRIMARY KEY, MengeneinheitK nvarchar(20), MengeneinheitL nvarchar(80),
    ERechnung_UnitCode varchar(10), ERechnung_UnitConversion decimal(18,6),
    LetzterZugriff_Benutzer nvarchar(50), LetzterZugriff_Datum datetime
);
INSERT dbo.Mengeneinheit VALUES
(1,N'Stk',N'Ersatzteile / Stück','C62',1,N'Demo','2026-11-03T09:00:00'),
(2,N'l',N'Diesel / AdBlue / Motoröl in Litern','LTR',1,N'Demo','2026-11-03T09:00:00'),
(3,N'h',N'Werkstattarbeit in Stunden','HUR',1,N'Demo','2026-11-03T09:00:00'),
(4,N'min',N'Arbeitszeit in Minuten','MIN',1,N'Demo','2026-11-03T09:00:00'),
(5,N'kg',N'Materialgewicht in Kilogramm','KGM',1,N'Demo','2026-11-03T09:00:00'),
(6,N'kWh',N'Ladeenergie in Kilowattstunden','KWH',1,N'Demo','2026-11-03T09:00:00'),
(7,N'h->min',N'Stunden als Minuten ausgeben','MIN',60,N'Demo','2026-11-03T09:00:00');

CREATE TABLE dbo.[Steuersätze] (
    ID int PRIMARY KEY, Matchcode nvarchar(30), Kurzbezeichnung nvarchar(90), MwSt decimal(9,2),
    ERechnung_BT151 varchar(10), ERechnung_BT120 nvarchar(150), ERechnung_BT121 varchar(60),
    LetzterZugriff_Benutzer nvarchar(50), LetzterZugriff_Datum datetime
);
-- Die vereinfachte Aufnahme-Fixture zeigt den Prozentsatz direkt in MwSt.
-- Kein produktives Datenbankschema, keine Migrations- oder Exportvorlage.
INSERT dbo.[Steuersätze] VALUES
(1,N'WA19',N'Werkstatt / Diesel – Beispiel 19 %',19,'S',N'','',N'Demo','2026-11-03T09:00:00'),
(2,N'RC',N'Reverse Charge – nur bei erfüllten Voraussetzungen',0,'AE',N'Steuerschuldnerschaft des Leistungsempfängers','VATEX_EU_AE',N'Demo','2026-11-03T09:00:00'),
(3,N'IGL',N'Innergemeinschaftliche Warenlieferung – bedingt',0,'K',N'Steuerfreie innergemeinschaftliche Lieferung','VATEX_EU_IC',N'Demo','2026-11-03T09:00:00'),
(4,N'EXPORT',N'Ausfuhrlieferung außerhalb EU – bedingt',0,'G',N'Steuerfreie Ausfuhrlieferung','VATEX_EU_G',N'Demo','2026-11-03T09:00:00'),
(5,N'NICHTST',N'Außerhalb des USt-Anwendungsbereichs – bedingt',0,'O',N'Nicht im Anwendungsbereich der Umsatzsteuer','VATEX_EU_O',N'Demo','2026-11-03T09:00:00');

CREATE TABLE dbo.DocsRechnungen (
    Domain varchar(2), RechnungsNr int, Rechnungsdatum datetime, WANr nvarchar(90), Datum datetime,
    Auftragsart nvarchar(20), Anmerkungen nvarchar(120), Belegart nvarchar(20), KundenNr int,
    DebitorNr nvarchar(20), Firma nvarchar(90), LeitwegeID nvarchar(50), EmailRechnung nvarchar(100),
    Summe decimal(18,2), Exportiert bit, Gebucht bit, ERechnung_Locked bit, Storno bit
);
INSERT dbo.DocsRechnungen VALUES
('WA',260101,'2026-11-02T00:00:00',N'Lkw-Inspektion / Filter und Motoröl','2026-11-02T00:00:00',N'Inspektion',NULL,N'Rechnung',1001,N'D-1001',N'Demo-Spedition Nordhafen',N'',N'rechnung@nordhafen.example',453.00,0,0,0,0),
('WA',260102,'2026-11-02T00:00:00',N'Bremsenwechsel Sattelzugmaschine','2026-11-02T00:00:00',N'Reparatur',NULL,N'Rechnung',1002,N'D-1002',N'Demo-Transport Westtor',N'',N'rechnung@westtor.example',750.00,0,0,0,0),
('WA',260103,'2026-11-03T00:00:00',N'Aufliegerwartung / Beleuchtung','2026-11-03T00:00:00',N'Wartung',NULL,N'Rechnung',1001,N'D-1001',N'Demo-Spedition Nordhafen',N'',N'rechnung@nordhafen.example',270.00,0,0,0,0),
('TA',260201,'2026-11-03T00:00:00',NULL,'2026-11-03T00:00:00',NULL,N'Diesel 600 LTR / AdBlue 40 LTR',N'Rechnung',1001,N'D-1001',N'Demo-Spedition Nordhafen',N'',N'rechnung@nordhafen.example',896.00,0,0,0,0),
('TA',260202,'2026-11-03T00:00:00',NULL,'2026-11-03T00:00:00',NULL,N'Diesel 420 LTR / Fuhrpark Westtor',N'Rechnung',1002,N'D-1002',N'Demo-Transport Westtor',N'',N'rechnung@westtor.example',609.00,0,0,0,0);
GO
CREATE VIEW dbo.abfr_wavkliste AS SELECT * FROM dbo.DocsRechnungen WHERE Domain='WA';
GO
CREATE VIEW dbo.abfr_tavkliste AS SELECT * FROM dbo.DocsRechnungen WHERE Domain='TA';
GO
CREATE VIEW dbo.abfr_mrvkliste AS SELECT * FROM dbo.DocsRechnungen WHERE Domain='MR';
GO
CREATE TABLE dbo.ERechnungTaskPlan (
    TaskId int PRIMARY KEY, TaskName nvarchar(180), Domain nvarchar(30), Action nvarchar(30),
    Enabled bit NOT NULL, ScheduleType nvarchar(20), EveryN int, StartTime time,
    WeekdaysMask int, IncludeDuplicates bit NOT NULL, OnlyNewSinceLastRun bit NOT NULL,
    LastRunUtc datetime NULL, LastResult nvarchar(100) NULL, LastRunOk bit NULL
);
INSERT dbo.ERechnungTaskPlan VALUES
(1,N'Demo_Werkstatt_XML_Export',N'Rechnung',N'EXPORT_XML',0,N'DAILY',1,'18:00:00',0,0,0,NULL,NULL,NULL);
GO
SELECT N'Demo-Datenbank angelegt. Keine SMTP-Konfiguration, kein Windows-Task, keine Produktivdaten.' AS Ergebnis;
