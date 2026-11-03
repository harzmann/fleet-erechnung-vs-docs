# Mengeneinheiten und Umrechnung

Öffnen Sie **Stammdaten → Mengeneinheiten**. Hier ordnen Sie vorhandenen internen Mengeneinheiten einen Code für die strukturierte E-Rechnung und einen Umrechnungsfaktor zu.

## Felder und Speicherung

| Feld | Bedeutung |
| --- | --- |
| `MengeneinheitK` | Internes Kürzel; der Exporter sucht die Zuordnung anhand dieses Kürzels |
| `MengeneinheitL` | Interne Langbezeichnung |
| `ERechnung_UnitCode` | Standardcode der im Export ausgegebenen Einheit |
| `ERechnung_UnitConversion` | Faktor von der internen Menge zur Exportmenge; bis zu sechs Nachkommastellen |

Nur die beiden gelben E-Rechnung-Felder können geändert werden. Die Filterzeile hilft beim Auffinden eines Kürzels. Übernehmen Sie einen Zellwert beispielsweise durch Wechsel in eine andere Zelle. Dadurch wird die Änderung direkt in der Datenbank gespeichert. Ein eigener Speichern-Schalter ist nicht vorgesehen. Neue Grundeinheiten werden in diesem Fenster nicht angelegt oder gelöscht.

## Reale und unterstützte Codes

Die Codes stammen aus UN/ECE Recommendation 20. Die [offizielle UNECE-Übersicht](https://unece.org/code-list-recommendations) führt zu den Originalverzeichnissen; die [Peppol-Liste für Rechnungseinheiten](https://docs.peppol.eu/poacc/billing/3.0/codelist/UNECERec20/) ist direkt durchsuchbar. Die folgende Auswahl ist zugleich im geprüften `QuantityCodes`-Enum des Produkts vorhanden.

| Einheit | `ERechnung_UnitCode` | Beispiel einer Zuordnung ohne Umrechnung | Faktor |
| --- | --- | --- | --- |
| Stück / Anzahl | `C62` | Interne Einheit Stk. → Anzahl | `1` |
| Liter | `LTR` | Kraftstoff oder Flüssigkeit in Litern → Liter | `1` |
| Stunde | `HUR` | Arbeitszeit in Stunden → Stunde | `1` |
| Minute | `MIN` | Arbeitszeit in Minuten → Minute | `1` |
| Kilogramm | `KGM` | Masse in Kilogramm → Kilogramm | `1` |
| Kilowattstunde | `KWH` | Energiemenge in kWh → Kilowattstunde | `1` |

Verwenden Sie die ausgeschriebenen Codes aus dieser Tabelle. Das Programm kennt zwar einige Kürzel-Aliasse, aber die vollständige offizielle Liste ist größer als die implementierte Auswahl. Ein gültiger Code aus der offiziellen Liste ist dadurch noch nicht automatisch in dieser Produktversion unterstützt.

!!! warning "Unbekannte Codes können unbemerkt zu Stück werden"
    Leere, unbekannte oder nicht unterstützte Unitcodes fallen im geprüften Exporter auf `C62` zurück. Bei fehlender Zuordnung oder einem Abfragefehler werden ebenfalls `C62` und Faktor 1 verwendet. Ein Faktor 0 wird intern durch 1 ersetzt. Pflegen Sie deshalb einen passenden Code und einen positiven, fachlich richtigen Faktor ausdrücklich; ein erfolgreicher Export allein erkennt eine falsche Einheit nicht.

## So wirkt der Faktor

```text
Exportmenge = Ausgangsmenge × ERechnung_UnitConversion
Exportpreis je Einheit = Ausgangspreis ÷ ERechnung_UnitConversion
```

Der Faktor ist keine Preis- oder Rabattkorrektur. Er beschreibt, wie viele Exporteinheiten einer internen Einheit entsprechen. Bei unveränderter Einheit ist er 1.

### Beispiel 1: Liter ohne Umrechnung

Interne Menge **50 Liter**, Nettopreis **1,80 EUR/Liter**, Code `LTR`, Faktor **1** ergeben **50 Liter** zu **1,80 EUR/Liter**. Der Betrag beträgt **90,00 EUR**.

### Beispiel 2: Stunden als Minuten ausgeben

Interne Menge **1,5 Stunden**, Nettopreis **120,00 EUR/Stunde**, Code `MIN`, Faktor **60**:

| Rechnung | Ergebnis |
| --- | --- |
| Menge: 1,5 × 60 | 90 Minuten |
| Preis: 120,00 ÷ 60 | 2,00 EUR/Minute |
| Kontrolle: 90 × 2,00 | 180,00 EUR |

### Beispiel 3: Minuten als Stunden ausgeben

Interne Menge **90 Minuten**, Nettopreis **2,00 EUR/Minute**, Code `HUR`, mathematischer Faktor **1/60**. Bei sechs gespeicherten Nachkommastellen kann **0,016667** verwendet werden. Daraus entstehen vor Rundung ungefähr **1,50003 Stunden** und **119,9976 EUR/Stunde**, bei zwei Nachkommastellen also **1,50 Stunden** und **120,00 EUR/Stunde**.

Dieser angenäherte Faktor muss mit realen Positionsmengen geprüft werden. Bei nur einer Ausgangsminute würde die gerundete Menge **0,02 Stunden** betragen; deren Produkt mit 120,00 EUR ist **2,40 EUR** statt 2,00 EUR. Für solche Fälle ist die Ausgabe in `MIN` mit Faktor 1 häufig die passende Abbildung, wenn der Empfänger sie akzeptiert.

## Rundung und Betrag prüfen

Der Exporter rundet Menge und Einzelpreis getrennt, bei normalen Positionen auf zwei Nachkommastellen. Bei als Tankposition erkannten Daten werden drei Nachkommastellen für die Menge und vier für den Einzelpreis verwendet. Gerundet wird kaufmännisch, bei halben Schritten von null weg.

Der Positionsnettobetrag wird aus dem Beleg übernommen und nicht einfach durch das gerundete Produkt ersetzt. Weichen Menge × Preis und Belegbetrag voneinander ab, können Rabatte oder Rundungen eine Rolle spielen und Validierungsfehler entstehen. Prüfen Sie deshalb sowohl die Einheit als auch die Zahlen im fertigen Beleg.

Nach jeder geänderten Zuordnung mindestens eine passende Rechnung über **Validator** prüfen und Menge, Preis sowie Nettobetrag vergleichen. Weiter: [Steuersätze](steuersaetze.md).
