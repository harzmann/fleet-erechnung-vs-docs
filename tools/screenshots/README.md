# Originalfenster für Dokumentationsaufnahmen

Diese Werkzeuge öffnen die echten WinForms-Klassen aus dem Produktprojekt gegen einen ausschließlich synthetischen Datenbestand. Sie zeichnen keine Oberfläche nach. Fenstergrößen und minimale Spaltenbreiten werden für lesbare Aufnahmen angepasst; Feldbezeichnungen, Datenbindung und Geschäftslogik stammen aus den Originalformularen.

## Voraussetzungen

- Windows, .NET-8-SDK und die vorhandene FLEET-Entwicklungsumgebung einschließlich der benötigten kommerziellen Bibliotheken beziehungsweise ihres Paketcache.
- Lokale Instanz `.\SQLEXPRESS`, Windows-Anmeldung mit Berechtigung zum Anlegen einer neuen Datenbank und ein verfügbarer SQLOLEDB-Provider.
- Produktrepo `ehfleet_vb6guidll` und dessen referenziertes `ehfleet_classlibrary` als benachbarte Checkouts zum Doku-Repo. Alternativ den Produktprojektpfad ausdrücklich übergeben.
- Die DB `EHFleet_Docs_Demo` darf für die erstmalige Einrichtung noch nicht existieren.

Die SQL-Fixture ist **kein vollständiges FLEET-Datenbankschema, keine Migration und keine Export-Testdatenbank**. Sie enthält nur die für die Aufnahmen benötigten Tabellen und Listenabfragen. Insbesondere zeigt die vereinfachte Steuersatztabelle `MwSt` direkt als Prozentzahl. Die fiktiven Steuer-/Bankidentifikationen eignen sich nicht für einen erfolgreichen Rechnungsvalidierungstest.

## Demo-Datenbank einmalig anlegen

Im Hauptverzeichnis dieses Repos:

```powershell
sqlcmd -S .\SQLEXPRESS -E -C -b -f 65001 -i tools/screenshots/demo.sql
```

Das Skript verweigert die Ausführung, sobald eine Datenbank dieses Namens existiert. Es überschreibt, leert oder löscht keinen vorhandenen Bestand. Die Markertabelle `DocsDemoMarker` kennzeichnet die neue Datenbank als Aufnahme-Fixture.

## Originalfenster starten

```powershell
./tools/screenshots/start.ps1
```

Bei abweichendem Checkout-Pfad:

```powershell
./tools/screenshots/start.ps1 -ProductProject 'C:\Quellen\ehfleet_vb6guidll\EHWinFormViews\EHFleetXRechnung.Viewer.vbproj'
```

Das Skript baut den separaten Host mit einer Projektreferenz auf die unveränderten Produktquellen. Die öffentlichen Paketabhängigkeiten werden über NuGet aufgelöst; die kommerziellen beziehungsweise internen Produktpakete müssen bereits im Paketcache der autorisierten Entwicklungsumgebung vorhanden sein. Zugangsdaten oder Bibliotheksdateien werden nicht in dieses Repo übernommen.

Der Host prüft die fest vorgegebene lokale Demo-Verbindung und den Fixture-Marker. Er liest keine FLEET-Registry-Verbindungen oder benutzerspezifischen Programmeinstellungen. Build-Ausgaben, lokale Diagnoseprotokolle und Binärdateien bleiben im ignorierten `.qa/`-Verzeichnis; `bin/` und `obj/` sind ebenfalls ignoriert.

## Sieben Aufnahmen erzeugen

1. Übersicht **WA**: drei fiktive Werkstattaufträge.
2. Übersicht **TA**: Diesel-/AdBlue-Abrechnungen.
3. **Stammdaten → Verkäufer → Firmenstammdaten**.
4. Im Verkäuferdialog **ERechnung WA**; bei schmalem Dialog über die Registerpfeile beziehungsweise Strg+Tab erreichbar.
5. **Stammdaten → Mengeneinheiten**.
6. **Stammdaten → Steuersätze**.
7. **Taskplaner → Administration**: der vorbereitete Plan ist deaktiviert und besitzt keinen ausgeführten Lauf.

Nur öffnen und ansehen. **Nicht** auf Versand, Export, Speichern im Taskmanager, Starten oder Windows-Task aktualisieren klicken. Es gibt absichtlich keine SMTP-Konfiguration. Der Demo-Plan wurde per SQL angelegt, nicht als Windows-Aufgabe registriert.

Fensteraufnahmen mit dem Computer-Use-Werkzeug erstellen und nach Sichtprüfung unter `docs/assets/screenshots/` speichern. Die Aufnahmen vom 3. November 2026 wurden mit `@oai/sky.get_window_state` erfasst. Dessen JPEG-Bilddaten wurden ohne Änderung der dekodierten Pixel in PNG umkodiert. Es wurden keine Inhalte übermalt, nachgebildet oder ausgetauscht. Originale bleiben lokal im ignorierten `.qa/captures/`-Verzeichnis.

`docs/assets/screenshots/manifest.json` enthält Dateinamen, Fensterbezeichnungen, Abmessungen, Prüfsummen und den Fingerabdruck der verwendeten Original-Viewer-Assembly. Der SQL-Fingerprint verwendet UTF-8 mit normalisierten LF-Zeilenenden, damit er unter Windows und im Linux-Build übereinstimmt. Keine EXE, DLL, Zugangsdaten oder eigentlichen Datenbankdateien veröffentlichen.

## Veröffentlichungsprüfung

Prüfen Sie alle sichtbaren Werte auf ausschließlich fiktive Inhalte, die Übereinstimmung mit den Handbuchbeispielen und die Lesbarkeit der echten Feldnamen. Die Screenshots belegen die dargestellte Oberfläche, keine erfolgreiche Validierung, Festschreibung oder Ausführung eines Exportplans.

Anschließend im Repo-Hauptverzeichnis `python -m mkdocs build --strict` und `python tools/check_site.py` ausführen. Bilder müssen im Text verlinkt, mit Alternativtext und der Kennzeichnung „Original-Anwendungsfenster mit fiktiven Demo-Daten“ versehen sein. Die Bildlinks öffnen die volle Auflösung. Die Datenbank bleibt als klar markierte Demo-Fixture für spätere Aufnahmen erhalten; das Werkzeug enthält keinen automatischen Löschschritt.
