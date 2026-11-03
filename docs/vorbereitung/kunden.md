# Kunden und Rechnungsdaten

Kunden- und Rechnungsangaben werden aus dem vorhandenen FLEET-Datenbestand gelesen. In der geprüften E-Rechnungsübersicht gibt es keinen eigenen Kundeneditor. Verwenden Sie die zuständige Kunden- beziehungsweise Rechnungspflege im Hauptsystem; ein bestimmter Menüpfad außerhalb dieses Moduls ist hier nicht belegt.

## Welche Angaben müssen vorbereitet sein?

| Angabe | Verwendung | Anforderung |
| --- | --- | --- |
| **KundenNr** | Zuordnung des Kunden und Käuferkennung | Muss zum Beleg passen |
| **Firma**, Rechnungsanschrift, Postleitzahl, Ort | Käufername und Rechnungsadresse aus den Rechnungsabfragen | Für einen vollständigen Beleg vorbereiten; nicht nur den aktuellen Kundenstamm betrachten |
| **FirmaOderAbteilung** | Zusätzliche Angabe aus der Rechnungsabfrage; im Export als regionale Untergliederung übergeben | Tatsächliche XML auf passende fachliche Bedeutung prüfen |
| **LandISO** | Käuferland | Vom Programm vor der XML-Erzeugung ausdrücklich auf Leerwert geprüft; gültigen zweistelligen Ländercode verwenden, etwa `DE`, `AT` oder `NL` |
| **EmailRechnung** | Elektronische Käuferadresse mit Schema `EM` und Versandempfänger | Vom Programm auch für einen neuen reinen XML-Export verlangt; gültige, abgestimmte Rechnungsadresse eintragen |
| **UStIdNr** | Umsatzsteuer-ID des Käufers aus dem Belegbestand | Abhängig vom Geschäftsfall, insbesondere bei entsprechenden steuerfreien oder Reverse-Charge-Umsätzen prüfen |
| **LieferantenNr** | Ihre Lieferantennummer beim Kunden; als Verkäuferkennung ausgegeben | Nach Empfängervorgabe pflegen |
| **LeitwegeID** | Käuferreferenz BT-10 | Richtige Empfängerreferenz eintragen; insbesondere behördliche Empfänger vorab nach ihrer Vorgabe fragen |

!!! warning "Nicht leer ist nicht gleich gültig"
    `LandISO` und `EmailRechnung` werden zunächst nur auf fehlenden Inhalt geprüft. Bei einem nicht erkannten Ländercode kann der Exporter intern auf DE zurückfallen. Prüfen Sie den Code daher vorab und kontrollieren Sie das Land in der XML. Ein erfolgreicher Export bestätigt keine korrekte Empfängeradresse.

## Käuferreferenz und Leitweg-ID

Wenn `LeitwegeID` gefüllt ist, wird sie als Käuferreferenz verwendet. Ist das Feld leer, setzt der Exporter stattdessen die formatierte Rechnungsnummer ein. Dieser technische Ersatz ist keine Zusage, dass der Empfänger die Rechnung damit annimmt. Eine verlangte Leitweg-ID oder andere verbindliche Käuferreferenz muss inhaltlich mit dem Empfänger abgestimmt sein.

Die elektronische Käuferadresse wird als E-Mail mit Schema `EM` ausgegeben. Die Leitweg-ID wird dabei nicht automatisch als elektronische Adresse eines anderen Schemas eingesetzt.

## Rechnungs- und Zahlungsangaben

Prüfen Sie vor der ersten Ausgabe Rechnungsnummer, Rechnungsdatum und Lieferdatum. Die XML wird mit **EUR** als Währung erzeugt. Ein anderer Währungsfall wird durch dieses Modul im geprüften Stand nicht abgebildet.

Die Zahlungsbedingungen stammen aus `NettoTage`, `SkontoTage` und `SkontoProzent` der Rechnungsabfrage. Das Nettofälligkeitsdatum wird aus Rechnungsdatum plus Nettotagen gebildet. Skonto wird nur ergänzt, wenn Tage und Prozentsatz größer als null sind. Prüfen Sie diese Angaben zusammen mit der Bankverbindung in der Vorschau und der XML.

Positionen benötigen Menge, Preis, Nettobetrag, Mengeneinheit sowie die zutreffende Steuerkategorie und den Steuersatz. Eine nachträgliche Änderung eines Stammdatensatzes garantiert nicht, dass bereits übernommene Rechnungsdetails aktualisiert werden. Kontrollieren Sie deshalb auch die konkrete Rechnung.

## Nach einer Änderung

Laden Sie die betreffende Rechnungsart neu beziehungsweise öffnen Sie die Übersicht erneut. Prüfen Sie eine noch nicht festgeschriebene Rechnung über **Validator**. Eine bereits festgeschriebene XML bleibt inhaltlich gespeichert; der Duplikat-Export baut sie nicht aus den korrigierten Kundendaten neu auf.

Weiter: [Mengeneinheiten](mengeneinheiten.md), [Steuersätze](steuersaetze.md) und [erste Rechnung prüfen](checkliste.md).
