# Checkliste für die erste Rechnung

Beginnen Sie mit einer einzelnen, fachlich freigegebenen Rechnung in einer dafür vorgesehenen Umgebung. Ein Test ohne Versand kann über Vorschau, Validator und Export ohne Festschreibung erfolgen. Der Versand und ein Taskplaner-Start sind dagegen echte Verarbeitungsschritte.

## Vor der Prüfung

- [ ] Datenbankverbindung und zur Version passende Erweiterungen sind vorhanden.
- [ ] Firmenname, Anschrift, USt.-ID und Kontakt sind für die gewählte Rechnungsart gepflegt.
- [ ] Elektronische Verkäuferadresse, Bankverbindung und Ausgabepfad sind geprüft.
- [ ] Der Benutzer kann in den Exportordner und die benötigten Unterordner schreiben.
- [ ] Kundenname und Rechnungsadresse stimmen im konkreten Beleg.
- [ ] `LandISO` ist korrekt und `EmailRechnung` ist vollständig und abgestimmt.
- [ ] Verlangte Käuferreferenz beziehungsweise Leitweg-ID und steuerliche Identifikationen sind geklärt.
- [ ] Rechnungsdatum, Lieferdatum, Zahlungsziel und gegebenenfalls Skonto stimmen.
- [ ] Jede verwendete Mengeneinheit hat einen unterstützten Code und den richtigen positiven Faktor.
- [ ] Alle Positionen enthalten die richtige Steuerkategorie, den passenden Satz und erforderliche Befreiungsgründe.
- [ ] Die Ausgabe ist für die verwendete Rechnungsart geprüft und freigegeben.

## Einzelbeleg kontrollieren

1. Wählen Sie die richtige Rechnungsart und öffnen Sie **Bericht** für die einzelne Rechnung.
2. Vergleichen Sie Anschriften, Positionen, Mengen, Preise, Steuern und Summen mit dem fachlich freigegebenen Beleg.
3. Klicken Sie auf **Validator**. Öffnen Sie den HTML-Bericht und beheben Sie jeden fachlich relevanten Fehler.
4. Exportieren Sie die einzelne Rechnung als **XML**. Wenn noch keine Festschreibung gewünscht ist, beantworten Sie die Festschreibungsfrage mit **Nein**; dies erzeugt trotzdem eine Datei.
5. Kontrollieren Sie Exportdatei, Empfängerreferenz, Länderkennung, Unitcodes, umgerechnete Mengen und Preise sowie Steueraufschlüsselung.
6. Falls Hybrid-PDF benötigt wird, exportieren und öffnen Sie auch dieses und prüfen Sie das Rechnungsbild sowie die enthaltene XML mit einem dafür geeigneten Betrachter.
7. Wiederholen Sie den Einzelbelegtest je verwendeter Rechnungsart und Steuerkategorie. MR erfordert wegen der belegten Positionsgrenze vorab eine Klärung.

## Vor dem ersten echten Versand

- [ ] Gewünschtes Format und Übermittlungsweg sind mit dem Empfänger abgestimmt.
- [ ] Die Rechnung darf festgeschrieben werden; es sind keine ungeklärten Inhaltsfehler mehr vorhanden.
- [ ] SMTP ist eingerichtet; die tatsächliche Absenderadresse stimmt.
- [ ] Der Empfänger der ausgewählten Rechnung wurde unmittelbar vor dem Versand kontrolliert.
- [ ] Es ist geklärt, ob bereits eine E-Mail zu dieser Rechnung versendet wurde.

Führen Sie anschließend nur den ausdrücklich vorgesehenen Einzelversand aus und prüfen Sie dessen Ergebnisprotokoll. Die Schaltfläche **Email → Ausgewählte** startet den Versand unmittelbar. Geben Sie die Sammelverarbeitung erst nach erfolgreich kontrolliertem Einzelablauf frei.

## Vor einer automatischen Aufgabe

Prüfen Sie Domäne, Aktion, Zeitplan, Benutzerkontext und beide Auswahloptionen des [Taskplaners](../handbuch/taskplaner.md). Berücksichtigen Sie insbesondere, dass „Nur neue Rechnungen“ nach Rechnungsdatum filtert und ein erfolgreicher Lauf übersprungene Rechnungen enthalten kann. Kontrollieren Sie den ersten tatsächlichen Lauf anhand seiner Einzeleinträge.
