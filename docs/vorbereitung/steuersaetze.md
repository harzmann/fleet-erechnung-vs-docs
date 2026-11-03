# Steuersätze und BT-Felder

Öffnen Sie **Stammdaten → Steuersätze**. Das Fenster ergänzt vorhandene Steuersätze um die Angaben für die E-Rechnung. Es entscheidet nicht, welcher Umsatz steuerpflichtig, steuerfrei oder dem Reverse-Charge-Verfahren zuzuordnen ist; diese Zuordnung muss fachlich vorgegeben sein.

## Die drei Felder richtig unterscheiden

| Feld in FLEET | Fachliche Bedeutung | Eingabe |
| --- | --- | --- |
| `ERechnung_BT151` | Umsatzsteuerkategorie der Rechnungsposition, BT-151 | Kategoriecode, beispielsweise `S` oder `AE` |
| `ERechnung_BT120` | Steuerbefreiungsgrund als **Text**, BT-120 | Passender Grund in Worten, soweit für die Kategorie verlangt |
| `ERechnung_BT121` | Steuerbefreiungsgrund als **Code**, BT-121 | Unterstützter VATEX-Enumname, beispielsweise `VATEX_EU_AE` |

BT steht für „Business Term“, also ein fachlich definiertes Rechnungselement. Der Prozentsatz ist eine weitere Angabe: BT-151 ist kein Feld für `19` oder `7`. Auf Summenebene wird die Steuerkategorie als BT-118 ausgegeben. BT-120 und BT-121 gehören dort zur Steueraufschlüsselung; FLEET übernimmt sie aus den betreffenden Positionsdaten.

Die offizielle Zuordnung beschreibt [BT-120 als Text](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-TaxTotal/cac-TaxSubtotal/cac-TaxCategory/cbc-TaxExemptionReason/) und [BT-121 als Code](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-TaxTotal/cac-TaxSubtotal/cac-TaxCategory/cbc-TaxExemptionReasonCode/). Eine ältere technische Projektdokumentation vertauscht diese Begriffe; für dieses Handbuch gilt die oben gezeigte korrekte Zuordnung.

## Beispiele für reale Steuerkategorien

