# FLEET E-Rechnung – Dokumentation

Öffentliche deutschsprachige Dokumentation zum Produkt [fleet-erechnung-vs](https://github.com/harzmann/fleet-erechnung-vs).

- [Dokumentationsportal](https://harzmann.github.io/fleet-erechnung-vs-docs/)
- [Endanwender-Handbuch](docs/handbuch/index.md)
- [Vorbereitung und Stammdaten](docs/vorbereitung/index.md)
- [Bezugsstand und bekannte Grenzen](docs/referenz/bezugsstand.md)

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

Die Quellenzuordnung und SHA-256-Werte des geprüften Produkt-Arbeitsstands stehen in `source-register.json`. Produktcode, Datenbankinhalte und lokale Verbindungsdaten werden nicht übernommen. Pflegehinweise: [Dokumentation pflegen](docs/referenz/pflege.md).
