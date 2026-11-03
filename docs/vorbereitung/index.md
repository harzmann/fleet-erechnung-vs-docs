# Vorbereitung und Stammdaten

Dieses Handbuch richtet sich an die Stammdatenpflege und die Administration. Ziel ist, dass ein Endanwender eine fachlich vollständige Rechnung prüfen, exportieren und bei Bedarf versenden kann.

## In dieser Reihenfolge einrichten

1. [Technische Voraussetzungen](technik.md) prüfen: Verbindung, Datenbankerweiterungen, Validator, Java und Schreibrechte.
2. [Firmenstammdaten und Verkäufer](firma.md) für jede verwendete Rechnungsart pflegen.
3. [Kunden und Rechnungsdaten](kunden.md) vervollständigen.
4. Alle tatsächlich verwendeten [Mengeneinheiten](mengeneinheiten.md) mit gültigem Code und passendem Faktor versehen.
5. [Steuersätze und BT-Felder](steuersaetze.md) fachlich zuordnen und in den Rechnungspositionen prüfen.
6. Eine einzelne Rechnung anhand der [Checkliste](checkliste.md) vollständig kontrollieren.
7. Erst anschließend Sammelverarbeitung und [Taskplaner](../handbuch/taskplaner.md) verwenden.

## Wo werden Daten gepflegt?

| Angaben | Zuständiger Einstieg |
| --- | --- |
| Firmenanschrift, USt.-ID, Kontakt, Bankverbindung und Ausgabepfad | **Stammdaten → Verkäufer** in der Rechnungsübersicht |
| Zuordnung vorhandener Mengeneinheiten zur E-Rechnung | **Stammdaten → Mengeneinheiten** |
| E-Rechnung-Kategorien und Befreiungsgründe vorhandener Steuersätze | **Stammdaten → Steuersätze** |
| Kunden, Rechnungsanschrift, Rechnungsposten und Zahlungsbedingungen | Zuständige Pflege im FLEET-Hauptsystem; das geprüfte Modul enthält keinen Kundeneditor |
| SMTP, Datenbankanbindung und Validatorinstallation | Administration; im Verkäuferdialog nicht vollständig einstellbar |

In den Tabellenfenstern für Einheiten und Steuern sind nur die gelb markierten E-Rechnung-Felder editierbar. Änderungen werden beim Übernehmen des Zellwerts direkt gespeichert. Es gibt dort keinen gemeinsamen Speichern- oder Rückgängig-Schalter. Das Schließen des Fensters verwirft bereits gespeicherte Zellen nicht.

## Pflichtangaben verstehen

Die folgenden Kapitel unterscheiden Angaben, die das Programm ausdrücklich auf Leerwerte prüft, Angaben aus dem Rechnungsstandard und Daten, die vom konkreten Geschäftsfall abhängen. Ein Feld ohne sofortige Eingabeprüfung ist deshalb nicht automatisch entbehrlich. Maßgeblich bleibt das Ergebnis der vollständigen Validierung zusammen mit der fachlichen Kontrolle.

Die Beispiele zeigen gültige Codes und nachvollziehbare Zuordnungen. Die zutreffende steuerliche Behandlung legt die zuständige Fachstelle für den jeweiligen Umsatz fest. [Offizielle Quellen](../referenz/quellen.md) und [bekannte Implementierungsgrenzen](../referenz/bezugsstand.md) sind separat aufgeführt.
