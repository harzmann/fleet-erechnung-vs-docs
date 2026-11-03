# Rechnungen per E-Mail versenden

Der Versand verwendet die beim Kunden hinterlegte Rechnungs-E-Mail-Adresse `EmailRechnung`. Eine freie Empfängereingabe ist in der geprüften Rechnungsübersicht nicht vorgesehen. Die Administration muss zuvor die [SMTP-Konfiguration](../vorbereitung/technik.md) einrichten.

## Ausgewählte Rechnungen versenden

1. Wählen Sie die Rechnungsart und markieren Sie die gewünschten Rechnungen.
2. Kontrollieren Sie die Empfängerangaben in der Liste beziehungsweise der zuständigen Kundenpflege.
3. Wählen Sie **Email → Ausgewählte → XML** oder **PDF**.
4. Lesen Sie anschließend **Status**, **E-Mail-Empfänger**, **E-Mail-Status** und **E-Mail-Fehlerinfo** im Ergebnisprotokoll.

!!! warning "Versand startet unmittelbar"
    Die Schaltflächen unter **Ausgewählte** rufen den Versand ohne zusätzliche allgemeine Bestätigungsfrage auf. Noch nicht festgeschriebene Rechnungen werden dabei zur Festschreibung und Validierung übergeben. Bereits festgeschriebene Rechnungen können erneut versendet werden, ohne die Duplikat-Rückfrage des manuellen Exports.

**XML** versendet die strukturierte Rechnungsdatei; **PDF** das Hybrid-PDF. Das ist ein Versand und kein Öffnen eines E-Mail-Entwurfs.

## Alle Rechnungen versenden

1. Kontrollieren Sie Rechnungsart, Umfang und Empfänger besonders sorgfältig.
2. Wählen Sie **Email → Alle → XML** oder **PDF**.
3. Bestätigen Sie die Rückfrage zum Versand aller Rechnungen.
4. Beobachten Sie das Fortschrittsfenster und kontrollieren Sie nach Abschluss die Ergebnisse je Rechnung.

Ein Abbruch wird zwischen Rechnungen berücksichtigt. Bereits versendete E-Mails lassen sich damit nicht zurückholen. Die ausgewählte Teilmenge wird bei **Alle** nicht als Begrenzung verwendet.

## Ergebnis bewerten und erneut senden

**E-Mail gesendet** bedeutet, dass der Versandaufruf erfolgreich war. Daraus folgt keine Bestätigung, dass der Empfänger die Nachricht gelesen oder seine Rechnungsprüfung sie akzeptiert hat.

Bei fehlender `EmailRechnung` wird die Rechnung nicht versendet. Bei einem SMTP-Fehler kann die XML bereits festgeschrieben sein, weil die Festschreibung vor dem eigentlichen Versand erfolgt. Korrigieren Sie zuerst die Ursache und prüfen Sie den bisherigen Versandstatus, bevor Sie die einzelne Rechnung erneut senden. Ein erneuter Versand erzeugt eine weitere Nachricht.

Auch nach einem fehlerfreien Sammellauf sind übersprungene beziehungsweise fehlerhafte Einzelrechnungen gesondert zu bearbeiten. Hinweise: [Prüfen, Protokolle und Fehler](pruefung.md).