Die Codes sind in der [offiziellen Peppol-Auswahl aus UNCL5305](https://docs.peppol.eu/poacc/billing/3.0/codelist/UNCL5305/) definiert. Die folgenden Zahlen und Texte sind Konfigurationsbeispiele für fachlich bereits bestätigte Fälle, keine pauschale Zuordnung aller FLEET-Leistungen.

| Fall | BT-151 | Steuersatz im Beleg | BT-120: Beispieltext | BT-121: Anwendungseingabe |
| --- | --- | --- | --- | --- |
| Umsatz mit regulärer positiver Umsatzsteuer, etwa freigegeben mit 19 % | `S` | 19 % | leer | leer |
| Umsatz mit freigegebenem ermäßigtem positiven Satz, etwa 7 % | `S` | 7 % | leer | leer |
| Gesetzlich mit Nullsatz besteuerter Umsatz | `Z` | 0 % | leer | leer |
| Tatsächlich befreite Krankenhaus-/Heilbehandlung nach dem einschlägigen Befreiungstatbestand; nur als besonderes Beispiel | `E` | 0 % | Steuerbefreite Krankenhausbehandlung | `VATEX_EU_132_1B` |
| Reverse Charge | `AE` | 0 % | Steuerschuldnerschaft des Leistungsempfängers | `VATEX_EU_AE` |
| Innergemeinschaftliche Lieferung bei erfüllten Voraussetzungen | `K` | 0 % | Steuerfreie innergemeinschaftliche Lieferung | `VATEX_EU_IC` |
| Ausfuhr außerhalb der EU bei erfüllten Voraussetzungen | `G` | 0 % | Steuerfreie Ausfuhrlieferung | `VATEX_EU_G` |
| Umsatz außerhalb des Umsatzsteuer-Anwendungsbereichs | `O` | In der XML kein Umsatzsteuersatz auszuweisen | Nicht im Anwendungsbereich der Umsatzsteuer | `VATEX_EU_O` |

Die Codes der letzten Spalte stehen in der implementierten VATEX-Auswahl. Das besondere `E`-Beispiel ist kein geeigneter allgemeiner Befreiungscode für Werkstattleistungen, Kraftstoff oder beliebige steuerfreie Umsätze. Wählen Sie den tatsächlich einschlägigen Grund aus der [offiziellen VATEX-Liste](https://docs.peppol.eu/poacc/billing/3.0/codelist/vatex/) und prüfen Sie seine Unterstützung in der eingesetzten Produktversion. Für `E` ist nach den genannten Regeln auch ein zutreffender Grundtext ohne Code möglich.

**Nullsatz (`Z`), Steuerbefreiung (`E`) und außerhalb des Anwendungsbereichs (`O`) sind unterschiedliche Fälle.** Leiten Sie die Kategorie nicht allein aus einem Betrag von 0 % ab. Bei `O` muss insbesondere geprüft werden, dass das Programm keinen unzulässigen Steuersatz in der fertigen XML ausgibt.

## Anwendungseingabe und XML-Code

Im geprüften Exporter akzeptiert `BT121` nur exakt vorhandene Enum-Namen. Deshalb verwenden Sie im Stammdatenfeld die Schreibweise mit Unterstrichen und der gezeigten Großschreibung:

| Eingabe in `ERechnung_BT121` | Offizieller Code in der XML |
| --- | --- |
| `VATEX_EU_AE` | `VATEX-EU-AE` |
| `VATEX_EU_IC` | `VATEX-EU-IC` |
| `VATEX_EU_G` | `VATEX-EU-G` |
| `VATEX_EU_O` | `VATEX-EU-O` |
| `VATEX_EU_132_1B` | `VATEX-EU-132-1B` |

Die Serialisierung ersetzt Unterstriche durch Bindestriche. Eine Eingabe wie `VATEX-EU-AE` direkt im Stammdatenfeld wird vom vorgeschalteten Parser dagegen nicht als Enumname erkannt; der Code kann dann entfallen. Kontrollieren Sie die ausgegebene XML beziehungsweise den Validator-Bericht, nicht nur den gespeicherten Zellwert.

## Regeln für Befreiungsgründe

- Bei **S** und **Z** bleiben BT-120 und BT-121 leer. Die Regeln BR-S-10 und BR-Z-10 verbieten dort Befreiungsgründe.
- Bei **E** ist ein fachlich passender Grundtext oder Grundcode erforderlich.
- Bei **AE**, **K**, **G** und **O** muss der Grund zur Kategorie passen; ein beliebiger VATEX-Code genügt nicht.

Die zugehörigen Einzelregeln sind direkt bei der [offiziellen BT-120-Definition](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-TaxTotal/cac-TaxSubtotal/cac-TaxCategory/cbc-TaxExemptionReason/) verlinkt. Weitere Regeln können je Kategorie zum Beispiel steuerliche Identifikationen oder Lieferangaben verlangen.

## So pflegen Sie einen Steuersatz

1. Suchen Sie den richtigen Steuersatz anhand **Matchcode**, **Kurzbezeichnung** und **MwSt**.
2. Tragen Sie in die gelbe Spalte `ERechnung_BT151` den passenden Kategoriecode ein.
3. Tragen Sie, falls erforderlich, den zutreffenden Grundtext in `ERechnung_BT120` und den unterstützten Code in `ERechnung_BT121` ein.
4. Übernehmen Sie jede Zelle durch Wechsel in eine andere Zelle. Die Änderung wird sofort gespeichert.
5. Prüfen Sie die konkrete Rechnung und deren bereits gespeicherte Positionswerte. Eine Stammdatenkorrektur aktualisiert vorhandene Details nicht nachweislich automatisch.
6. Validieren Sie eine einzelne noch nicht festgeschriebene Rechnung dieser Kategorie und vergleichen Sie Steuerbetrag und Steueraufschlüsselung.

ID, Matchcode, Kurzbezeichnung und **MwSt** sind hier schreibgeschützt. Der eigentliche Prozentsatz ist in der zuständigen Steuersatzpflege des Hauptsystems zu ändern. Neue Steuersätze lassen sich in diesem Fenster nicht anlegen.

## Besonderheiten der Implementierung

Ein ungültiger Kategoriecode fällt auf `S` zurück. Bei `S` entfernt der Exporter vorhandene Befreiungsgründe. Bei `Z` erfolgt diese automatische Bereinigung nicht; löschen Sie die Gründe dort selbst.

Für `AE`, `K`, `G` und `O` ergänzt der Exporter bei fehlenden Werten englische Standardtexte und Codes mit Bindestrichen. Die automatische Codesetzung durchläuft jedoch denselben Parser, der Enum-Namen mit Unterstrichen erwartet. Verlassen Sie sich deshalb nicht darauf, dass dadurch tatsächlich ein VATEX-Code in der XML ankommt. Pflegen und prüfen Sie die Angaben ausdrücklich.

Die Standardlogik setzt in der Steueraggregation außerdem den Prozentsatz für diese vier Kategorien auf null, nachdem Positionsdaten bereits übergeben wurden. Sie ersetzt keinen korrekt gepflegten Positionssteuersatz. Die volle Eignung eines Sonderfalls ist mit dem tatsächlichen Beleg zu prüfen; dieses Handbuch behauptet keine pauschale Konformität aller Kategorien.
