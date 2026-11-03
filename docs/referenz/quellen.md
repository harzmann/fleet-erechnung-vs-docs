# Offizielle Quellen und Begriffe

Die folgenden Quellen wurden für die Code- und Feldbeschreibungen am **3. November 2026** geprüft. Die Peppol-Seiten kennzeichnen den bei der Prüfung angezeigten Stand als **May 2026 Release**. Die jeweiligen Regeln und Listen können später fortgeschrieben werden. Die Unterstützung im Produkt richtet sich zusätzlich nach seiner Bibliothek und der installierten Validator-Konfiguration.

## Mengeneinheiten

| Quelle | Wofür verwenden? |
| --- | --- |
| [UNECE – Code List Recommendations](https://unece.org/code-list-recommendations) | Offizieller Herausgeber und Zugang zu Recommendation 20 mit Originalverzeichnissen |
| [OpenPeppol – Recommendation 20 einschließlich Recommendation 21](https://docs.peppol.eu/poacc/billing/3.0/codelist/UNECERec20/) | Direkt lesbare Liste der Rechnungseinheiten; Recommendation-21-Verpackungscodes werden mit X-Präfix geführt |

Die sechs im Handbuch verwendeten Codes sind im Produkt geprüft. Die vollständige offizielle Liste ist keine vollständige Zusage der Unterstützung durch diese Anwendung. Erläuterungen: [Mengeneinheiten und Umrechnung](../vorbereitung/mengeneinheiten.md).

## Steuerkategorien und Befreiungsgründe

| Quelle | Wofür verwenden? |
| --- | --- |
| [OpenPeppol – UNCL5305-Auswahl](https://docs.peppol.eu/poacc/billing/3.0/codelist/UNCL5305/) | Reale Umsatzsteuerkategorien wie S, Z, E, AE, K, G und O |
| [OpenPeppol – VATEX](https://docs.peppol.eu/poacc/billing/3.0/codelist/vatex/) | Offizielle Befreiungsgrundcodes mit Bindestrichen |
| [BT-151 – Umsatzsteuerkategorie der Position](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-InvoiceLine/cac-Item/cac-ClassifiedTaxCategory/cbc-ID/) | Bedeutung der Kategorie auf Positionsebene |
| [BT-120 – Befreiungsgrundtext](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-TaxTotal/cac-TaxSubtotal/cac-TaxCategory/cbc-TaxExemptionReason/) | Textdefinition und Regeln je Steuerkategorie |
| [BT-121 – Befreiungsgrundcode](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-TaxTotal/cac-TaxSubtotal/cac-TaxCategory/cbc-TaxExemptionReasonCode/) | Codedefinition und Bezug zur VATEX-Liste |
| [KoSIT – XRechnung](https://xeinkauf.de/xrechnung/) | Offizielle Informationen zum deutschen Standard XRechnung |

Die UBL-Quellen passen zur im geprüften Exporter verwendeten XML-Syntax. Die tatsächlichen FLEET-Eingaben und Besonderheiten erläutert das Kapitel [Steuersätze und BT-Felder](../vorbereitung/steuersaetze.md).

## Begriffe

| Begriff | Bedeutung in diesem Handbuch |
| --- | --- |
| BT | Business Term: fachlich definiertes Element einer strukturierten Rechnung |
| BG | Business Group: zusammengehörige fachliche Rechnungsangaben |
| UBL | XML-Syntax, in der das geprüfte Programm die XRechnung schreibt |
| Hybrid-PDF | PDF-Datei mit eingebetteter Rechnungs-XML; keine alleinige Aussage über ein bestimmtes Konformitätsprofil |
| Festschreibung / `Issued` | Verarbeitung zur dauerhaften Speicherung der erzeugten XML und Statusänderung im Produkt |
| Duplikat | Erneute Ausgabe beziehungsweise Verarbeitung einer bereits festgeschriebenen Rechnung aus gespeichertem XML-Bestand |
| UTC | Weltzeit; Anzeige von Laufzeiten und Protokollzeitpunkten von lokaler Windows-Zeit unterscheiden |

## Produktquellen

Die Bedienbeschreibungen basieren auf [fleet-erechnung-vs](https://github.com/harzmann/fleet-erechnung-vs), nicht auf dem getrennten Hybridviewer-Projekt. [Bezugsstand und Quellenzuordnung](bezugsstand.md) nennen die maßgeblichen Bereiche und die lokalen Abweichungen. Die Bibliotheksprüfung berücksichtigt das im Viewer-Projekt referenzierte NuGet-Paket `ZUGFeRD-csharp` in Version `17.4.0`.
