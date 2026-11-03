# XML und Hybrid-PDF exportieren

Für einen Export benötigen Sie vollständige Stammdaten und einen beschreibbaren [Ausgabepfad](../vorbereitung/firma.md). Wählen Sie das Format nach der Vorgabe des Rechnungsempfängers.

## Einzelne oder ausgewählte Rechnungen

1. Wählen Sie die Rechnungsart.
2. Markieren Sie die gewünschten Rechnungen.
3. Wählen Sie **Export → Ausgewählte → XML** oder **PDF**. Alternativ verwenden Sie die Zeilenaktion **XML** beziehungsweise **PDF**.
4. Beantworten Sie die Rückfrage zur Festschreibung bewusst; die Bedeutung steht im folgenden Abschnitt.
5. Kontrollieren Sie nach dem Lauf das Ergebnisprotokoll und den dort genannten Dateipfad.

## Was bedeutet Festschreiben?

| Antwort / Ausgangszustand | Verhalten |
| --- | --- |
| Noch nicht festgeschrieben, Antwort **Ja** | XML erzeugen, validieren und bei erfolgreicher Verarbeitung in der Datenbank speichern; Status auf `Issued` setzen und sperren |
| Noch nicht festgeschrieben, Antwort **Nein** | Export aus aktuellen Daten ohne diese Festschreibung; die vollständige externe Validierung ist dabei nicht automatisch Bestandteil der XML-Erzeugung |
| Bereits festgeschrieben | Rückfrage zum Duplikat-Export; bei Zustimmung gespeicherte XML verwenden |

!!! warning "Nein bedeutet hier Export ohne Festschreibung"
    **Nein** in der Festschreibungsfrage bricht den Export einer noch nicht festgeschriebenen Rechnung nicht ab. Prüfen Sie eine solche Datei gesondert über **Validator**, bevor Sie sie weitergeben.

Beim Hybrid-PDF wird zusätzlich das Rechnungsbild erzeugt und die XML eingebettet. Bei einer bereits festgeschriebenen Rechnung wird vorhandenes PDF-Material verwendet; fehlt es, kann das Rechnungsbild neu erzeugt werden. Ein Hybrid-Duplikat ist deshalb nicht zwingend bytegleich mit einer früheren PDF-Datei. Die XML stammt aus dem gespeicherten Bestand.

Stammdatenänderungen aktualisieren eine festgeschriebene XML nicht. Für fachliche Korrekturen ist der im Unternehmen vorgesehene Rechnungs-Korrekturprozess zu verwenden; dieses Modul bietet keine Funktion „Festschreibung aufheben“.

## Alle Rechnungen exportieren

1. Kontrollieren Sie die aktuelle Rechnungsart und den Umfang der Liste.
2. Wählen Sie **Export → Alle → XML** oder **PDF**.
3. Bestätigen Sie die Rückfrage zum Export aller Rechnungen.
4. Für noch nicht festgeschriebene Rechnungen beantworten Sie die gemeinsame Festschreibungsfrage.
5. Bereits festgeschriebene Rechnungen können weitere Duplikat-Rückfragen auslösen.
6. Prüfen Sie alle Ergebnisse, auch wenn der Lauf bis zum Ende durchgelaufen ist.

Einzelne Fehler können neben erfolgreichen Rechnungen auftreten. Der Lauf ist keine gemeinsame Transaktion für alle Belege.

## Fortschritt und Abbruch

Bei der Verarbeitung **Alle** erscheint ein Fortschrittsfenster. Mit dessen Abbruchfunktion beenden Sie die weitere Verarbeitung. Die Abbruchanforderung wird zwischen Rechnungen geprüft. Bereits exportierte oder festgeschriebene Rechnungen bleiben verarbeitet; eine laufende Einzelverarbeitung wird dadurch nicht zuverlässig sofort unterbrochen. Im Ergebnisprotokoll erscheint ein zusätzlicher Abbrucheintrag.

Für **Ausgewählte** ist in der geprüften Implementierung kein entsprechender Fortschrittsdialog mit Abbruch vorgesehen.

## Wo liegen die Dateien?

Unter dem je Rechnungsart hinterlegten Basispfad legt das Programm einen Unterordner an:

| Rechnungsart | Unterordner |
| --- | --- |
| WA | `Werkstatt` |
| TA | `Tanken` |
| MR | `Manuell` |

Der Dateiname enthält die nach FLEET-Einstellung formatierte Rechnungsnummer und einen lokalen Zeitstempel `yyyyMMdd_HHmmss`. XML endet auf `.xml`, Hybrid-PDF auf `.hybrid.pdf`. Beispielhaft: `WA-000123_20261103_101500.xml`; die tatsächliche Nummernformatierung kann abweichen.

Der Protokollpfad ist eine Orientierung. Kontrollieren Sie, ob die Datei tatsächlich vorhanden und verwendbar ist. Ein fehlgeschlagener Vorgang kann Teildateien hinterlassen; siehe [Fehlerbehebung](pruefung.md).
