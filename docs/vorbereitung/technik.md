# Technische Voraussetzungen

Dieses Kapitel dient der Administration. Es beschreibt die vom vorhandenen Programm benötigte Umgebung und die Abgrenzung zu den Stammdaten. Installation und Aktualisierung erfolgen über den vereinbarten Bereitstellungsweg des Unternehmens; dieses Portal stellt keine Softwarepakete bereit.

## Anwendung und Datenbank

Die Anwendung benötigt eine funktionsfähige FLEET-Datenbankanbindung. Der Startdialog kann je Einstellung die Verbindung des FLEET-Clients aus der Windows-Benutzerregistrierung oder die hinterlegte Anwendungseinstellung verwenden. Der Registry-Modus erwartet den Wert `workdbcn` unter `HKEY_CURRENT_USER\Software\VB and VBA Program Settings\EHFleet Fuhrpark IM System\Allgemein`.

Die gewählte Verbindung muss unter dem tatsächlich ausführenden Benutzer funktionieren, auch für Taskplaner-Aufrufe. Speichern oder veröffentlichen Sie keine echten Verbindungszeichenfolgen in der Dokumentation.

Die Datenbank muss die zur Anwendung passenden E-Rechnung-Erweiterungen enthalten: Steuer- und Einheitenfelder, benötigte Rechnungsabfragen sowie Speicher- und Versandtabellen. Für automatische Aufgaben kommen `ERechnungTaskPlan`, `ERechnungTaskRun` und die zugehörigen Logdaten hinzu. Die vorhandene technische Notiz `DB_Update_EHFleet_4_18_5.md` im Produktrepo ist eine Orientierung, keine Bestätigung einer ausgeführten Migration und enthält die bekannte vertauschte Beschreibung von BT-120/121. Änderungen an einer produktiven Datenbank sind nicht Teil dieser Handbuch-Einrichtung.

## Java und Validator

Die geprüfte Anwendung sucht im Programmordner unter anderem:

```text
validator/validator-1.5.2-standalone.jar
validator/configuration/EN16931-UBL-validation.xslt
validator/configuration/scenarios.xml
logs/html/
```

Die vollständige zur Anwendung passende Validator-Konfiguration und Java müssen vorhanden sein. Der Prozess wird als `java` gestartet; diese ausführbare Datei muss im Suchpfad des ausführenden Benutzers erreichbar sein. Der Benutzer benötigt Schreibrechte für temporäre Dateien, HTML-Berichte und Exportordner. Prüfen Sie die Ausführung anhand einer einzelnen bekannten Rechnung über **Validator**.

Im Quellcode steht die Java-Ermittlung als `Environment.ExpandEnvironmentVariables("JRE_HOME")`. Das ist keine verlässliche Auflösung des Werts einer Umgebungsvariablen. Es wird hier daher keine universelle Installationsanleitung „JRE_HOME setzen genügt“ zugesagt. Bei Startfehlern muss die Administration die tatsächlich ausgeführte Java-Kommandozeile und die eingesetzte Programmversion prüfen.

Die Validierung richtet sich nach der installierten Konfiguration. Neu veröffentlichte offizielle Codelisten werden nicht automatisch zur Unterstützung durch die Anwendung oder deren Validator. Stimmen Sie Programm und Regelwerk miteinander ab.

## SMTP-Konfiguration

Der Verkäuferdialog richtet SMTP nicht ein. Der Mailer liest folgende Angaben aus dem Datensatz mit **ParameterNr 6101**:

| Feld | Verwendung |
| --- | --- |
| `Modul4` | Tatsächliche E-Mail-Absenderadresse |
| `Modul5` | SMTP-Server |
| `Modul6` | Benutzername, falls eine Anmeldung verwendet wird |
| `Modul7` | Zugehöriges Kennwort |
| `Modul8` | SMTP-Port; bei leerem oder nicht lesbarem Wert wird 25 verwendet |
| `Text` | Betreffvorlage; `[RGNR]` wird durch die formatierte Rechnungsnummer ersetzt |

Der Versand setzt `EnableSsl = True`. Der Server und Port müssen zum vorhandenen SMTP-Verfahren passen. Eine OAuth-Einrichtung oder eine Auswahl anderer Authentifizierungsverfahren ist im geprüften Dialog nicht implementiert. Zugangsdaten werden ausschließlich über die zuständige vorhandene Parameterpflege verwaltet; sie gehören nicht in Beispieldateien oder Screenshots.

Der Nachrichtentext kann aus **ParameterNr 6102**, Feld `Text`, stammen. Wenn ein Feld `Aktiv` vorhanden und gesetzt ist, berücksichtigt die Implementierung dessen erkannte Aktivwerte. Ohne verwendbare Vorlage werden die programmierten Standardtexte eingesetzt.

Die Mailer-Protokollierung ist im Quellcode unter `logs/EHFleetXRechnungSmtp.log` vorgesehen; die tatsächliche Ausgabe hängt auch von der Logkonfiguration ab. Erfolgreiche SMTP-Übergabe ist keine Zustell- oder Annahmebestätigung durch den Rechnungsempfänger.

## Aufgabenplanung

Die Windows-Aufgaben liegen im Ordner `\EHFleetXRechnung`. Die registrierte Aktion verweist auf die aktuell verwendete Programmdatei; nach einem Programmumzug ist die Registrierung zu prüfen. Die Anwendung muss dort ihren Parameter `--run-task` verarbeiten können. Registrierungen aus einem anderen Hostprozess sind deshalb vor Nutzung gesondert zu prüfen.

Der vorhandene Mechanismus verwendet einen interaktiven Benutzer, fordert erhöhte Ausführung an und setzt das Arbeitsverzeichnis auf den Programmordner. Ein angemeldeter Benutzer sowie Datenbank-, Export- und gegebenenfalls SMTP-Zugriff sind Voraussetzung für den vorgesehenen Ablauf. Details: [Taskplaner-Handbuch](../handbuch/taskplaner.md).
