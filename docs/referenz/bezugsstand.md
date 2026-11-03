# Bezugsstand und bekannte Grenzen

## Geprüfter Stand

Dokumentationsdatum: **3. November 2026**, Zeitzone **Europe/Berlin**.

Produktrepository: [harzmann/fleet-erechnung-vs](https://github.com/harzmann/fleet-erechnung-vs). Grundlage ist der lokale Zweig `main` bei Commit [`878c3504bddc37d0dd91f7a2cae9c75a5d34756f`](https://github.com/harzmann/fleet-erechnung-vs/commit/878c3504bddc37d0dd91f7a2cae9c75a5d34756f), **einschließlich des bei der Dokumentation vorgefundenen nicht committeten Arbeitsstands**. Der verlinkte Commit allein enthält diese lokalen Abweichungen nicht.

Die Änderungen betreffen:

- `EHWinFormViews.App/StartUp.vb` und das zugehörige App-Projekt: Programmstart und Request-/CLI-Anbindung.
- `EHWinFormViews/RechnungsUebersicht.vb`, `InvoiceActions.vb` und das Viewer-Projekt: Rechnungsaktionen und Einbindung.
- Die Solution sowie die technische CliTester-Dokumentation.
- Zusätzlich war ein nicht versionierter Ordner `bewerbung/` vorhanden; dessen Inhalte wurden nicht in dieses Handbuch übernommen.

Die vollständige Dateiliste und SHA-256-Fingerabdrücke der für das Handbuch relevanten Dateien stehen im [Quellenregister des Doku-Repos](https://github.com/harzmann/fleet-erechnung-vs-docs/blob/main/source-register.json). Es enthält Dateipfade und Prüfsummen, keine Datenbankinhalte, Kennwörter oder Verbindungszeichenfolgen.

## Welche Quelle belegt welchen Bereich?

| Bereich | Maßgebliche Produktquellen |
| --- | --- |
| Rechnungsübersicht, Auswahl, Einzel- und Sammelaktionen | `RechnungsUebersicht.vb` und zugehörige Designerdatei |
| Verkäufer und Parameterregister | `ParameterEditorForm.vb` und Designerdatei |
| Sofortige Speicherung der Tabellenfelder | `MengeneinheitenGridForm.vb`, `SteuersaetzeGridForm.vb` |
| Kundenprüfung, Mengen, Steuern, Festschreibung, Dateipfade | `XRechnungExporter.vb` |
| SMTP und Versandablauf | `XRechnungEmail.vb` |
| Taskdialog und Registrierung | `ERechnungTaskPlanManagerForm.vb`, `ERechnungTaskSchedulerFacade.vb`, `TaskSchedulerService.vb` |
| Automatische Auswahl und Einzelverarbeitung | `ERechnungTaskRunner.vb` und `ERechnungTaskRunRepository.vb` |
| Ergebnisanzeige und Berichte | `ExportLogGridForm.vb`, `ReportForm.vb` |
| Programmstart und integrierte Aktionen | `StartUp.vb`, `ApplicationEvents.vb`, `InvoiceActions.vb` |
| Unterstützte Enumwerte und VATEX-Serialisierung | Tatsächlich referenziertes NuGet-Paket `ZUGFeRD-csharp 17.4.0`; dessen Assembly und XML-Dokumentation wurden geprüft |

Der zusätzlich im Produktrepo vorhandene Ordner `ZUGFeRD/` ist nicht mit der tatsächlich referenzierten NuGet-Version gleichzusetzen. Aussagen zur Unterstützung der Beispielcodes wurden deshalb am Paket und nicht allein an diesen lokalen Bibliotheksquellen geprüft.

## Bekannte Grenzen mit Bedeutung für Anwender

| Beobachtung im geprüften Code | Konsequenz |
| --- | --- |
| MR besitzt im zentralen XML-Erzeugungsablauf keinen Zweig zur Übernahme von Rechnungspositionen | MR ist auswählbar, aber ein vollständiger Export wurde nicht bestätigt; keine produktive Freigabe allein aus der sichtbaren Schaltfläche ableiten |
| TA/MR-Verkäuferpflege schreibt `Strasse`, der Exporter liest `Straße` | Tatsächliche Verkäuferstraße und Datenbankschema prüfen |
| Verkäuferland ist DE, Währung ist EUR | Abweichende Länder-/Währungsfälle sind hier nicht allgemein abgebildet |
| Ungültige Einheit kann zu `C62`, ungültige Steuerkategorie zu `S` werden | Fehlerhafte Stammdaten können ohne eindeutige Fehlermeldung fachlich falsch ausgegeben werden |
| VATEX-Parser verlangt Enum-Namen mit Unterstrichen, automatische Standardcodes werden teils mit Bindestrichen ergänzt | Codeeingabe ausdrücklich pflegen und tatsächliche Ausgabe prüfen |
| Ein Export ohne Festschreibung führt nicht automatisch die externe Validierung aus | Vor Weitergabe gesondert **Validator** verwenden |
| Datenbank-Speicherfehler werden in einem internen Speicheraufruf abgefangen und gemeldet, aber nicht immer an den Aufrufer weitergeworfen | Nach Speichermeldungen Status und gespeicherten Beleg kontrollieren; „Erfolgreich“ allein beweist keine vollständig abgeschlossene Speicherung |
| Mehrere Speicheroperationen erfolgen nacheinander; Sammelläufe sind keine gemeinsame Transaktion | Ein Fehler oder Abbruch setzt bereits erzeugte Dateien, Statusänderungen oder E-Mails nicht zurück |
| Verschiedene „Alle“-Pfade ermitteln Rechnungen über Tabellen-/Zeilenindizes | Für eine gezielte Teilmenge **Ausgewählte** verwenden; keine pauschale Zusage einer sicheren Eingrenzung durch Sortierung/Filter |
| Eine leere Rechnungsabfrage wird wie eine fehlgeschlagene Datenbankabfrage behandelt | Eine Fehlermeldung kann auch einen leeren Bestand betreffen |
| Task-Deltafilter verwendet Rechnungsdatum statt Erfassung oder Änderung | Rückdatierte oder taggleiche später erfasste Rechnungen können ausgelassen werden |
| Fehlende Empfänger und Duplikate können bei automatischen Läufen übersprungen werden, ohne den Lauf scheitern zu lassen | Einzelprotokolle zusätzlich zum Gesamtergebnis prüfen |
| Task-Registrierung verwendet ein interaktives Benutzerkonto; einige Windows-Fehler werden unterdrückt | Ausführbarkeit, Anmeldung, alte Tasknamen und Entfernung in der Windows-Aufgabenplanung prüfen |
| Java wird als `java` gestartet, die zusätzliche JRE_HOME-Prüfung löst den Variablenwert nicht zuverlässig auf | Java-Erreichbarkeit und tatsächlichen Prozessstart prüfen |

Die Handbücher dokumentieren diese Beobachtungen; sie ändern den Produktcode nicht. Insbesondere werden keine uneingeschränkte Normkonformität, revisionssichere Archivierung oder qualifizierte elektronische Signatur zugesagt. Der vorhandene Speicherpfad berechnet einen SHA-256-Hash; daraus allein folgt keine solche Signatur.

## Durchgeführte und ausstehende Nachweise

Durchgeführt wurden der statische Abgleich der beschriebenen Oberfläche und Abläufe, die Prüfung der verwendeten Standardcodes anhand offizieller Quellen sowie die Kontrolle der sechs Einheiten und fünf VATEX-Beispiele gegen die eingebundene Paket-Assembly. Die Beispielumrechnungen wurden unabhängig nachgerechnet.

Die Dokumentation wird mit `mkdocs build --strict` gebaut und auf interne Links, Anker, Suchindex und das Fehlen von Release-Downloadlinks geprüft. Veröffentlichte Seiten werden zusätzlich auf Erreichbarkeit und Darstellung kontrolliert.

Es wurden **keine produktiven Stammdaten geändert, keine echten Rechnungen verarbeitet und keine E-Mails versendet**. Eine vollständige Ende-zu-Ende-Freigabe von Anwendung, Datenbankschema und lokalem Validator ist damit nicht behauptet. Dafür dient die [Checkliste der ersten Rechnung](../vorbereitung/checkliste.md) in der dafür vorgesehenen Umgebung.
