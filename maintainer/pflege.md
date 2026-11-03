# Dokumentation pflegen

## Inhalte aktualisieren

Prüfen Sie bei einer Produktänderung die betroffenen Formulare, Ereignisbehandlungen und Datenflüsse. Aktualisieren Sie anschließend die zusammengehörigen Kapitel beider Handbücher. Veraltete technische Kommentare sind keine ausreichende Grundlage für eine Bedienanleitung.

Behalten Sie die Trennung bei: tägliche Bedienung im Endanwender-Handbuch, Einrichtung und Feldzuordnung im Vorbereitungshandbuch, bekannte Grenzen im Bezugsstand. Bildschirmbezeichnungen werden so wiedergegeben, wie sie in der geprüften Oberfläche stehen.

## Bezugsstand nachführen

Aktualisieren Sie Datum, Produkt-Commit und die Beschreibung lokaler Abweichungen. Erzeugen Sie neue Prüfsummen der tatsächlich herangezogenen Dateien im `source-register.json`. Ein Fingerabdruck ersetzt keinen archivierten Quellstand; führen Sie bei einem späteren regulären Produkt-Commit das Handbuch auf diesen nachvollziehbaren Stand nach.

Prüfen Sie bei Bibliothekswechseln die Enumwerte und die Serialisierung im tatsächlich referenzierten Paket. Der separate Bibliotheksordner im Produktrepo ist keine sichere Aussage über die verwendete Paketversion.

## Quellen und Beispiele nachprüfen

Verlinken Sie offizielle Listen direkt beim jeweiligen Thema. Prüfen Sie bei geänderten Steuerregeln insbesondere die Kategorie, die Zulässigkeit von Befreiungsgründen und die konkrete VATEX-Schreibweise. Ergänzen Sie keine erfundenen Standardcodes. Halten Sie Anwendungsfeld und offiziellen XML-Wert auseinander.

Die Beispiele dürfen keine echten Kundendaten, Zugangsdaten, Datenbankverbindungen oder produktiven Rechnungsdateien enthalten. Neue Bildschirmbilder müssen vollständig auf solche Inhalte geprüft sein.

## Build und Veröffentlichung

Im Repository-Hauptverzeichnis (interne Anleitung; nicht Bestandteil des Kundenportals):

```powershell
python -m pip install -r requirements.txt
python -m mkdocs build --strict
python tools/check_site.py
python -m mkdocs serve
```

Prüfen Sie Navigation, Suche, Tabellen und schmale Bildschirmdarstellung. Der Linkprüfer kontrolliert lokale Ziele und Anker des erzeugten Portals; externe Quellen werden bei der fachlichen Pflege separat aufgerufen.

Pull Requests führen den Build und die lokalen Prüfungen ohne Veröffentlichung aus. Änderungen auf `main` veröffentlichen das fertige Portal über GitHub Actions und GitHub Pages. Kontrollieren Sie nach einer Veröffentlichung die Startseite und die geänderten Kapitel.

Software-Releases, Release-Assets und Download-Navigation gehören nicht zu diesem Repository. `site/` bleibt ein Build-Verzeichnis und wird nicht als Quellinhalt eingecheckt.
