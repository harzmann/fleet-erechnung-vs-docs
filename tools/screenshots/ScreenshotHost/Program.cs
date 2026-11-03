using System.Data;
using System.Data.Common;
using System.Globalization;
using System.Reflection;
using System.Runtime.Loader;

internal static class Program
{
    [STAThread]
    private static void Main(string[] args)
    {
        try
        {
            if (args.Length > 1)
                throw new ArgumentException("Erwartet wird optional das Verzeichnis der Original-Viewer-Assembly.");
            CultureInfo.CurrentCulture = CultureInfo.GetCultureInfo("de-DE");
            CultureInfo.CurrentUICulture = CultureInfo.GetCultureInfo("de-DE");
            Application.SetHighDpiMode(HighDpiMode.DpiUnawareGdiScaled);
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            var layout = new log4net.Layout.PatternLayout("%level %message%newline%exception");
            layout.ActivateOptions();
            var appender = new log4net.Appender.FileAppender
            {
                File = Path.Combine(AppContext.BaseDirectory, "demo-host.log"),
                AppendToFile = false,
                Layout = layout
            };
            appender.ActivateOptions();
            log4net.Config.BasicConfigurator.Configure(appender);

            var productDir = args.Length == 1 ? Path.GetFullPath(args[0])
                : Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "product"));
            var viewerPath = Path.Combine(productDir, "EHFleetXRechnung.Viewer.dll");
            var resolver = new AssemblyDependencyResolver(viewerPath);
            AssemblyLoadContext.Default.Resolving += (_, name) =>
            {
                var windowsRuntime = Path.Combine(productDir, "runtimes", "win", "lib", "net8.0", name.Name + ".dll");
                var local = Path.Combine(productDir, name.Name + ".dll");
                var path = File.Exists(windowsRuntime) ? windowsRuntime
                    : File.Exists(local) ? local : resolver.ResolveAssemblyToPath(name);
                return path is null ? null : AssemblyLoadContext.Default.LoadFromAssemblyPath(path);
            };
            var viewer = AssemblyLoadContext.Default.LoadFromAssemblyPath(viewerPath);
            var library = Assembly.Load("ehfleet_classlibrary");
            var databaseType = library.GetType("ehfleet_classlibrary.General+Database", true)!;
            // Fest vorgegebene lokale Demo-Verbindung; weder Registry noch App-Einstellungen lesen.
#if REPORT_DEMO
            var pipe = File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "localdb-pipe.txt")).Trim();
            if (!pipe.StartsWith(@"np:\\.\pipe\LOCALDB#", StringComparison.OrdinalIgnoreCase))
                throw new InvalidOperationException("Nur die vorbereitete lokale Demo-Pipe ist zulässig.");
            var connectionString = $"Provider=SQLOLEDB;Data Source={pipe};Initial Catalog=EHFleet;Integrated Security=SSPI;Persist Security Info=False;";
            const string expectedDatabase = "EHFleet";
#else
            const string connectionString = "Provider=SQLOLEDB;Data Source=.\\SQLEXPRESS;Initial Catalog=EHFleet_Docs_Demo;Integrated Security=SSPI;Persist Security Info=False;";
            const string expectedDatabase = "EHFleet_Docs_Demo";
#endif
            var oleDbType = Assembly.Load("System.Data.OleDb").GetType("System.Data.OleDb.OleDbConnection", true)!;
            using (var preflight = (DbConnection)Activator.CreateInstance(oleDbType, connectionString)!)
                preflight.Open();
            using var db = (IDisposable)Activator.CreateInstance(databaseType, connectionString)!;
            var connection = (DbConnection?)(databaseType.GetField("cn")?.GetValue(db)
                ?? databaseType.GetProperty("cn")?.GetValue(db))
                ?? throw new InvalidOperationException("Keine Demo-Datenbankverbindung vom Originaltyp erhalten. Öffentliche Member: "
                    + string.Join(", ", databaseType.GetMembers().Select(member => member.Name).Distinct()));
            if (connection.State != ConnectionState.Open || connection.Database != expectedDatabase)
                throw new InvalidOperationException("Die fest vorgegebene Demo-Verbindung ist nicht geöffnet.");
            using var check = connection.CreateCommand();
            check.CommandText = "SELECT COUNT(*) FROM dbo.DocsDemoMarker WHERE FixtureVersion=1";
            if (Convert.ToInt32(check.ExecuteScalar()) != 1)
                throw new InvalidOperationException("Die erwartete Aufnahme-Fixture fehlt.");

