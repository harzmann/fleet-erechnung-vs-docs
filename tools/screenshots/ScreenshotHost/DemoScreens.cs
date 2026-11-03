using System.Data.Common;
using EHFleetXRechnung.Viewer;
using Stimulsoft.Base.Drawing;
using Stimulsoft.Report;
using Stimulsoft.Report.Components;

internal static class DemoScreens
{
    internal static void PrepareReport(DbConnection connection)
    {
        var report = StiReport.CreateNewReport();
        report.ReportName = "DemoWerkstattrechnung";
        report.ReportAlias = "Werkstattrechnung – fiktives Beispiel";
        report.ReportAuthor = "FLEET Demo";
        var page = report.Pages[0];
        page.Margins = new StiMargins(1.5, 1.5, 1.5, 1.5);
        void Text(string name, string value, double x, double y, double w, double h,
            float size = 11, bool bold = false, StiTextHorAlignment align = StiTextHorAlignment.Left)
        {
            page.Components.Add(new StiText(new RectangleD(x,y,w,h))
            {
                Name = name, Text = value,
                Font = new Font("Arial",size,bold ? FontStyle.Bold : FontStyle.Regular),
                HorAlignment = align, WordWrap = true
            });
        }
        Text("Verkaeufer", "Demo-Werkstatt Elbtal",0,0,18,0.8,19,true);
        Text("Adresse", "Demo-Werkhof 12 · 00000 Demo-Hafenstadt\nrechnung@elbtal.example",0,1,18,1.2);
        Text("Kaeufer", "Demo-Spedition Nordhafen\nDemo-Kai 8\n00000 Demo-Hafenstadt",0,3,10,1.8);
        Text("Kopfdaten", "Rechnungsdatum: 02.11.2026\nKundennummer: 1001\nLeistungsdatum: 02.11.2026",10.5,3,7.5,1.8);
        Text("Titel", "Werkstattrechnung WA-260101",0,5.3,18,1,16,true);
        Text("Auftrag", "Lkw-Inspektion / Filter und Motoröl",0,6.5,18,0.8,12,true);
        Text("Tabellenkopf", "Leistung / Material",0,8,8,0.7,11,true);
        Text("MengeKopf", "Menge",8.2,8,3,0.7,11,true);
        Text("PreisKopf", "Einzelpreis",11.3,8,3,0.7,11,true,StiTextHorAlignment.Right);
        Text("SummeKopf", "Netto",15,8,3,0.7,11,true,StiTextHorAlignment.Right);
        string[,] rows = {{"Werkstattarbeit / Inspektion","3 HUR","95,00 EUR","285,00 EUR"},
            {"Öl- und Kraftstofffilter","2 C62","45,00 EUR","90,00 EUR"},
            {"Motoröl","12 LTR","6,50 EUR","78,00 EUR"}};
        for (var row=0;row<3;row++)
        {
            double y=9+row*1.1;
            Text("Leistung"+row,rows[row,0],0,y,8,0.8);
            Text("Menge"+row,rows[row,1],8.2,y,3,0.8);
            Text("Preis"+row,rows[row,2],11.3,y,3,0.8,11,false,StiTextHorAlignment.Right);
            Text("Summe"+row,rows[row,3],15,y,3,0.8,11,false,StiTextHorAlignment.Right);
        }
        Text("Nettosumme","Netto gesamt:                 453,00 EUR",8.5,13.2,9.5,0.8,12,false,StiTextHorAlignment.Right);
        Text("Steuer","Umsatzsteuer 19 % (S):    86,07 EUR",8.5,14.2,9.5,0.8,12,false,StiTextHorAlignment.Right);
        Text("Brutto","Rechnungsbetrag:           539,07 EUR",8.5,15.4,9.5,1,14,true,StiTextHorAlignment.Right);
        Text("Steuerhinweis","Steuerkategorie S (BT-151); BT-120 und BT-121 bleiben leer.",0,18,18,1);
        Text("Zahlungsziel","Zahlbar innerhalb von 14 Tagen bis zum 16.11.2026.\nDemo-IBAN: DE00 0000 0000 0000 0000 00 (nicht verwendbar)",0,20,18,1.6);
        Text("DemoHinweis","FIKTIVES ANSCHAUUNGSBEISPIEL\nKeine Zahlungsaufforderung. Absender, Empfänger und Bankangaben sind Demo-Daten.",0,24,18,2,11,true);
        var template=Path.Combine(AppContext.BaseDirectory,"demo-werkstatt.mrt");
        report.Save(template);
        using var command=connection.CreateCommand();
        command.CommandText="UPDATE dbo.Parameter SET [Text]=? WHERE ParameterNr=210";
        var parameter=command.CreateParameter(); parameter.Value=template;
        command.Parameters.Add(parameter); command.ExecuteNonQuery();
    }

    internal static Form CreateLog() => new ExportLogGridForm(new List<ExportLogEntry>
    {
        new() { RechnungsNummer=260101, Timestamp=new DateTime(2026,11,3,9,15,0,DateTimeKind.Utc),
            Status="Fehler", FehlerInfo="LandISO fehlt bei Kunde Demo-Spedition Nordhafen.\r\nLänderkennung ergänzen und die Rechnung erneut prüfen.",
            EmailEmpfaenger="rechnung@nordhafen.example",EmailStatus="Nicht versendet" },
        new() { RechnungsNummer=260102, Timestamp=new DateTime(2026,11,3,9,16,0,DateTimeKind.Utc),
            Status="Fehler", FehlerInfo="EmailRechnung fehlt bei Kunde Demo-Transport Westtor.\r\nRechnungs-E-Mail in der Kundenpflege ergänzen.",
            EmailStatus="Nicht versendet",EmailFehlerInfo="Keine E-Mail-Adresse im Datensatz gefunden." },
        new() { RechnungsNummer=260103, Timestamp=new DateTime(2026,11,3,9,17,0,DateTimeKind.Utc),
            Status="Validator-Fehler", FehlerInfo="Beispiel BR-S-10: Für Steuerkategorie S dürfen BT-120 und BT-121 nicht gefüllt sein.\r\nBefreiungsgrund entfernen und erneut validieren.",
            EmailEmpfaenger="rechnung@nordhafen.example",EmailStatus="Nicht versendet" }
    });

    internal static void SizeLog(Form form)
    {
        form.Size=new Size(2420,550);
        form.WindowState=FormWindowState.Normal;
        form.Location=new Point(30,100);
        var grid=form.Controls.Find("ExportLogGrid",true).OfType<DataGridView>().Single();
        grid.AutoSizeRowsMode=DataGridViewAutoSizeRowsMode.AllCells;
        grid.Columns["colFehlerInfo"].Width=620;
        grid.Columns["colStatus"].Width=150;
        grid.Columns["colExportFilePath"].Width=150;
        grid.Columns["colValidatorBericht"].Width=170;
        grid.Columns["colEmailFehlerInfo"].Width=300;
    }
}
