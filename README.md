# FLEET E-Rechnung – Dokumentation

Öffentliche deutschsprachige Dokumentation zum Produkt [fleet-erechnung-vs](https://github.com/harzmann/fleet-erechnung-vs).

- [Dokumentationsportal](https://harzmann.github.io/fleet-erechnung-vs-docs/)
- [Endanwender-Handbuch](docs/handbuch/index.md)
- [Vorbereitung und Stammdaten](docs/vorbereitung/index.md)
- [Interne Quellenzuordnung](maintainer/bezugsstand.md) (außerhalb des Kundenportals)

Dieses Repository stellt Dokumentation bereit. Es enthält keine Software-Releases oder Release-Downloads.

## Lokal prüfen

Python 3.11 verwenden:

```powershell
python -m pip install -r requirements.txt
python -m mkdocs build --strict
python tools/check_site.py
python -m mkdocs serve
```

`site/` ist ein ignoriertes Build-Verzeichnis. GitHub Actions prüft Pull Requests und veröffentlicht `main` über GitHub Pages. In den Repository-Einstellungen muss Pages auf **GitHub Actions** eingestellt sein. Der Pages-Workflow benötigt ausschließlich Leserechte für Inhalte und im Deployment Schreibrechte für Pages sowie ein OIDC-Token; er erstellt keine Releases.

Die Quellenzuordnung und SHA-256-Werte des geprüften Produkt-Arbeitsstands stehen in `source-register.json`. Produktcode, produktive Datenbankinhalte und lokale Verbindungsdaten werden nicht übernommen. Interne [Pflegehinweise](maintainer/pflege.md) liegen außerhalb von `docs/` und werden nicht im Kundenportal veröffentlicht.

Die neun Original-Anwendungsaufnahmen verwenden ausschließlich fiktive Daten aus getrennten Demo-Fixtures. [Screenshot-Host, Demo-SQL und Reproduktion](tools/screenshots/README.md) sowie das [Bildregister](docs/assets/screenshots/manifest.json) liegen im Repository; Build-Ausgaben und Datenbankdateien werden nicht veröffentlicht.