#if REPORT_DEMO
            DemoScreens.PrepareReport(connection);
            var formType = viewer.GetType("EHFleetXRechnung.Viewer.ReportForm", true)!;
            var billType = viewer.GetType("EHFleetXRechnung.Viewer.RechnungsArt", true)!;
            using var form = (Form)Activator.CreateInstance(formType, db, Enum.Parse(billType, "Werkstatt"), new List<int> { 260101 })!;
#elif LOG_DEMO
            using var form = DemoScreens.CreateLog();
#else
            var formType = viewer.GetType("EHFleetXRechnung.Viewer.RechnungsUebersicht", true)!;
            using var form = (Form)Activator.CreateInstance(formType, db)!;
#endif
            form.StartPosition = FormStartPosition.CenterScreen;
            form.WindowState = FormWindowState.Normal;
            form.Size = new Size(1960, 590);
            var prepared = new HashSet<Form>();
            Application.Idle += (_, _) =>
            {
                // Nur Darstellungsgrößen anpassen, keine Daten oder Geschäftslogik verändern.
                foreach (Form opened in Application.OpenForms)
                {
                    if (!opened.Visible || !prepared.Add(opened)) continue;
                    var kind = opened.GetType().Name;
                    if (kind == "RechnungsUebersicht")
                    {
                        opened.WindowState = FormWindowState.Normal;
                        opened.Size = new Size(1960, 590);
                    }
                    if (kind == "ReportForm")
                    {
                        opened.WindowState = FormWindowState.Normal;
                        opened.Size = new Size(1120, 1130);
                        opened.Location = new Point(100, 40);
                    }
                    if (kind == "ExportLogGridForm") DemoScreens.SizeLog(opened);
                    if (kind is "MengeneinheitenGridForm" or "SteuersaetzeGridForm")
                    {
                        opened.Size = new Size(kind == "SteuersaetzeGridForm" ? 1900 : 1450, 430);
                        var grid = opened.Controls[0];
                        var columns = (System.Collections.IEnumerable)grid.GetType().GetProperty("Columns")!.GetValue(grid)!;
                        foreach (var column in columns)
                        {
                            var name = column.GetType().GetProperty("Name")!.GetValue(column)?.ToString();
                            var width = name switch
                            {
                                "ID" => 45, "Matchcode" => 85, "Kurzbezeichnung" => 350,
                                "MwSt" => 60, "ERechnung_BT151" => 150, "ERechnung_BT120" => 370,
                                "ERechnung_BT121" => 180, "MengeneinheitK" => 115,
                                "MengeneinheitL" => 300, "ERechnung_UnitCode" => 175,
                                "ERechnung_UnitConversion" => 195,
                                "LetzterZugriff_Benutzer" => 190, "LetzterZugriff_Datum" => 165,
                                _ => 80
                            };
                            column.GetType().GetProperty("MinWidth")!.SetValue(column, width);
                        }
                    }
                }
            };
            Application.Run(form);
        }
        catch (Exception exception)
        {
            File.WriteAllText(Path.Combine(AppContext.BaseDirectory, "host-error.txt"), exception.ToString());
            // Kein Verbindungsstring oder Produktivkonfigurationsinhalt in der Fehlermeldung.
            var cause = exception.GetBaseException();
            MessageBox.Show(cause.GetType().Name + ": " + cause.Message,
                "Dokumentations-Screenshot-Host", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }
}
